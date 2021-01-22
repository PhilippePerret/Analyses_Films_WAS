# encoding: UTF-8
# frozen_string_literal: true
=begin
  Module pour définir l'analyse courante
=end

dossier = Ajax.param(:dossier)

if Film.isFolderFilm?(dossier)
  Film.set_current(dossier)
else
  raise "Le dossier du film #{dossier.inspect} est introuvable…"
end
