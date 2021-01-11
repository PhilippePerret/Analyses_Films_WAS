# encoding: UTF-8
# frozen_string_literal: true
require 'yaml'

class Film
class << self
  def current; @current ||= new(Dir["../_FILMS_/*"].first) end
end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :folder
def initialize(folder)
  @folder = folder
end #/ initialize
def save_event(data)
  File.open(File.join(events_folder,"event-#{data['id']}.yml"),'wb') do |f|
    f.write(YAML.dump(data))
  end
end
# Pour détruire un évènement
# TODO Plus tard, on le mettra de côté
def destroy_event(eid)
  path = File.join(events_folder,"event-#{eid}.yml")
  File.delete(path) if File.exists?(path)
end #/ destroy_event
def get_events
  Dir["#{events_folder}/*.yml"].collect do |f|
    YAML.load_file(f)
  end
end
def events_folder
  @events_folder ||= mkdir(File.join(folder,'events'))
end
end #/Film
