# encoding: UTF-8
# frozen_string_literal: true
=begin
Class Book
----------
Pour gérer le livre
=end
require 'kramdown'

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

  # On ouvre le flux vers le fichier XHTML final
  @stream = File.open(xhtml_file_path,'a')

  # On ajoute l'entête du fichier XHTML
  @stream << xhtml_header(film.title)

  # On ajoute tous les documents
  add_documents

  # On ajoute le pied du fichier XHTML
  @stream << "</body>\n</html>"

ensure
  # On ferme le flux vers le fichier XHTML final
  @stream.close
end


# Ajout de tous les documents dans le fichier XHTML
# On doit prendre tous les documents .md du dossier 'documents', en faire
# des fichiers HTML simples (avec kramdown) puis les ajouter au flux
def add_documents
  # Soit la liste des documents est déterminée par la configuration,
  # soit on prend les documents dans l'ordre du dossier (mauvais car c'est
  # très aléatoire)
  files = film.documents || Dir["#{film.folder_documents}/**/*.md"]
  files.each do |src|
    affixe  = File.basename(src, File.extname(src))
    dst     = File.join(film.folder_products,"#{affixe}.html")
    File.delete(dst) if File.exists?(dst)
    File.open(dst,'wb'){|f| f.write(Kramdown::Document.new(File.read(src).force_encoding('utf-8')).to_html)}
    @stream << File.read(dst)
  end
end

def xhtml_header(title, css_path = 'styles.css')
  <<-XHTML
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
<link type="text/css" rel="stylesheet" href="#{css_path}" />
<title>#{title}</title>
</head>
<body>
  XHTML
end #/ xhtml_header

def xhtml_file_path
  @xhtml_file_path ||= File.join(film.folder_products,xhtml_file_name)
end

end #/Book
