# encoding: UTF-8
# frozen_string_literal: true
# gem 'rrtf'
# require 'rrtf'
require_module('scenes')
require_module('decors')
=begin
  Documentation sur le gem rrtf :

      https://github.com/whileman133/rrtf

=end

class Film
  attr_reader :stream
  attr_reader :rtf

  # = main =
  #
  # Méthode principale de construction du séquencier
  def build_sequencier
    File.delete(sequencier_path) if File.exists?(sequencier_path)
    @stream = File.open(sequencier_path,'a')
    stream << "\n<h2>Séquencier complet du film</h2>\n\n"
    stream << '<div class="sequencier">'
    sorted_scenes.each do |scene|
      stream << scene.output(as: :sequencier)
    end
    stream << '</div>'
    # On ajoute les commentaires s'il y en a
    if File.exists?(commentaires_sequencier_path)
      stream << '<div class="commmentaires_sequencier">'
      stream << htitle('Commentaires sur le séquencier',3)
      stream << kramdown(commentaires_sequencier_path)
      stream << '</div>'
    end

    if not document?('sequencier.html')
      Ajax << {message:"Il faut ajouter 'traitement.html' à la liste des documents du fichier config.yml pour qu'il soit introduit dans le livre."}
    end

  ensure
    stream.close
  end

  def sequencier_path
    @sequencier_path ||= File.join(folder_products, 'sequencier.html')
  end

  def commentaires_sequencier_path
    @commentaires_sequencier_path ||= File.join(folder_documents,'commentaires_sequencier.md')
  end
end #/Film
