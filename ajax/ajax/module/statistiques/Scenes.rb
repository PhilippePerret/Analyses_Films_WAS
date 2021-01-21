# encoding: UTF-8
# frozen_string_literal: true
class Scenes # ATTENTION ! ÇA N'EST PAS LA CLASSE Scene
class << self
  def build_stats
    prepare_listes_classees
    ret = []

    ret << htitle('Valeurs générales', 3)
    ret << table({
      columns:[
        {title:'Objet',   width:40},
        {title:'Valeur', width:20}
      ],
      values:[
        ['Nombre total de scènes', film.scenes_count],
        ['Moyenne par :moyenne', film.sorted_scenes.moyenne(:duree).to_i.to_horloge],
        ['Écart-type de durée', film.sorted_scenes.ecart_type(:duree)]
      ]
    })

    ret << htitle('Les plus et les moins',3)
    bestScene   = @sorted_per_duree.first
    worstScene  = @sorted_per_duree.last
    ret << table({
      columns:[
        {title:'Scène…', width:30},
        {title:'Scène', width:50},
        {title:'Durée', width:20, type: :time_scenes}
      ],
      values:[
        ['… la plus longue', bestScene.output({as: :stats}), bestScene.duree],
        ['… la plus courte', worstScene.output(as: :stats), worstScene.duree]
      ]
    })

    ret << htitle("Scènes classées par durée", 3)
    ret << table({
      columns:[
        {title:'Scène', width:60},
        {title:'Durée', width:20, type: :time_scenes}
      ],
      values:@sorted_per_duree.collect do |scene|
        [scene.output(as: :stats), scene.duree]
      end
    })

    return ret.join("\n")
  end #/ build_stats


  def prepare_listes_classees
    @sorted_per_duree = film.sorted_scenes.sort_by(&:duree).reverse

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

end #/Scene
