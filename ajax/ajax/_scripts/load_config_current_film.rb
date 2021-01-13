# encoding: UTF-8
=begin

  Script qui retourne le fichier config du film courant

=end
require 'yaml'

begin
  film = Film.current
  if film.nil?
    Ajax << {error: "Impossible de trouver un fichier config.yml dans un dossier de _FILMS_… (dans #{path.inspect})"}
  else
    Ajax << {config: film.config}
  end
rescue Exception => e
  Ajax.error(e)
end
