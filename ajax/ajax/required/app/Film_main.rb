# encoding: UTF-8
# frozen_string_literal: true
require 'yaml'

class Film
class << self
  def current
    @current ||= begin
      folder = nil
      if File.exists?('../_FILMS_/CURRENT')
        folder = File.expand_path("../_FILMS_/#{File.read('../_FILMS_/CURRENT').strip}")
        folder = nil if not(File.exists?(folder))
      end
      folder ||= get_first_directory # peut être nil
      folder && new(folder)
    end
  end
  def get_first_directory
    Dir["../_FILMS_/*"].each do |p|
      return p if File.directory?(p)
    end
    return nil
  end #/ get_first_directory
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
# TODO Plus tard, on le mettra de côté
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
