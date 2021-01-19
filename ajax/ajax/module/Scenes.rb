# encoding: UTF-8
# frozen_string_literal: true
=begin

  film.sorted_scenes => array des instances Scene classées
  film.scene(numero)    => instance Scene de la scène de numéro #numero
  film.scene_per_event(id_event)  => instance Scene de la scène définie par
      l'event +id_event+

=end
require_relative 'data'
require_relative 'AEvent'

class Film
  attr_reader :scenes_per_event, :scenes_per_numero

  def scene_per_event(event_id)
    scenes_per_event || sorted_scenes
    scenes_per_event[event_id]
  end
  alias :scene_per_id :scene_per_event

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
  # C'est un Array d'instances Scene dans l'ordre des évènement
  # Pour une liste des scènes classées dans l'ordre, utiliser sorted_scenes
  #
  # ATTENTION : si on a besoin de la durée de la scène et de son numéro,
  #             on doit impérativement utiliser sorted_scenes
  def ary_scenes
    @ary_scenes ||= begin
      @scenes_per_event = {}
      get_events(type: 'sc').collect do |devent|
        Scene.new(devent).tap do |sc|
          @scenes_per_event.merge!(devent['id'] => sc)
        end
      end
    end
  end #/ scenes

end #/class Film

class Scene < AEvent
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_accessor :numero, :time_fin
def initialize(data)
  super(data)
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


# ---------------------------------------------------------------------
#
#   HELPERS
#
# ---------------------------------------------------------------------

# Sort la scène au format voulu en fonction de +params+
# +params+ est un Hash qui peut définir :
#   intitule:     true/false
#   resume:       true/false
#   times_infos:  true/false
#   content:      true/false
#   Ou la propriété :format, par exemple "%{intitule}%{times_infos}%{resume}"
def output(params)
  if params.key?(:format)
    fmt = params[:format]
  else
    fmt = []
    fmt << '%{intitule}'    if params[:intitule]
    fmt << '%{times_infos}' if params[:times_infos]
    fmt << '%{resume}'      if params[:resume]
    fmt << '%{content}'     if params[:content]
    fmt = fmt.join('')
  end
  fmt % {intitule:f_intitule, times_infos:f_times_infos, resume:f_resume, content:f_content}
end #/ output

def f_intitule
  @f_intitule ||= "<p class='scene_intitule'>#{intitule}</p>\n"
end
def f_times_infos
  @f_times_infos ||= "<p class='scene_times_infos'>#{times_infos}</p>\n"
end
def f_resume
  @f_resume ||= "<p class='scene_resume'>#{resume}</p>\n"
end
def f_content
  @f_content ||= "<p class='scene_content'>#{real_content}</p>\n"
end


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
# def hstart  ; @hstart ||= time.to_i.s2h(false)      end
def hfin    ; @hfin   ||= time_fin.to_i.s2h(false)  end
def fduree  ; @fduree ||= duree.to_i.s2h(false)     end

def resume
  @resume ||= begin
    formate(content.split("\n").first.strip)
  end
end

def formated_resume
  @formated_resume ||= "scène #{numero}. à #{hstart} « #{resume} »"
end

def decor ; @decor  ||= data['decor']   end
def lieu
  @lieu ||= (type.split(':')[1]||'i').to_sym
end
def effet
  @effet ||= (type.split(':')[2]||'j').to_sym
end #/ effet

end #/Scene
