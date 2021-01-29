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

    stream << '<section id="traitement" class="book-section">'
    stream << htitle('Traitement complet', 2)
    stream << explication_section('traitement')

    sorted_scenes.each do |scene|
      stream << scene.output(as: :traitement)
    end

    # On ajoute les commentaires s'il y en a
    if File.exists?(commentaires_traitement_path)
      stream << '<div class="commmentaires_traitement">'
      stream << htitle('Commentaires sur le traitement',3)
      stream << kramdown(commentaires_traitement_path)
      stream << '</div>'
    end

    stream << '</section>'

    if not document?('traitement.html')
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
          scene_courante = Film.current.scene_per_event(aev.id)
          scene_courante.events = []
        elsif not scene_courante.nil?
          if aev.in_traitement?
            scene_courante.events << aev
          end
        end
    end
  end #/ dispatch_events_in_scenes

  def traitement_path
    @traitement_path ||= File.join(folder_products, 'traitement.html')
  end #/ traitement_path

  def explication_traitement_path
    @explication_traitement_path ||= template('textes_types/explication_traitement.md')
  end

  def commentaires_traitement_path
    @commentaires_traitement_path ||= File.join(folder_documents,'commentaires_traitement.md')
  end

end #/Film
