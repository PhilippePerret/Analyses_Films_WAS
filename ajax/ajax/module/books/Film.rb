# encoding: UTF-8
# frozen_string_literal: true
class Film
  attr_reader :export_errors

  # = main =
  #
  # +type+ Le type du livre à construire, parmi 'mobi','html','epub','pdf'
  # Si non fourni, tous les livres sont construits.
  def build_books(type = nil)
    @export_errors = []
    folder_finaux # Simplement pour s'assurer qu'il existe
    `open -a Finder "#{folder}"`
    book = Book.new(self)
    book.prepare
    book.export(type)
    Ajax << {export_errors: export_errors}
  end

end #/Film
