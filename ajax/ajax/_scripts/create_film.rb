# encoding: UTF-8
# frozen_string_literal: true
=begin
  Module de création d'un nouveau film d'analyse d'après les données +data+
  envoyées par ajax
=end
require 'yaml'
require 'fileutils'

ERRORS = {
  folder_required: "Il faut définir le dossier du film !",
  bad_folder_name: "Le nom du dossier du film ne devrait contenir que des lettres, des chiffres, et le trait plat",
  folder_exists: "Ce dossier existe déjà !",
  title_required: "Le titre est indispensable, pour créer un nouveau film !",
  video_required: "Le chemin d'accès à la vidéo est requis !",
  video_should_exist: "La vidéo est introuvable…",
  video_width_required: "La taille du retour de la vidéo est requise et doit être supérieure à 0 !",
  video2_width_required: "La taille du retour de la seconde vidéo est requise et doit être supérieure à 0 !"
}
def stop(key, values = nil)
  msg = ERRORS[key]
  msg = msg % values unless values.nil?
  raise msg
end

# = Les données du film =
data = Ajax.param(:data)
log("Data pour le nouveau film : #{data}")

# Les données de configuration complète
data_config = {
  'title' => nil,         # titre du film analysé
  'film_infos' => {
    'director' => nil,      # Réalisateur du film
  }
  'book_infos' => {
    'author' => "Philippe Perret",  # Auteur de l'analyse
    'editor' => { # Éditeur
      'name' => "Icare Éditions",
      'logo' => nil                 # Chemin vers le logo
    },
    'cover' => {
      'path' => nil       # Chemin d'accès à l'image
      'width' => nil      # Taille de l'image sur la couverture
    }

    'isbn' => nil,          # Numéro ISBN du livre
  }
  'documents' => [],
  'personnages' => {},
  'snippets' => {}

}

# === VÉRIFICATION DES DONNÉES ===

# = Le dossier =
data['folder'] = data['folder'].nil_if_empty
data['folder'] || stop(:folder_required)
data['folder'].gsub(/[a-zA-Z0-9_]/,'').empty? || stop(:bad_folder_name)
File.exists?(File.join(Film.folder,data['folder'])) && stop(:folder_exists)
data_config.merge!('film_folder' => data['folder'])
# = Le titre =
data['title'] = data['title'].nil_if_empty
data['title'] || stop(:title_required)
data_config.merge!('title' => data['title'])
# = vidéo =
data['video_path'] = data['video_path'].nil_if_empty
data['video_path'] || stop(:video_required)
File.exists?(data['video_path']) || stop(:video_should_exist, data['video_path'])
data_config.merge!('video' => {'original_path' => nil, 'width' => nil, 'name' => nil})
data_config['video']['original_path'] = data['video_path']
data_config['video']['name'] = File.basename(data['video_path'])
data['video_width'] = (data['video_width'].nil_if_empty || 600).to_i
data['video_width'] > 0 || stop(:video_width_required)
data_config['video']['width'] = data['video_width']
# = 2nd vidéo =
if data['video2']
  data['video2_width'] = (data['video2_width'].nil_if_empty || 200).to_i
  data['video2_width'] > 0 || stop(:video2_width_required)
  data_config.merge!('video2' => {'width' => data['video2_width']})
end

# === CRÉATION DU DOSSIER ET FICHIER DE CONFIGURATION ===
folder_path = mkdir(File.join(Film.folder, data_config['film_folder']))
config_path = File.join(folder_path, 'config.yml')
videof_path = File.join(folder_path, data_config['video']['name'])
File.open(config_path,'wb'){|f| f.write(data_config.to_yaml)}
FileUtils.copy(data['video_path'], videof_path)

# === SI ON DOIT LE METTRE EN COURANT ===
if data['as_current']
  Film.set_current(data['folder'])
end
