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

REG_REFERENCE = /\[ref:(scene|note|event):([0-9]+)(?:\|(.*?))?\]/
def formate_as_a_string(str)
  # Remplacer les balises personnage
  # TODO
  # Remplacer les balises films
  # TODO
  # Remplacer les balises références (à scène, note, etc.)
  str = str.gsub(REG_REFERENCE){
    ref_type      = $1.freeze
    ref_id        = $2.to_i.freeze
    ref_text_alt  = $3
    reference_code_for(ref_type, ref_id, ref_text_alt)
  }
  return str
end #/ formate_as_a_string

# Retourne le texte de référence quand un texte alternatif n'est
# pas spécifié dans une balise de référence
def reference_code_for(ref_type, ref_id, ref_text_alt)
  ref_text = ref_text_alt || case ref_type
  when 'scene'  then film.scene_per_event(ref_id).formated_resume
  when 'note'   then film.event(ref_id).formated_resume
  when 'event'  then film.event(ref_id).formated_resume
  else
    film.export_errors << "La balise référence de type '#{ref_type}' est inconnue…"
    return "[Référence manquante - #{ref_type}:#{ref_id}]"
  end

  return "<a href='##{ref_type}-#{ref_id}'>#{ref_text}</a>"
end

def formate_as_a_integer(n)

  return n
end #/ formate_as_a_integer
