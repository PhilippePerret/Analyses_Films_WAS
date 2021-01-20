# encoding: UTF-8
# frozen_string_literal: true
=begin
  Module pour la construction du synopsis
=end
class Film
  attr_reader :stream

  def build_synopsis
    require_module('Scenes')
    File.delete(synopsis_path) if File.exists?(synopsis_path)
    @stream = File.open(synopsis_path,'a')
    stream << "\n<h2>Synopsis complet</h2>\n\n"
    stream << '<div class="synopsis">'
    sorted_scenes.each do |scene|
      stream << scene.output(as: :synopsis)
    end
    stream << '</div>'
    if not config['documents'].include?('synopsis.html')
      Ajax << {message:"Il faut ajouter 'synopsis.html' à la liste des documents du fichier config.yml pour qu'il soit introduit dans le livre."}
    end
  end


  def synopsis_path
    @synopsis_path ||= File.join(folder_products, 'synopsis.html')
  end #/ synopsis_path

end #/Film
