# encoding: UTF-8
# frozen_string_literal: true
=begin
  Les corrections à faire sur tous les textes, pour les balises et autres noms de personnage
=end

# = main =
#
# Méthode principale qui doit être appelée par toute valeur, et pas seulement
# les strings.
def formate(ca)
  case ca
  when String
    formate_as_a_string(ca)
  when Integer
    formate_as_a_integer(ca)
  end
end #/ formate

def formate_as_a_string(str)
  # Remplacer les balises personnage
  # TODO
  # Remplacer les balises scènes
  # TODO
end #/ formate_as_a_string

def formate_as_a_integer

end #/ formate_as_a_integer
