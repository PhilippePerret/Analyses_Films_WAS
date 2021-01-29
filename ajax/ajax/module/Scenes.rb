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
require_relative 'Decors'

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
      # [1] Ici, on n'a pas besoin de retirer la valeur Film.current.zero,
      #     car la valeur @time de la scène est déjà pondérée.
      last_start = duration.dup
      ary_scenes.reverse.each do |sc|
        sc.time_fin = last_start.dup # Cf. note [1] ci-dessus
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

  def scenes_count
    @scenes_count ||= ary_scenes.count
  end #/ scenes_count

end #/class Film

class Scene < AEvent
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------

# Défini quand on classe les scènes
attr_accessor :numero, :time_fin

# Défini quand on prépare la sortie
attr_accessor :events

def initialize(data)
  super(data)
end

def ref
  @ref ||= "Scène #{numero||"##{id}"} « #{resume} »"
end

# ---------------------------------------------------------------------
#
#   Helpers
#
# ---------------------------------------------------------------------


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
#   OU la propriété :as qui peut être
#     :sequencier   => intitulé + times + resume
#     :synopsis     => real content
#     :traitement   => intitule + times + resume + real content + events
def output(params)
  if params.key?(:as)
    case params[:as].to_sym
    when :sequencier
      fmt = parag('%{numero}%{resume}') + parag('%{times_infos} | %{lieu} %{decor}%{effet}','infos')
    when :traitement
      fmt = parag('%{span_numero}%{span_resume} | %{span_intitule_sans_numero}','intitule') + f_times + f_content + f_all_events
    else
      return '<div class="scene">' + send("output_as_#{params[:as]}".to_sym) + '</div>'
    end
  elsif params.key?(:format)
    fmt = params[:format]
  else
    fmt = []
    fmt << '%{intitule}'    if params[:intitule]
    fmt << '%{par_times_infos}' if params[:times_infos]
    fmt << '%{par_resume}'      if params[:resume]
    fmt << '%{content}'     if params[:content]
    fmt = fmt.join('')
  end
  div(fmt % {
    numero:span_numero, span_numero:span_numero,
    par_intitule:par_intitule, span_intitule:span_intitule, intitule:intitule,
    span_intitule_sans_numero:span_intitule_sans_numero,
    par_times_infos:par_times_infos,
    times_infos:times_infos,
    par_resume:par_resume, resume:span_resume, span_resume:span_resume,
    content:f_content,
    lieu:hlieu, effet:heffet, decor:hdecor
  }, 'scene')
end #/ output

def output_as_synopsis
  "<p><span class='time'>#{hstart}</span>#{f_force_content}</p>"
end
# L'intitulé dans les statistiques
def output_as_stats
  formated_resume
end

def span_numero
  @span_numero ||= span("#{numero}. ", 'scene_numero')
end

# Intitulé de scène
def intitule
  @intitule ||= begin
    @template_intitule ||= '%{num}. %{lieu} %{decor}%{effet}'
    (@template_intitule % {num:numero, lieu:hlieu, decor:hdecor, effet:heffet}).upcase
  end
end
def intitule_sans_numero
  @intitule_sans_numero ||= begin
    @template_intitule_sans_num ||= '%{lieu} %{decor}%{effet}'
    (@template_intitule_sans_num % {lieu:hlieu, decor:hdecor, effet:heffet}).upcase
  end
end

# Ligne de time
def times_infos
  @template_times ||= "De #{hstart} à #{hfin} | Durée : #{duree.s2h(false)}"
end #/ times_infos

def par_intitule
  @par_intitule ||= parag(intitule,'scene_intitule')
end
def span_intitule
  @span_intitule ||= span(intitule,'scene_intitule')
end
def span_intitule_sans_numero
  @span_intitule_sans_numero ||= span(intitule_sans_numero,'scene_intitule')
end
def par_times_infos
  @par_times_infos ||= parag(times_infos,'scene_times_infos')
end
alias :f_times :par_times_infos
def span_resume
  @span_resume ||= span(resume,'scene_resume')
end
def par_resume
  @par_resume ||= parag(resume,'scene_resume')
end
def f_content
  @f_content ||= parag(real_content,'scene_content')
end
# Même méthode que f_content, mais celle-ci force le contenu de la scène et
# prend le résumé s'il est le seul à être défini (première ligne)
def f_force_content
  @f_content ||= parag(real_content.empty? ? resume : real_content,'scene_content')
end

# Retourne le formatage de tous les évènements appartenant à la
# scène
def f_all_events
  @f_all_events ||= begin
    div((events||[]).collect { |e| e.output(as: :traitement) }.join(''),'events')
  end
end #/ f_all_events


def hlieu   ; @hlieu    ||= LIEUX[lieu][:hname]     end
def heffet  ; @heffet   ||= EFFETS[effet][:hname]   end
def hdecor
  @hdecor ||= begin
    if decor.nil? || decor.empty?
      ""
    elsif Film.current.decor(decor).nil?
      log("# ERREUR : DÉCORS INTROUVABLE : #{decor.inspect}")
      "[Décor introuvable : #{decor}]"
    else
      formate("#{Film.current.decor(decor).hname} – ")
    end
  end
end
def hstart  ; @hstart ||= time.to_i.s2h(false)      end
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

def decor
  @decor ||= begin
    de = data['decor']
    de = nil if data['decor'] == 'x'
    de
  end
end
def lieu
  @lieu ||= (type.split(':')[1]||'i').to_sym
end
def effet
  @effet ||= (type.split(':')[2]||'j').to_sym
end #/ effet

end #/Scene
