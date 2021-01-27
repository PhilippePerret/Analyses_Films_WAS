# encoding: UTF-8
# frozen_string_literal: true
=begin
Class Book
----------
Pour gérer le livre
=end
require 'fileutils'

class Book
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :film
def initialize(film)
  @film = film
end #/ initialize

def suivi(msg); film.suivi(msg) end

# = main =
#
# Méthode principale qui assemble tous les éléments du livre pour produire
# le fichier XHTML qui servira pour Calibre.
#
def prepare
  suivi('== Préparation du livre ==')

  prepare_images

  File.delete(xhtml_file_path) if File.exists?(xhtml_file_path)
  prepare_document_xhtml_final # => final.xhtml

  copie_of_css

  suivi('== /fin de la préparation du livre ==')
end

# Prépare toutes les images utiles
def prepare_images
  prepare_cover
  prepare_image_pfa if film.document?('pfa.html')
end

# Prépare la couverture
# La préparation de la couverture, pour le moment, consiste simplement à
# prendre le fichier cover.jpg qui doit impérativement se trouver dans le
# dossier ./img pour le copier dans le dossier ./products/img
def prepare_cover
  src = File.join(film.folder,'img','cover.jpg')
  dst = File.join(film.folder_products,'img','cover.jpg')
  if not File.exists?(src)
    ent = "Impossible de trouver le fichier de couverture (<code>img/cover.jpg</code>)…"
    if File.exists?(File.join(film.folder,'img','cover.png'))
      raise "#{ent} Il faut exporter le fichier 'cover.png' en JPEG avec Aperçu."
    elsif File.exists?(File.join(film.folder,'img','cover.svg'))
      raise "#{ent} Il faut exporter le fichier .img/cover.svg en PNG avec Inkscape puis le convertir en JPEG avec Aperçu."
    else
      raise "#{ent} Il faut créer le fichier de couverture ! Consulter le manuel."
    end
  else
    delete_if_exists(dst)
    FileUtils.copy(src, dst)
  end
end

def delete_if_exists(pth)
   File.delete(pth) if File.exists?(pth)
end

# Prépare l'image du PFA en la construisant si elle n'existe pas
def prepare_image_pfa
  src = File.join(film.folder_images,'pfa.jpg')
  dst = File.join(film.folder_img_in_products,'pfa.jpg')
  if not File.exists?(src)
    require_module('pfa_image')
    film.build_pfa
  end
  delete_if_exists(dst)
  FileUtils.copy(src, dst)
end

def prepare_document_xhtml_final

  suivi('--> Construction du fichier xhtml final')
  # On ouvre le flux vers le fichier XHTML final
  @stream = File.open(xhtml_file_path,'a')

  # On ajoute l'entête du fichier XHTML
  suivi('    + Ajout de l’entête XHTML du fichier')
  @stream << xhtml_header(film.title)

  # On ajoute tous les documents
  add_all_documents

  # On ajoute le pied du fichier XHTML
  @stream << "</body>\n</html>\n"

  suivi('--/ Fin de la Construction du fichier xhtml final')

ensure
  # On ferme le flux vers le fichier XHTML final
  @stream.close
end

# Copie des fichiers css dans le dossier final
def copie_of_css
  suivi('--> Copie des fichiers CSS')
  ['styles','analyse','styles_mobi7_kf8'].each do |affixe|
    src = File.join(folder_templates,"#{affixe}.css")
    dst = File.join(film.folder_products, "#{affixe}.css")
    FileUtils.copy_entry(src, dst, false, false, true)
  end
end

# Ajout de tous les documents dans le fichier XHTML
# On doit prendre tous les documents .md du dossier 'documents', en faire
# des fichiers HTML simples (avec kramdown) puis les ajouter au flux
def add_all_documents
  # Soit la liste des documents est déterminée par la configuration,
  # soit on prend les documents dans l'ordre du dossier (mauvais car c'est
  # très aléatoire)

  # +files+ est une liste de chemins d'accès absolus
  files = film.documents || Dir["#{film.folder_documents}/**/*.md"]
  files.each do |src|
    if File.extname(src).start_with?('.htm')
      # <=  C'est un fichier HTML qui est requis
      # =>  Soit c'est un document automatique et il faut le construire
      #     pour l'actualiser.
      #     Soit c'est un document personnalisé et on s'attend à le trouver
      #     dans le dossier

      # Dans tous les cas, le nom du fichier de destination sera le même que
      # le nom du fichier source
      dst = src

      if AUTO_DOCUMENTS.key?(File.basename(src))
        # <=  C'est un fichier automatique
        # =>  On l'actualise dans tous les cas

        suivi("Actualisation du fichier #{src}")
        script_path = File.join(APP_FOLDER,'ajax','ajax','_scripts',"build_#{File.basename(src,File.extname(src))}.rb")
        load script_path

      elsif not(File.exists?(dst))
        # <=  Le fichier n'existe pas
        # =>  On signale une erreur de document manquant
        log("Fichier #{src.inspect} recherché dans #{dst.inspect}")
        suivi("ERREUR NON FATALE : fichier introuvable #{src}")
        film.export_errors << "Le fichier #{File.basename(src).inspect} devrait être ajouté aux livres, mais il est introuvable (dans #{src.inspect})"
        next
      end

    else

      # <=  Ce n'est pas un nom de fichier HTML
      # =>  On le formate en le kramdownant

      affixe  = File.basename(src, File.extname(src))
      dst     = File.join(film.folder_products,"#{affixe}.html")
      File.delete(dst) if File.exists?(dst)
      suivi("Construction du fichier #{dst} depuis markdown")
      File.open(dst,'wb'){|f| f.write( kramdown(src) )}
    end

    suivi("    + Ajout de : #{dst}")
    @stream << File.read(dst)

  end
end

def xhtml_header(title, css_path = 'styles.css')

  all_styles = File.read(template('styles.css')) + File.read(template('analyse.css'))
  all_styles = all_styles.gsub(/\/\*(.*)?\*\//m,'').gsub(/\n\n+/,"\n")
  File.read(File.join(folder_templates,'header.xhtml')) % {title:title, styles:all_styles}

end #/ xhtml_header

def xhtml_file_path
  @xhtml_file_path ||= File.join(film.folder_products,xhtml_file_name)
end

def template(name)
  File.join(folder_templates, name)
end
def folder_templates
  @folder_templates ||= File.join(__dir__,'templates')
end

end #/Book
