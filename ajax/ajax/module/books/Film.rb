# encoding: UTF-8
# frozen_string_literal: true
class Film

  # = main =
  #
  # +type+ Le type du livre à construire, parmi 'mobi','html','epub','pdf'
  # Si non fourni, tous les livres sont construits.
  def build_books(type = nil)
    folder_finaux # Simplement pour s'assurer qu'il existe
    `open -a Finder "#{folder}"`
    book = Book.new(self)
    book.prepare
    book.export(type)
  end

end #/Film
