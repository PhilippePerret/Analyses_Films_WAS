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
REG_REFERENCE_DOC = /\[ref:doc(?:ument)?:(.*?)(?:\|(.*?))?\]/
def formate_as_a_string(str)
  # Remplacer les balises [include:relative/path.ext]
  str = traite_inclusion_in(str)
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
  str = str.gsub(REG_REFERENCE_DOC){
    ref_id        = $1.freeze
    ref_text_alt  = $2.freeze
    reference_code_for('document', ref_id, ref_text_alt)
  }
  return str
end #/ formate_as_a_string

REG_INCLUDE = /\[include:(.*?)\]/
def traite_inclusion_in(str)
  str.gsub(REG_INCLUDE){
    relpath = $1.freeze
    real_paths = [template(relpath)]
    real_paths << File.join(Film.current.folder_documents,relpath)
    real_paths << File.join(Film.current.folder_products,relpath)
    final_path = nil
    real_paths.each do |rpath|
      next unless File.exists?(rpath)
      final_path = rpath
      break
    end
    unless final_path.nil?
      traite_inclusion_in(File.read(final_path).force_encoding('utf-8'))
    else
      "[Fichier introuvable. Cherché dans : #{real_paths.join(', ')}]"
    end
  }
end

# Retourne le texte de référence quand un texte alternatif n'est
# pas spécifié dans une balise de référence
def reference_code_for(ref_type, ref_id, ref_text_alt)
  ref_text = ref_text_alt || case ref_type
  when 'scene'    then film.scene_per_event(ref_id).formated_resume
  when 'note'     then film.event(ref_id).formated_resume
  when 'event'    then film.event(ref_id).formated_resume
  when 'document' then "document « #{File.basename(ref_id,File.extname(ref_id)).gsub(/_/,' ').titleize} »"
  else
    film.export_errors << "La balise référence de type '#{ref_type}' est inconnue…"
    return "[Référence manquante - #{ref_type}:#{ref_id}]"
  end

  return "<a href='##{ref_type}_#{ref_id}'>#{ref_text}</a>"
end

# Retourne le path d'un dossier template (ou texte type)
def template(relative_path)
  File.join(APP_FOLDER,'_TEMPLATES_',relative_path)
end #/ template

def formate_as_a_integer(n)

  return n
end #/ formate_as_a_integer
