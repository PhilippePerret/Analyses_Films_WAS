# encoding: UTF-8
=begin

  Script qui retourne tous les évènements du film courant

=end
begin
  Ajax << {items: Film.current.get_locators}
rescue Exception => e
  Ajax.error(e)
end
