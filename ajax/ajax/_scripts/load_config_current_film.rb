# encoding: UTF-8
=begin
  Script qui retourne le fichier config du film courant
  Noter que ce film existe toujours, sauf si on a détruit le dossier 'xDefault'
=end
Ajax << {config: Film.current.config}
