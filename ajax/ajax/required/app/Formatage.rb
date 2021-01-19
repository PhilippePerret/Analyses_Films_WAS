# encoding: UTF-8
# frozen_string_literal: true
require 'kramdown'

=begin
  Les corrections à faire sur tous les textes, pour les balises et autres noms de personnage
=end

# Pour produire le code HTML d'un document Markdown
def kramdown(src)
  return "" if not(File.exists?(src))
  code = File.read(src).force_encoding('utf-8')
  code = formate(code)
  return Kramdown::Document.new(code).to_html
end #/ kramdown

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
  # Remplacer les balises films
  return str
end #/ formate_as_a_string

def formate_as_a_integer(n)

  return n
end #/ formate_as_a_integer
