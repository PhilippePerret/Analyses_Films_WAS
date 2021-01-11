# encoding: UTF-8
=begin

  Script qui sauve l'évènement dont on envoie les données

=end
require 'yaml'

begin
  if Film.current
    Film.current.destroy_event(Ajax.param(:event_id))
    Ajax << {ok: true}
  else
    Ajax << {error: "Il n'y a pas de film courant !"}
  end
rescue Exception => e
  Ajax.error(e)
end
