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
  @stream << htitle("Statistiques", 1)
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
  stream << htitle("Statistiques scènes", 2)
  stream << explications_stats_of('scenes')
  stream << Scenes.build_stats
  stream << commentaires_stats_of('scenes')
end #/ stats_scenes

def stats_personnages
  return if not(film.config.key?('personnages')) || film.config['personnages'].empty?
  stream << htitle("Statistiques personnages", 2)
  stream << explications_stats_of('personnages')
  stream << Personnage.build_stats
  stream << commentaires_stats_of('personnages')
end #/ stats_personnages

def stats_decors
  return if not(film.config.key?('decors')) || film.config['decors'].empty?
  stream << htitle("Statistiques décors", 2)
  stream << explications_stats_of('decors')
  stream << Decor.build_stats
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
  path = template("textes_types/explications_stats_#{type}.md")
  kramdown(path) + "\n" # tient compte du fait qu'il peut ne pas exister
end

end #/Class Statistiques
