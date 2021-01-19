# encoding: UTF-8
# frozen_string_literal: true
=begin


  Pour les informations de conversion et de préparation donc du
  fichier final XHTML, cf. notamment :

      https://manual.calibre-ebook.com/fr/conversion.html

  Beaucoup d'informations sur XHTML -> eBook

      http://bbebooksthailand.com/developers.html

=end

require_module('books')
Film.current.build_books
