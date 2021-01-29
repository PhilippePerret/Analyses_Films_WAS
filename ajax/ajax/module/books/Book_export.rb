# encoding: UTF-8
# frozen_string_literal: true
=begin
Class Book
----------
Pour gérer le livre
=end
class Book
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
# = main =
#
# Méthode principale qui produit les livres avec Calibre.
def export(type)
  suivi('== Export du livre (fabrication) ==')
  export_as('HTML') if type == 'html' || type.nil?
  export_as('MOBI') if type == 'mobi' || type.nil?
  export_as('ePUB') if type == 'epub' || type.nil?
  export_as('PDF')  if type == 'pdf'  || type.nil?
  suivi('== /Fin de l’Export du livre ==')
end

# Retourne la commande Calibre pour le livre
def calibre_command(src, dst, format)
  options = []

  # La couverture
  options << '--cover=img/cover.jpg'
  # Pour introduire toutes les fonts
  options << '--embed-all-fonts'
  # Pour la détection des chapitres
  options << '--chapter="//h:h2"'
  options << '--chapter-mark="pagebreak"'
  # Pour ajouter un saut de page avant les div.page
  options << '--page-breaks-before="//h:div[@class=\'page\']"'

  options << "--verbose" if VERBOSE

  case format
  when 'mobi'
    # = Options pour AZW3 (mobi) =
    options << '--no-inline-toc'
    options << '--pretty-print'
  when 'pdf'
    options << '--paper-size=a5'
  end

  "cd \"#{film.folder_products}\";#{EBOOK_CONVERT_CMD} #{src} #{dst} #{options.join(' ')}"
end #/ calibre_command


def export_as(type)
  suivi("--> Export au format #{type}")
  if type.downcase == 'html'
    build_html_book
  else
    build_book(type, send("#{type.downcase}_file_name".to_sym))
  end
  suivi("--/ Fin export au format #{type}")
end #/ export_as(format)

# Construction du livre au format voulu
def build_book(type, dst, src = nil)
  src ||= xhtml_file_name
  File.delete(dst) if File.exists?(dst)
  calibrecommand = calibre_command(src, dst, type)
  log("Commande Calibre jouée :\n#{calibrecommand}")
  result = `#{calibrecommand} > ./x_output_calibre`
  move_book_to_folder_livres(dst, type, calibrecommand)
  Ajax << {retour_commande_calibre: result}
end

# On ne construit pas vraiment le book HTML, on fait simplement
# une copie en mettant les styles en dur
def build_html_book
  log("-> Construction du livre HTML")
  code = File.read(xhtml_file_path).force_encoding('utf-8')

  code = code.sub('<link type="text/css" rel="stylesheet" href="styles.css" />', "<style type='text/css'>\n/* styles.css */\n#{code_css('styles')}\n")
  code = code.sub('<link type="text/css" rel="stylesheet" href="analyses.css" />', "\n/* analyse.css */\n#{code_css('analyse')}\n</style>")

  File.open(html_file_path,'wb'){|f|f.write(code)}
  log("<- Llivre HTML construit avec succès dans #{html_file_path.inspect}")
end

def move_book_to_folder_livres(src, type, calibrecommand)
  dst = File.join(film.folder_livres, src)
  src = File.join(film.folder_products, src)
  log("src:#{src}\ndst:#{dst}")
  if File.exists?(src)
    File.delete(dst) if File.exists?(dst)
    FileUtils.move(src, dst)
  else
    log("\n\nERREUR AVEC LA COMMANDE :\n\n#{calibrecommand}\n\n")
    raise "Une erreur a dû se produire : le livre de type '#{type}' n'a pas été construit… Essayer de jouer la commande placée dans le log pour trouver l'erreur."
  end
end

def code_css(file_name)
  File.read(File.join(folder_templates,"#{file_name}.css"))
end #/ code_css

# Le fichier source
def xhtml_file_name  ; @xhtml_file_name   ||= "livre.xhtml"  end
# Les fichiers destination
def html_file_name  ; @html_file_name   ||= "livre.html"  end
def html_file_path  ; @html_file_path   ||= File.join(film.folder_livres,html_file_name) end
def mobi_file_name  ; @mobi_file_name   ||= "livre.mobi"  end
def epub_file_name  ; @epub_file_name   ||= "livre.epub"  end
def pdf_file_name   ; @pdf_file_name    ||= "livre.pdf"   end

end #/Book
