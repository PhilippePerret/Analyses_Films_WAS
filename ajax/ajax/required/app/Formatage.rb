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

# Retourne le code d'un span avec la classe +css+ et la valeur +text+
def span(text, css)
  "<span class='#{css}'>#{text}</span>"
end
# Retourne le pourcentage que représente la valeur +value+ par rapport
# à la chose +what+
# +what+ peut avoir les valeurs :
#   :time     La durée du film
#   :scenes   Le nombre de scènes du film
#
# +options+
#   :par    Si false, on ne met pas la valeur entre parenthèses
#   :dec    Le nombre de décimales (1 par défaut)
#
# Return un texte comme "<span class='pct'>(23.4 %)</span>"
def pct(what, value, options = {})
  options[:dec] ||= 1
  value = value.to_i
  ref_value = case what
  when :scene, :scenes then Film.current.scenes_count
  when :time, :duree then Film.current.duration
  else raise "Impossible de donner le pourcentage de #{what.inspect}"
  end
  vpct = (100.0 / (ref_value.to_f / value.to_f)).round(options[:dec]).to_s
  vpct = vpct[0..-3] if vpct.end_with?('.0')
  vpct = "#{vpct} %"
  vpct = "(#{vpct})" unless options[:par] === false
  span(vpct, 'pct')
end #/ pct

# ---------------------------------------------------------------------
#
#   MISES EN FORME SPÉCIALES
#
# ---------------------------------------------------------------------

# Pour construire une table HTML à partir des données +data+
# +data+  {Hash} Table qui doit définir
#   :columns    Liste Array de la définition de chaque colonne
#               Chaque élément est un hash définissant :
#                 :width    Taille (largeur) de la colonne
#                           Si c'est un nombre => pourcentage, sinon, on laisse
#                           la valeur telle quelle.
#                 :title    Titre de la colonne
#                 :type     [Optionnelle] Le type de la valeur, entre :
#                           :time     Un temps à traiter comme une horloge
#                           :scenes   Un nombre de scènes.
#                           La valeur en pourcentage est ajoutée.
#
#   :values     Liste des listes de valeurs
#               Chaque élément est une liste qui doit contenir autant de valeurs
#               que de colonnes.
#               OPTIONNELLEMENT, le DERNIER ÉLÉMENT peut définir le type de la
#               valeur, pour savoir comment la traiter. C'est une table avec
#               en clé l'index 0-start de la colonne et en valeur le type.
#               Par exemple : {2 => :scenes}
#               Voir les types de colonnes, c'est la même chose. Cette valeur a
#               priorité sur la définition du type de la colonne.
#
#   :options    Options éventuelles
#       :no_zeros   Si true, on n'écrit aucune valeur qui serait égale à zéro,
#                   c'est-à-dire qu'on passe la ligne.
def table(data)
  # Options
  options = data[:options] || {}
  no_zeros = options[:no_zeros] === true
  cols_count = data[:columns].count
  column_types = []
  # On construit la table
  t = ["<table>"]
  t << '<thead>'
  t << '<tr>'
  data[:columns].each do |dcol|
    w = dcol[:width]
    t << "<th width='#{w}#{w.is_a?(String) ? '' : '%'}'>#{dcol[:title]}</th>"
    column_types << dcol[:type]
  end
  t << '</tr>'
  t << '</thead>'
  t << '<tbody>'
  data[:values].each do |dline|
    next if no_zeros && dline.include?(0)
    t << '<tr>'
    dline[0...cols_count].each_with_index do |v, idx|
      type_value = (dline[cols_count]||{})[idx] || column_types[idx]
      v = case type_value
      when :time    then span(v.to_i.to_horloge,'value') + pct(:time, v)
      when :scenes  then span(v.to_s,'value') + pct(:scenes, v)
      else span(v,'value')
      end
      t << "<td>#{v}</td>"
    end.join('')
    t << '</tr>'
  end
  t << '</tbody>'
  t << '</table>'
end #/ table

# ---------------------------------------------------------------------
#
#   FORMATAGE DU TEXTE
#
# ---------------------------------------------------------------------

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
