# encoding: UTF-8
# frozen_string_literal: true
=begin

  film.sorted_scenes => array des instances Scene classées
  film.scene(numero)    => instance Scene de la scène de numéro #numero
  film.scene_per_event(id_event)  => instance Scene de la scène définie par
      l'event +id_event+

=end
class Film
  attr_reader :scenes_per_event, :scenes_per_numero

  def scene_per_event(event_id)
    scenes_per_event[event_id]
  end

  def scene(numero)
    scenes_per_numero(numero)
  end
  alias :scene_per_numero :scene

  # Retourne la liste des scènes classées par temps
  # Note : les propriétés :numero et :time_fin ont été renseignées
  def sorted_scenes
    @sorted_scenes ||= begin
      numCur = 0
      # scenes.sort_by{|sc| sc.time}.collect{|sc|sc.numero = (numCur += 1)}
      ary_scenes.sort_by!(&:time)
      ary_scenes.each do |sc|
        sc.numero = (numCur += 1)
      end
      # Pour obtenir la liste par numéro
      @scenes_per_numero = {}
      # On ajoute le temps de fin (début de la suivante)
      last_start = Film.current.duration.dup
      ary_scenes.reverse.each do |sc|
        sc.time_fin = last_start.dup
        last_start = sc.time
        @scenes_per_numero.merge!(sc.numero => sc)
      end
      ary_scenes.each do |sc|
      end

      ary_scenes
    end
  end #/ sorted_scenes


  # Retourne la liste des scènes
  # C'est un Array d'instance Scene dans l'ordre du film
  def ary_scenes
    @ary_scenes ||= begin
      @scenes_per_event = {}
      get_events(type: 'sc').collect do |devent|
        sc = Scene.new(devent)
        @scenes_per_event.merge!(devent['id'] => sc)
        sc
      end
    end
  end #/ scenes

end #/class Film

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
      formate("#{Film.current.decors[decor].hname} – ")
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

def formated_resume
  @formated_resume ||= "Scène #{numero}. #{resume}"
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
