# encoding: UTF-8
# frozen_string_literal: true
gem 'rrtf'
require 'rrtf'
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
    stream << "\n<h2>Séquencier complet et annoté du film</h2>\n\n"
    sorted_scenes.each do |scene|
      stream << scene.as_sequence
    end
  ensure
    stream.close
  end

  # Ancienne méthode en RTF
  def build_sequencier_in_RTF

    @rtf = DocRTFAnalyse.new(File.join(Film.current.folder_products,'sequencier.rtf'))

    sorted_scenes.each do |scene|
      # log("#{scene.intitule}\n#{scene.times_infos}\n#{scene.content}")
      rtf.par(:intitule)  << scene.intitule
      rtf.par(:time_infos)<< scene.times_infos
      rtf.par(:scene_resume)  << scene.resume
      rtf.par(:regular)       << scene.real_content
    end

    rtf.save
  end #/ build_sequencier

  def sequencier_rtf_path
    @sequencier_rtf_path ||= File.join(folder_products, 'sequencier.rtf')
  end
  def sequencier_path
    @sequencier_path ||= File.join(folder_products, 'sequencier.html')
  end
end #/Film


class Scene

# Code HTML à insérer dans le séquencier
def as_sequence
  <<-HTML
<div class="scene" data-id="#{id}">
  <p class="scene_intitule">#{intitule}</p>
  <p class="scene_times_infos">#{times_infos}</p>
  <p class="scene_resume">#{resume}</p>
  <p class="scene_content">#{full_content}</p>
</div>

  HTML
end #/ as_sequence

# Le contenu complet, avec la description de la scène (real_content) mais
# tous les évènements qui lui appartiennnent
def full_content
  real_content
end #/ full_content

end #/Scene
