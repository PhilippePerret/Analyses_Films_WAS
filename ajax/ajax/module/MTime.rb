# encoding: UTF-8
# frozen_string_literal: true
=begin
  Ce module rassemble toutes les méthodes utiles pour la gestion des temps.
  Et notamment les méthodes publiques :

  MTime.real(x)

    Retourne le nombre réel de secondes du temps 'x' (horloge ou nombre de
    secondes) en fonction du point zéro du film.

  MTime.real(x, true)

    Retourne l'HORLOGE correspondant au tempx 'x' (horloge ou entier nombre
    de seconde) en fonction du point zéro du film

=end

class MTime
class << self

  # Retourne le nombre de secondes exactes correspondant à +x+ dans le film
  # courant, en fonction du point-zéro défini.
  # Si +as_horloge+ est vrai, la méthode retourne une horloge.
  def real(x, as_horloge = false)
    x = x.h2s if x.is_a?(String)
    x = (x - film.zero).to_i
    x = x.to_horloge if as_horloge
    return x
  end #/ real

  def as_time_interval(x)
    start_time, end_time = x.split('-')
    duree = (end_time.h2s - start_time.h2s).to_i
    "de #{real(start_time).to_horloge} à #{real(end_time).to_horloge} (#{duree.as_duree})"
  end #/ as_time_interval

  private

    def film
      @film ||= Film.current
    end

end #<< self
end
