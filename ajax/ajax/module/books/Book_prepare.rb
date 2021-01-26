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

# = main =
#
# Méthode principale qui assemble tous les éléments du livre pour produire
# le fichier XHTML qui servira pour Calibre.
#
def prepare

  File.delete(xhtml_file_path) if File.exists?(xhtml_file_path)


  prepare_document_xhtml_final # => final.xhtml

  copie_of_css

end

def prepare_document_xhtml_final

  # On ouvre le flux vers le fichier XHTML final
  @stream = File.open(xhtml_file_path,'a')

  # On ajoute l'entête du fichier XHTML
  @stream << xhtml_header(film.title)

  # On ajoute tous les documents
  add_all_documents

  # On ajoute le pied du fichier XHTML
  @stream << "</body>\n</html>\n"

ensure
  # On ferme le flux vers le fichier XHTML final
  @stream.close
end

# Copie des fichiers css dans le dossier final
def copie_of_css
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

        script_path = File.join(APP_FOLDER,'ajax','ajax','_scripts',"build_#{File.basename(src,File.extname(src))}.rb")
        load script_path

      elsif not(File.exists?(dst))
        # <=  Le fichier n'existe pas
        # =>  On signale une erreur de document manquant
        log("Fichier #{src.inspect} recherché dans #{dst.inspect}")
        film.export_errors << "Le fichier #{File.basename(src).inspect} devrait être ajouté aux livres, mais il est introuvable (dans #{src.inspect})"
        next
      end

    else
      # <=  Ce n'est pas un nom de fichier HTML
      # =>  On le formate en le kramdownant

      affixe  = File.basename(src, File.extname(src))
      dst     = File.join(film.folder_products,"#{affixe}.html")
      File.delete(dst) if File.exists?(dst)
      File.open(dst,'wb'){|f| f.write( kramdown(src) )}
    end
    @stream << File.read(dst)
  end
end

def xhtml_header(title, css_path = 'styles.css')
  File.read(File.join(folder_templates,'header.xhtml')) % {title:title, css:css_path}
end #/ xhtml_header

def xhtml_file_path
  @xhtml_file_path ||= File.join(film.folder_products,xhtml_file_name)
end

def folder_templates
  @folder_templates ||= File.join(__dir__,'templates')
end

end #/Book
