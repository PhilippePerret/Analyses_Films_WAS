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
  attr_reader :rtf

  # = main =
  #
  # Méthode principale de construction du séquencier
  def build_sequencier

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

  def sequencier_path
    @sequencier_path ||= File.join(folder_products, 'sequencier.rtf')
  end #/ sequencier_path
end #/Film
