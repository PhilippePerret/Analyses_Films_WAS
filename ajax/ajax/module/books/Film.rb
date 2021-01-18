# encoding: UTF-8
# frozen_string_literal: true
class Film

  # = main =
  def build_books
    folder_finaux # Simplement pour s'assurer qu'il existe
    build_book(mobi_file_name)
    build_book(epub_file_name)
    build_book(pdf_file_name)
  end

  # Construction d'un livre au format voulu
  def build_book(dst, src = nil)
    src ||= html_file_name
    File.delete(dst) if File.exists?(dst)
    `cd "#{folder}" && #{EBOOK_CONVERT_CMD} ./products/#{src} ./finaux/#{dst}`
  end

  def html_file_name  ; @html_file_name   ||= "final.html"  end
  def mobi_file_name  ; @mobi_file_name   ||= "final.mobi"  end
  def epub_file_name  ; @epub_file_name   ||= "final.epub"  end
  def pdf_file_name   ; @pdf_file_name    ||= "final.pdf"   end

end #/Film
