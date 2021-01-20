# encoding: UTF-8
# frozen_string_literal: true
class Film
  attr_reader :stream

  # = main =
  #
  # Méthode principale qui charge les évènements dans les scènes
  def build_traitement
    require_module('Scenes')
    dispatch_events_in_scenes
    File.delete(traitement_path) if File.exists?(traitement_path)
    @stream = File.open(traitement_path,'a')
    stream << "\n<h2>Traitement complet</h2>\n\n"
    sorted_scenes.each do |scene|
      next if not scene.in_traitement?
      stream << scene.output(as: :traitement)
    end
    if not config['documents'].include?('traitement.html')
      Ajax << {message:"Il faut ajouter 'traitement.html' à la liste des documents du fichier config.yml pour qu'il soit introduit dans le livre."}
    end
  ensure
    stream && stream.close
  end

  # Méthode qui prend tous les évènements et les place dans leur scène
  # correspondante.
  def dispatch_events_in_scenes
    scene_courante = nil
    get_events
      .collect { |sc| AEvent.new(sc) }
      .sort_by(&:time)
      .each do |aev|
        if aev.scene?
          scene_courante = Scene.new(aev.data)
          scene_courante.events = []
        elsif not scene_courante.nil?
          scene_courante.events << aev
        end
    end
  end #/ dispatch_events_in_scenes

  def traitement_path
    @traitement_path ||= File.join(folder_products, 'traitement.html')
  end #/ traitement_path
end #/Film
