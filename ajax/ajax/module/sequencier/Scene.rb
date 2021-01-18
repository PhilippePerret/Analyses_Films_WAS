# encoding: UTF-8
# frozen_string_literal: true
class Scene
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :data
attr_accessor :numero, :time_fin
def initialize(data)
  @data = data
end

# ---------------------------------------------------------------------
#
#   Helpers
#
# ---------------------------------------------------------------------

# Intitulé de scène
def intitule
  @intitule ||= begin
    @template_intitule ||= "%{num}. %{lieu} %{decor}%{effet}"
    (@template_intitule % {num:numero, lieu:hlieu, decor:hdecor, effet:heffet}).upcase
  end
end

# Ligne de time
def times_infos
  @template_times ||= "De #{hstart} à #{hfin} — Durée : #{duree.s2h(false)}"
end #/ times_infos


def hlieu   ; @hlieu    ||= LIEUX[lieu][:hname]     end
def heffet  ; @heffet   ||= EFFETS[effet][:hname]   end
def hdecor
  @hdecor ||= begin
    if decor.nil? || decor.empty?
      ""
    else
      formate("#{Film.current.decors[decor]} – ")
    end
  end
end
def hstart  ; @hstart ||= time.to_i.s2h(false)     end
def hfin    ; @hfin   ||= time_fin.to_i.s2h(false) end

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
def decor ; @decor  ||= data['decor']   end
def lieu
  @lieu ||= (type.split(':')[1]||'i').to_sym
end
def effet
  @effet ||= (type.split(':')[2]||'j').to_sym
end #/ effet

end #/Scene
