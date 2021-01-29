# encoding: UTF-8
# frozen_string_literal: true
require 'kramdown'

ASTERISQUE_NOTE = '<exp>*</exp>'

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
def span(text, css = nil)
  "<span class='#{css}'>#{text}</span>"
end
def div(text, css = nil)
  "<div class='#{css}'>#{text}</div>"
end
def parag(text,css = nil)
  "<p class='#{css}'>#{text}</p>"
end
# Retourne le titre +text+ de niveau +level+
def htitle(text, level)
  "<h#{level}>#{text}</h#{level}>"
end #/ title

def no_break(ary)
  div(ary.join(''),'no-break')
end

# Retourne la portion d'explication d'une section
def explication_section(section_name)
  path = template("textes_types/explication_#{section_name}.md")
  div(kramdown(path),'explication-section')
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
  when :time_scenes then Film.current.duration_scenes
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
#                           :time_scene   Un temps à traiter, par rapport à la
#                                         durée réelle des scènes. Cf. la note
#                                         [N001] du manuel développeur.
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
    contient_un_zero = dline.include?(0)
    next if no_zeros && contient_un_zero
    next if dline[cols_count] && dline[cols_count][:no_zero] && contient_un_zero
    t << '<tr>'
    dline[0...cols_count].each_with_index do |v, idx|
      type_value = (dline[cols_count]||{})[idx] || column_types[idx]
      v = case type_value
      when :time, :time_scenes then span(v.to_i.to_horloge,'value') + pct(type_value, v)
      when :scenes then span(v.to_s,'value') + pct(:scenes, v)
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
REG_REFERENCE_FILM = /\[ref:film:(.*?)(?:\|(.*?))?\]/
REG_BALISE_TEMPS = /\[time:(.*?)(?:\|(.*?))?\]/
def formate_as_a_string(str)
  # Remplacer les balises [include:relative/path.ext]
  str = traite_inclusion_in(str)
  # Remplacer les balises personnage
  str = traite_balises_personnages(str)
  # Remplacer les balises films
  str = str.gsub(REG_REFERENCE_FILM){
    ref_id        = $1.freeze
    ref_text_alt  = $2.freeze
    reference_code_for('film', ref_id, ref_text_alt)
  }
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
  # Remplacer les balises temps
  str = str.gsub(REG_BALISE_TEMPS){balise_time_to_horloge($1.freeze, $2.freeze)}

  return str
end #/ formate_as_a_string

REG_INCLUDE = /\[include:(.*?)\]/
def traite_inclusion_in(str)
  str.gsub(REG_INCLUDE){
    relpath = $1.freeze
    final_path = film.find_document(relpath)
    if final_path
      traite_inclusion_in(File.read(final_path).force_encoding('utf-8'))
    else
      "[Fichier introuvable. Cherché dans './documents', '_TEMPLATES_' et './products']"
    end
  }
end

# Retourne le texte de référence quand un texte alternatif n'est
# pas spécifié dans une balise de référence
def reference_code_for(ref_type, ref_id, ref_text_alt)
  ref_text = ref_text_alt || case ref_type
  when 'film'     then
    defined?(Filmodico) || require_module('Filmodico')
    Filmodico.get(ref_id).titre
  when 'scene'    then film.scene_per_event(ref_id).formated_resume
  when 'note'     then film.event(ref_id).formated_resume
  when 'event'    then film.event(ref_id).formated_resume
  when 'document' then "document « #{File.basename(ref_id,File.extname(ref_id)).gsub(/_/,' ').titleize} »"
  else
    film.export_errors << "La balise référence de type '#{ref_type}' est inconnue…"
    return "[Référence manquante - #{ref_type}:#{ref_id}]"
  end

  return "<a href='##{ref_type}_#{ref_id}' class='#{ref_type}'>#{ref_text}</a>"
end

# Retourne le path d'un dossier template (ou texte type)
def template(relative_path)
  File.join(APP_FOLDER,'_TEMPLATES_',relative_path)
end

def formate_as_a_integer(n)

  return n
end #/ formate_as_a_integer

def traite_balises_personnages(str)
  Film.current.personnages.each do |keyp, personnage|
    str = str.gsub(/\b#{keyp}\b/){
      key_perso = $1.freeze
      personnage.recurrence ||= 0
      personnage.recurrence += 1
      if personnage.recurrence == 1
        personnage.full_name
      elsif personnage.recurrence % 3 == personnage.recurrence / 3
        personnage.short_name
      elsif personnage.recurrence % 7 == personnage.recurrence / 7
        personnage.full_name
      else
        personnage.nick_name
      end
    }
  end
  return str
end #/ traite_balises_personnages


BALISE_TIME = '<span class="horloge" data-time="%s">%s</span>'
def balise_time_to_horloge(horloge, text_alt)
  text = text_alt || if horloge.match?('-')
    MTime.as_time_interval(horloge)
  else
    MTime.real(horloge, true)
  end
  BALISE_TIME % [horloge, text]
end #/ balise_time_to_horloge
