# encoding: UTF-8
# frozen_string_literal: true
class Personnage
class << self

  # = main =
  #
  # Méthode qui construit les statistiques pour les personnages
  #
  def build_stats
    require_module('Personnage')
    prepare_listes_classees
    ret = []

    ret << htitle('Les plus et les moins', 3)

    veryBest        = @sorted_universal.first
    veryWorst       = @sorted_universal.last
    bestPerScenes   = @sorted_per_scenes.first
    bestPerDuree    = @sorted_per_duree.first
    worstPerScenes  = @sorted_per_scenes.last
    worstPerDuree   = @sorted_per_duree.last

    ret << table({
      columns:[
        {title:"Personnage qui est…",       width:40},
        {title:"Personnage",  width:20},
        {title:"Valeur",      width: 20}
      ],
      values:[
        ["… le plus utilisé", veryBest.full_name, veryBest.f_pct_presence],
        ["… dans le plus de scènes", bestPerScenes.full_name, bestPerScenes.scenes_count, {2 => :scenes}],
        ["… le plus longtemps à l'écran", bestPerDuree.full_name, bestPerDuree.use_duration, {2 => :time_scenes}],
        ["… le moins utilisé", veryWorst.full_name, veryWorst.f_pct_presence],
        ["… dans le moins de scènes", worstPerScenes.full_name, worstPerScenes.scenes_count, {2 => :scenes}],
        ["… le moins longtemps à l'écran", worstPerDuree.full_name, worstPerDuree.use_duration, {2 => :time_scenes}]
      ]
    })


    # Classement absolu des personnage
    ret << htitle("Classement absolu des personnages #{ASTERISQUE_NOTE}", 3)
    ret << div("(#{ASTERISQUE_NOTE} moyenne de la durée d'utilisation et du nombre de scènes)", 'small italic')
    ret << table({
      columns:[
        {title:'Personnage', width:40},
        {title:'Présence', width:20}
      ],
      values:  @sorted_universal.collect do |personnage|
        [personnage.ref, personnage.f_pct_presence]
      end
    })

    # Liste classement en durée
    ret << htitle("Classement des personnages par temps à l'écran", 3)
    ret << table({
      columns:[
        {title:"Personnage", width:40},
        {title:"Temps à l'écran", width:20, type: :time_scenes}
      ],
      values: @sorted_per_duree.collect do |personnage|
        [personnage.full_name, personnage.use_duration]
      end,
      options:{
        no_zeros: true
      }
    })

    # Liste classement en nombre de scènes
    ret << htitle("Classement des personnages par nombre de scènes", 3)
    # @sorted_per_scenes
    ret << table({
      columns:[
        {title:"Personnage", width:40},
        {title:"Nombre de scènes", width:20, type: :scenes}
      ],
      values: @sorted_per_scenes.collect do |personnage|
        [personnage.full_name, personnage.scenes_count]
      end,
      options:{
        no_zeros: true
      }
    })

    return ret.join('')
  end #/ build_stats

# Méthode qui prépare les listes de personnages pour les statistiques
def prepare_listes_classees
  # On initialise les valeurs des personnages
  film.personnages.each do |kp, personnage|
    personnage.use_duration = 0
    personnage.scenes_count = 0
  end
  # On relève les durées d'utilisation et le nombre de scènes
  film.sorted_scenes.each do |scene|
    film.personnages.each do |pkey, personnage|
      if scene.content.match?(/\b#{pkey}\b/)
        # => Le personnage appartient à la scène
        personnage.use_duration += scene.duree
        personnage.scenes_count += 1
      end
    end
  end

  @sorted_per_duree   = film.personnages.values.sort_by(&:use_duration).reverse
  @sorted_per_scenes  = film.personnages.values.sort_by(&:scenes_count).reverse
  @sorted_universal   = film.personnages.values.sort_by(&:presence).reverse
end #/ prepare_listes_classees


def film
  @film ||= Film.current
end #/ film

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_accessor :use_duration, :scenes_count

# La "Présence" est une moyenne entre la durée et le nombre de scène,
# qui permet de connaitre le classement absolu d'un personnage
def presence
  @presence ||= ((taux_duree + taux_scenes).to_f / 2)
end
def f_pct_presence
  @f_pct_presence ||= "#{(presence * 100).round(1)} %"
end

def taux_duree
  @taux_duree ||= use_duration.to_f / Film.current.duration
end
def taux_scenes
  @taux_scenes ||= scenes_count.to_f / Film.current.scenes_count
end #/Decor

end #/Personnage
