# encoding: UTF-8
# frozen_string_literal: true
class Film

  # = main =
  def build_books
    folder_finaux # Simplement pour s'assurer qu'il existe
    `open -a Finder "#{folder}"`
    book = Book.new(self)
    book.prepare
    book.export
  end

end #/Film
