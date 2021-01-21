# encoding: UTF-8
# frozen_string_literal: true
class Integer
  def days
    self * 24 * 3600
  end #/ days
  alias :day :days

  # Retourne l'horloge correspondant au nombre de secondes
  def s2h(with_frames = false)
    negatif = ''
    s = self
    if s < 0
      s = -s
      negatif = '-'
    end
    h = s / 3600
    s = s % 3600
    m = s / 60
    s = s % 60
    str = []
    str << h.to_s if h > 0
    str << "#{'0' if m < 10 && h > 0}#{m}"
    str << "#{'0' if s < 10}#{s}"
    return negatif + str.join(':')
  end #/ s2h
  alias :to_horloge :s2h

end #/Integer
