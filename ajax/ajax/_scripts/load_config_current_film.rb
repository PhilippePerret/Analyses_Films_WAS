# encoding: UTF-8
=begin

  Script qui retourne le fichier config du film courant

=end
require 'yaml'

begin
  path = File.expand_path("../_FILMS_/**/config.yml")
  config_file = Dir["#{APP_FOLDER}/_FILMS_/**/config.yml"].first
  if config_file.nil?
    Ajax << {error: "Impossible de trouver un fichier config.yml dans un dossier de _FILMS_… (dans #{path.inspect})"}
  else
    conf = YAML.load_file(config_file)
    conf.merge!(film_folder: File.basename(File.dirname(config_file)))
    Ajax << {config: conf}
  end
rescue Exception => e
  Ajax.error(e)
end
