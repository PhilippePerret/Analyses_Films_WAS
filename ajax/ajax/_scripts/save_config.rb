# encoding: UTF-8
=begin

  Script qui retourne le fichier config du film courant

=end
begin
  Film.current.save_config(Ajax.param(:config))
rescue Exception => e
  Ajax.error(e)
end
