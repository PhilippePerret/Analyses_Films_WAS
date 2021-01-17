# encoding: UTF-8
# frozen_string_literal: true
=begin
  Script qui permet d'ouvrir le dossier du film courant
=end

Film.current.open_in_finder
Ajax << {message: "Le dossier du film “#{Film.current.title}” est ouvert dans le finder."}
