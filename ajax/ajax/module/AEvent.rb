# encoding: UTF-8
# frozen_string_literal: true
=begin
  Gestion des events dans les textes
=end
require_relative 'data'

class Film
  # Retourne l'instance d'évènement quelconque d'identifiant +eid+
  def event(eid)
    @items ||= {}
    @items[eid.to_i] ||= begin
      AEvent.new(YAML.load_file(File.join(folder_events,"event-#{eid}.yml")))
    end
  end
end #/Film


class AEvent
attr_reader :data

def initialize(data)
  @data ||= data
end #/ initialize

def output(params)
  if params.key?(:as)
    if params[:as] == :traitement
      "#{f_type}#{f_times_infos}#{f_resume}#{f_content}"
    end
  end
end #/ output


def f_type
  @f_type ||= "<span class='event_type'>#{htype}</span>"
end #/ f_type
def f_times_infos
  @f_times_infos ||= "<span class='event_times_infos'>à #{hstart}</span>"
end
def f_resume
  @f_resume ||= "<p class='event_resume'>#{resume}</p>\n"
end
def f_content
  @f_content ||= "<p class='event_content'>#{real_content}</p>\n"
end


def hstart  ; @hstart ||= time.to_i.s2h(false)        end
def htype   ; @htype  ||= TYPES_EVENTS[main_type][:hname]  end

def formated_resume
  log("type:#{type.inspect} ##{id.inspect}")
  @formated_resume ||= "#{htype} ##{id} (« #{resume} »)"
end

def resume
  @resume ||= begin
    formate(content.split("\n").first.strip)
  end
end

# Le "vrai contenu" est le contenu sans le premier paragraphe qui
# sert de résumé de scène.
def real_content
  @real_content ||= begin
    ps = content.split("\n")
    ps.shift # pour retirer le résumé
    formate(ps.join("\n").strip)
  end
end

def main_type
  @main_type ||= type.split(':')[0]
end
def sub_type
  @sub_type ||= type.split(':')[1]
end
def ter_type
  @ter_type ||= type.split(':')[2]
end

# ---------------------------------------------------------------------
#
#   Propriétés brutes
#
# ---------------------------------------------------------------------
def content
  @content ||= data['content']
end #/ content
def time
  @time ||= data['time'].to_f
end
def duree ; @duree  ||= (time_fin - time).to_i end
def type  ; @type   ||= data['type']    end
def id    ; @id     ||= data['id']      end

def in_traitement?
 @mettre_dans_traitement ||= not(data['no_treatment'] === true)
end

def scene?
  @is_scene || type == 'sc'
end #/ scene?

end #/AEvent
