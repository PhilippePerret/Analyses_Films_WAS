# encoding: UTF-8
# frozen_string_literal: true

# Verbosité de la commande ebook-convert
VERBOSE = 2


class Film
  attr_reader :export_errors

  # = main =
  #
  # +type+ Le type du livre à construire, parmi 'mobi','html','epub','pdf'
  # Si non fourni, tous les livres sont construits.
  def build_books(type = nil)
    @export_errors = []
    suivi("=== Lancement de la construction du #{Time.now} ===")
    require_module('scenes')
    suivi('S’assurer que tous les dossiers nécessaires existent')
    ensure_required_folders # Simplement pour s'assurer qu'il existe
    `open -a Finder "#{folder}"`
    book = Book.new(self)
    book.prepare
    book.export(type)
    suivi("=== Fin de la construction ===")
    Ajax << {export_errors: export_errors}
  ensure
    refsuivi.close if @refsuivi
  end

  # Pour écrire des messages de suivi au cours de la construction
  def suivi(msg)
    refsuivi.write("#{Time.now.strftime('%H:%M:%S')} #{msg}\n")
  end
  def refsuivi
    @refsuivi ||= begin
      File.delete(pathsuivi) if File.exists?(pathsuivi)
      File.open(pathsuivi,'a')
    end
  end
  def pathsuivi
    @pathsuivi ||= File.join(folder,'xbuilding.log')
  end


end #/Film
