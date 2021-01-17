# encoding: UTF-8
# frozen_string_literal: true
class Film

  # = main =
  #
  # Méthode principale de construction du séquencier
  def build_sequencier
    log("Scène classées :")
    scenes.each do |scene|
      log("- Scène ##{scene.numero} #{scene.content}")
    end
  end #/ build_sequencier

  # Retourne la liste des scènes
  # C'est un Array d'instance Scene dans l'ordre du film
  def scenes
    @scenes ||= begin
      numCur = 0
      get_events.collect do |devent|
        next if devent['type'] != 'sc'
        Scene.new(devent)
      end.sort_by { |sc| sc.time }.collect { |sc| sc.numero = numCur += 1}
    end
  end #/ scenes

end #/Film
