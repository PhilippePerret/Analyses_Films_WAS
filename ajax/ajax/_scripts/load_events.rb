# encoding: UTF-8
=begin

  Script qui retourne tous les évènements du film courant

=end
require 'yaml'

begin
  film = Film.current
  if File.exists?(film.events_folder)
  else
    []
  end
  Ajax << {events: Film.current.get_events.sort_by{|e|e['time'].to_f}}

rescue Exception => e
  Ajax.error(e)
end
