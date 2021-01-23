# encoding: UTF-8
# frozen_string_literal: true
require 'yaml'

class Film
class << self

  # Retourne l'instance du film courant
  def current
    @current ||= new(File.join(folder,get_dossier_current))
  end

  # Retourne le film courant
  # ------------------------
  # L'idée est qu'il y en aura toujours un, que ce soit le film défini par
  # CURRENT et qui existe, que ce soit le film par défaut xDefaut ou que ce
  # soit le premier dossier trouvé
  def get_dossier_current
    fdossier = nil
    if File.exists?(path_current_def)
      fdossier = File.read(path_current_def).strip
    end
    return fdossier if fdossier && isFolderFilm?(fdossier)
    # Sinon, le premier dossier
    fdossier = get_first_directory
    return fdossier if fdossier && isFolderFilm?(fdossier)
    # Sinon, le dossier par défaut
    return 'xDefault' if isFolderFilm?('xDefault')
    # Sinon un problème
    raise "Malheureusement, il est impossible de trouver un film… Et le dossier par défaut a été détruit. Il faut réinitialiser l'application."
  end #/ get_current

  # Retourne true si +fdossier+ est effectivement un dossier de film analysé
  def isFolderFilm?(fdossier)
    File.exists?(File.join(folder,fdossier))
  end

  # Mets le film +folder+ en film courant
  def set_current(fdossier)
    File.open(path_current_def,'wb'){|f|f.write(fdossier)}
  end

  # Retourne le chemin d'accès complet au dossier de nom +fdossier+
  def full_path(fdossier)
    File.join(folder,fdossier)
  end #/ full_path

  # Retourne le premier dossier qu'on trouve
  def get_first_directory
    Dir["#{folder}/*"].each do |p|
      pname = File.basename(p)
      return pname if File.directory?(p) && pname != 'xDefault'
    end
    return nil
  end #/ get_first_directory
  def path_current_def
    @path_current_def ||= File.join(folder,'CURRENT')
  end
  def folder
    @folder ||= File.join(APP_FOLDER,'_FILMS_')
  end #/ folder
end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :folder
attr_accessor :duration
def initialize(folder)
  @folder = File.expand_path(folder)
  require_module('backup') && backup unless File.exists?(backup_today_path)
end

# Si la vidéo définie n'existe pas dans le dossier, on la récupère
# Si elle est introuvable, on raise
def retrieving_video_required?
  return if File.exists?(video_path)
  File.exists?(config['video']['original_path']) || raise("La vidéo n'est pas dans le dossier et il est impossible de retrouver l'original (#{config['video']['original_path']})")
  Ajax << {require_retrieve_video: true}
end

def audio_file_required?
  return if File.exists?(audio_path)
  Ajax << {require_audio_file: true}
end

def retrieve_video
  FileUtils.copy(config['video']['original_path'], video_path)
end #/ retreive_video

def product_audio_file
  ref_path = File.exists?(video_path) ? video_path : original_video_path
  cmd = "/usr/local/bin/ffmpeg -loglevel warning -i '#{ref_path}' -vn '#{audio_path}'"
  Ajax << {command_audio_file: cmd}
  res = `#{cmd} 2>&1`
  fois = 0
  begin
    sleep 1
    fois += 1
    if fois > 45
      Ajax << {ok:false, retour_audio_ffmpeg: res, message:"La production du fichier audio prend trop de temps…" }
      break
    end
  end until File.exists?(audio_path)
  Ajax << {ok:true, command:cmd, retour_audio_ffmpeg: res}
end

def exec_as_su
  # `echo "<mot de passe>" | sudo -S <code à exécuter>`
end #/ exec_as_su

def personnages
  require_module('Personnage') # écrasera cette méthode
  personnages
end #/ personnages

def open_in_finder
  `open -a Finder "#{folder}"`
end
def title
  @title ||= config['title_fr']||config['title']
end

def config
  YAML.load_file(config_path).merge!(film_folder: File.basename(folder))
end #/ config
def save_config(config)
  File.open(config_path,'wb'){|f| f.write(YAML.dump(config))}
end
def save_event(data)
  File.open(File.join(folder_events,"event-#{data['id']}.yml"),'wb') do |f|
    f.write(YAML.dump(data))
  end
end
def save_locator(data)
  File.open(File.join(locators_folder,"locator-#{data['id']}.yml"),'wb') do |f|
    f.write(YAML.dump(data))
  end
end

# Pour détruire un évènement
def destroy_event(id)
  path = File.join(folder_events,"event-#{id}.yml")
  File.delete(path) if File.exists?(path)
end
def destroy_locator(id)
  path = File.join(locators_folder,"locator-#{id}.yml")
  File.delete(path) if File.exists?(path)
end
def get_events(filtre = nil)
  if filtre.nil?
    Dir["#{folder_events}/*.yml"].collect{|f| YAML.load_file(f) }
  else
    goods = []
    Dir["#{folder_events}/*.yml"].each do |f|
      dae = YAML.load_file(f)
      if filtre[:type]
        next if dae['type'] != filtre[:type] && dae['type'].split(':')[0] != filtre[:type]
      end
      goods << dae
    end
    return goods
  end
end
def get_locators
  Dir["#{locators_folder}/*.yml"].collect{|f| YAML.load_file(f) }
end

# Retourne la liste des paths de documents tels que définis dans le
# fichier de configuration.
# Noter qu'il peut y avoir des fichiers déjà formatés, comme les statistiques
# par exemple ou le séquencier.
def documents
  @documents ||= (config['documents']||[]).collect do |name|
    if File.extname(name).start_with?('.htm')
      File.join(folder_products,name)
    else
      File.join(folder_documents,name)
    end
  end
end

# Pour ajouter un document au fichier config
def add_document_to_config(name)
  conf = config.dup
  conf.key?('documents') || conf.merge!('documents' => [])
  conf['documents'] << name
  save_config(conf)
end

# ---------------------------------------------------------------------
#
#   TEMPS CALCULATIONS
#
# ---------------------------------------------------------------------

# Le "zéro" du film correspond au temps du noeud clé "ZéroPoint" s'il est
# défini. C'est le temps qu'il faut retirer à tous les temps pour obtenir
# une valeur juste.
def zero
  @zero ||= begin
    point_zero = get_events(type:'nc:zr').first
    log("point_zero: #{point_zero}")
    if point_zero.nil?
      0
    else
      log("point_zero['time'] = #{point_zero['time']}::#{point_zero['time'].class.name}")
      point_zero['time'].to_f
    end
  end
end #/ zero
# Retourne la durée du film
# Note : soit c'est le point défini par l'event de type 'zr', soit 0
# soit c'est le point défini par l'event de type 'pf' soit la durée de la
# vidéo. NON : on produit une erreur
def duration
  @duration ||= begin
    dataZPoint = nil
    dataFPoint = nil
    get_events.each do |devent|
      if devent['type'] == 'nc:zr'
        dataZPoint = devent
      elsif devent['type'] == 'nc:pf'
        dataFPoint = devent
        break
      end
    end
    unless dataZPoint && dataFPoint
      raise "Impossible de calculer la durée du film, les points Zéro et Final ne sont pas définis les deux."
    end
    (dataFPoint['time'].to_f - dataZPoint['time'].to_f).to_i
  end
end #/ duration

def duration_scenes
  @duration_scenes ||= begin
    require_module('Scenes')
    sorted_scenes.inject(0){|sum,scene| sum + scene.duree}
  end
end #/ duration_scenes

# ---------------------------------------------------------------------
#
#   PATHS
#
# ---------------------------------------------------------------------

def original_video_path
  @original_video_path ||= config['video']['original_path']
end
# Chemin d'accès à la vidéo dans le dossier du film (pas l'originale)
def video_path
  @video_path ||= File.join(folder, video_name)
end

def audio_path
  @audio_path ||= File.join(folder, audio_name)
end
def audio_name
  audio_name ||= "#{File.basename(video_name,File.extname(video_name))}.mp3"
end

def video_name
  @video_name ||= config['video']['name']
end #/ video_name


def folder_events
  @folder_events ||= mkdir(File.join(folder,'events'))
end
def locators_folder
  @locators_folder ||= mkdir(File.join(folder,'locators'))
end
def folder_documents
  @folder_documents ||= mkdir(File.join(folder,'documents'))
end
def folder_products
  @folder_products ||= mkdir(File.join(folder,'products'))
end
def folder_finaux
  @folder_finaux ||= mkdir(File.join(folder,'livres'))
end
alias :folder_livres :folder_finaux
def folder_backups
  @folder_backups ||= mkdir(File.join(folder,'xbackups'))
end
def config_path
  @config_path ||= File.join(folder, 'config.yml')
end
def backup_today_path
  # note : pas de mkdir(...) ci-dessous, car on teste pour voir si le dossier
  # existe pour savoir si le backup a été fait.
  @backup_today_path ||= File.join(folder_backups,"#{Time.now.strftime('%Y%m%d')}")
end
end #/Film
