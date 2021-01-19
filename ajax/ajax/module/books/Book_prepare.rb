# encoding: UTF-8
# frozen_string_literal: true
=begin
Class Book
----------
Pour gérer le livre
=end
require 'fileutils'

class Book
class << self

end # /<< self
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
def prepare

  File.delete(xhtml_file_path) if File.exists?(xhtml_file_path)


  prepare_document_xhtml_final # => final.xhtml

  copie_of_css

end

def prepare_document_xhtml_final

ensure
  # On ouvre le flux vers le fichier XHTML final
  @stream = File.open(xhtml_file_path,'a')

  # On ajoute l'entête du fichier XHTML
  @stream << xhtml_header(film.title)

  # On ajoute tous les documents
  add_all_documents

  # On ajoute le pied du fichier XHTML
  @stream << "</body>\n</html>\n"
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
  files = film.documents || Dir["#{film.folder_documents}/**/*.md"]
  files.each do |src|
    log("Extension : #{File.extname(src).inspect}")
    if ['.html','.htm'].include?(File.extname(src))
      # C'est un code HTML déjà préparé
      dst = File.join(film.folder_products, File.basename(src))
      log("Fichier #{src.inspect} recherché dans #{dst.inspect}")
      next if not(File.exists?(dst))
    else
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
