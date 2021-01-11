# encoding: UTF-8
=begin

  Script qui sauve l'évènement dont on envoie les données

=end
require 'yaml'

begin
  Film.current.save_event(Ajax.param(:data))
  Ajax << {ok: true}
rescue Exception => e
  Ajax.error(e)
end
