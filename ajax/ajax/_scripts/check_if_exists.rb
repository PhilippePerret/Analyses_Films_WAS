# encoding: UTF-8
# frozen_string_literal: true
=begin
  Pour tester l'existence d'un fichier ou d'un dossier
=end
checked_path = File.join(Film.current.folder,Ajax.param(:rpath))
log("Path checké : #{checked_path} (existe ? #{File.exists?(checked_path).inspect})")
Ajax << {exists: File.exists?(checked_path)}
