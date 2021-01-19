# encoding: UTF-8
# frozen_string_literal: true
class Film

# = main =
#
# Méthode principale construisant toutes les statistiques
# ou seulement la statistique voulue.
def build_statistiques(which = nil)
  stats = Statistiques.new(self)
  stats.build
  log("config['documents'] = #{config['documents'].inspect}")
  log("config['documents'].include?('statistiques.html') est #{config['documents'].include?('statistiques.html').inspect}")
  if not(config['documents'].include?('statistiques.html'))
    Ajax << {message:"Ne pas oublier d'ajouter la fichier 'statistiques.html' à la liste des documents du fichier config (jouer la commande 'open config' pour ce faire)."}
  end
end
end #/Film

class Statistiques
attr_reader :film, :stream
def initialize(film)
  @film = film
end

def build
  File.delete(path) if File.exists?(path)
  @stream = File.open(path,'a')
  @stream << "<h1>Statistiques</h1>\n\n"
  stats_scenes
  stats_personnages
  stats_decors
  @stream << "<hr />"
  Ajax << {ok: true}
ensure
  @stream.close
end #/ build

def stats_scenes
  require_module('scenes')
  nombre_scenes = film.sorted_scenes.count
  return if nombre_scenes == 0
  stream << "\n<h2>Statistiques scènes</h2>\n\n"
  stream << explications_stats_of('scenes')
  # Nombre de scènes
  stream << "<p><label class='moyen'>Nombre total de scènes :</label><strong>#{nombre_scenes}</strong></p>\n"
  # Moyenne des durées de scènes
  stream << "<p><label class='moyen'>Moyenne de durée des scènes :</label><strong>#{(film.duration / nombre_scenes).to_horloge}</strong></p>\n"
  # Scènes classées par durées
  plus_longue = nil
  plus_courte = nil
  scene_classees_par_duree = []
  film.sorted_scenes.sort_by(&:duree).reverse.each do |scene|
    if plus_longue.nil? || plus_longue.duree < scene.duree
      plus_longue = scene
    end
    if plus_courte.nil? || plus_courte.duree > scene.duree
      plus_courte = scene
    end
    scene_classees_par_duree << "<div>#{scene.formated_resume}, à #{scene.hstart} — durée : #{scene.duree.to_horloge}</div>"
  end
  options = {intitule:true, times_infos:true, resume:true, content:true}
  # Scène la plus longue
  stream << "<p>Scène la plus longue</p>\n#{plus_longue.output(options)}\n"
  # Scène la plus courte
  stream << "<p>Scène la plus courte</p>\n#{plus_courte.output(options)}\n"

  stream << "\n<h3>Scènes classées de la plus longue (#{plus_longue.fduree}) à la plus courte (#{plus_courte.fduree})</h3>\n\n"
  stream << scene_classees_par_duree.join("\n") + "\n"
  stream << commentaires_stats_of('scenes')
end #/ stats_scenes

def stats_personnages
  stream << "\n<h2>Statistiques personnages</h2>\n\n"
  stream << explications_stats_of('personnages')
  stream << commentaires_stats_of('personnages')
end #/ stats_personnages

def stats_decors
  stream << "\n<h2>Statistiques décors</h2>\n\n"
  stream << explications_stats_of('decors')
  stream << commentaires_stats_of('decors')
end #/ stats_decors


def commentaires_stats_of(type)
  path = File.join(film.folder_documents,"commentaires_stats_#{type}.md")
  kramdown(path) + "\n" # tient compte du fait qu'il peut ne pas exister
end


def path
  @path ||= File.join(film.folder_products, 'statistiques.html')
end

def explications_stats_of(type)
  path = File.expand_path(File.join(__dir__,'..','books','inclusions',"explications_stats_#{type}.md"))
  kramdown(type) + "\n" # tient compte du fait qu'il peut ne pas exister
end

end #/Class Statistiques
