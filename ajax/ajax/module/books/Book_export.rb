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
def export
  export_as('HTML')
  export_as('MOBI')
  export_as('ePUB')
  export_as('PDF')
end

def export_as(format)
  build_book(send("#{format.downcase}_file_name".to_sym))
end #/ export_as(format)

# Construction du livre au format voulu
def build_book(dst, src = nil)
  src ||= xhtml_file_name
  File.delete(dst) if File.exists?(dst)
  `cd "#{film.folder}";#{EBOOK_CONVERT_CMD} ./products/#{src} ./finaux/#{dst}`
end

# Le fichier source
def xhtml_file_name  ; @xhtml_file_name   ||= "final.xhtml"  end
# Les fichiers destination
def html_file_name  ; @html_file_name   ||= "final.html"  end
def mobi_file_name  ; @mobi_file_name   ||= "final.mobi"  end
def epub_file_name  ; @epub_file_name   ||= "final.epub"  end
def pdf_file_name   ; @pdf_file_name    ||= "final.pdf"   end

end #/Book
