# encoding: UTF-8
# frozen_string_literal: true
gem 'rrtf'
require 'rrtf'
=begin
  Documentation RRTF : https://github.com/whileman133/rrtf
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

  # Retourne la liste des scènes classées par temps
  # Note : les propriétés :numero et :time_fin ont été renseignées
  def sorted_scenes
    @sorted_scenes ||= begin
      numCur = 0
      # scenes.sort_by{|sc| sc.time}.collect{|sc|sc.numero = (numCur += 1)}
      scenes.sort_by!(&:time)
      scenes.each do |sc|
        sc.numero = (numCur += 1)
      end
      # On ajoute le temps de fin (début de la suivante)
      last_start = Film.current.duration.dup
      scenes.reverse.each do |sc|
        sc.time_fin = last_start.dup
        last_start = sc.time
      end
      scenes
    end
  end #/ sorted_scenes
  # Retourne la liste des scènes
  # C'est un Array d'instance Scene dans l'ordre du film
  def scenes
    @scenes ||= begin
      get_events(type: 'sc').collect do |devent|
        Scene.new(devent)
      end
    end
  end #/ scenes


  def decors
    @decors ||= begin
      h = {}
      (config['decors']||{}).each do |did, ddata|
        decor_name = ddata['hname']
        h.merge!(did => decor_name)
        (ddata['items']||{}).each do |sdid, sdecor_name|
          h.merge!("#{did}:#{sdid}" => "#{decor_name} : #{sdecor_name}")
        end
      end
      h
    end
  end #/ decors
end #/Film
