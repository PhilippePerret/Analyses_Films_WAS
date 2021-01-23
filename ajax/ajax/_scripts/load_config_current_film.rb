# encoding: UTF-8
=begin
  Script qui retourne le fichier config du film courant
  Noter que ce film existe toujours, sauf si on a détruit le dossier 'xDefault'
=end
Film.current.retrieving_video_required?
Film.current.audio_file_required?
Ajax << {config: Film.current.config}
