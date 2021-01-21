# encoding: UTF-8
# frozen_string_literal: true

class Decor
class << self

# = main =
#
# Méthode principale qui calcule les statistiques concernant les décors
def build_stats
  require_module('Decors')

  make_liste_classees

  ret = []

  ret << htitle("Lieux et effets de scènes", 3)

  # Les lieux
  # ---------
  de = @durees_lieux
  ret << table({
    columns:[
      {width:40, title:'Lieux'},
      {width:25, title:'Durée', type: :time_scenes},
      {width:20, title:'Nombre scènes', type: :scenes}
    ],
    values:[
      de[:e].unshift("Scènes en extérieur"),
      de[:i].unshift("Scènes en intérieur"),
      de[:ie].unshift("Scènes en ext. et int.").push(no_zero:true),
      de[:x].unshift("Scènes dans autres lieux").push(no_zero:true)
    ]
  })

  # Les effets
  # ----------
  de = @durees_effets
  ret << table({
    columns:[
      {width:20, title:'Effet'},
      {width:30, title:'Durée',         type: :time_scenes},
      {width:30, title:'Nombre scènes', type: :scenes}
    ],
    values:[
      de[:j].unshift('Scènes de jour'),
      de[:n].unshift('Scènes de nuit'),
      de[:m].unshift('Scènes du matin').push(no_zero: true),
      de[:s].unshift('Scènes du soir').push(no_zero: true),
      de[:x].unshift('Autres (p.e. Noir)').push(no_zero: true)
    ]
  })

  ret << htitle('Les plus et les moins', 3)

  # Le décor le plus utilisé (en nombre de fois et en durée)
  veryBest      = @sorted_universal.first
  veryWorst     = @sorted_universal.last
  bestPerTime   = @sorted_per_duree.first
  worstPerduree = @sorted_per_duree.last
  bestPerCount  = @sorted_per_count.first
  worstPerCount = @sorted_per_count.last

  ret << table({
    columns:[
      {width:40, title: 'Décor qui est…'},
      {width:45, title: 'Lieu'},
      {width:15, title: 'Valeur'}
    ],
    values: [
      ["… le plus utilisé", veryBest.ref, veryBest.f_pct_presence],
      ["… utilisé le plus longtemps", bestPerTime.ref, bestPerTime.use_duree, {2 => :time}],
      ["… utilisé dans le plus de scènes", bestPerCount.ref, bestPerCount.use_count, {2 => :scenes}],
      ["… le moins utilisé", veryWorst.ref, veryWorst.f_pct_presence],
      ["… utilisé le moins longtemps",worstPerduree.ref, worstPerduree.use_duree, {2 => :time}],
      ["… utilisé dans le moins de scènes", worstPerCount.ref, worstPerCount.use_count, {2 => :scenes}]
    ]
  })

  # Classement absolu des décors
  ret << htitle("Classement absolu des décors #{ASTERISQUE_NOTE}", 3)
  ret << div("(#{ASTERISQUE_NOTE} moyenne de la durée d'utilisation et du nombre de scènes)", 'small italic')
  ret << table({
    columns:[
      {title:'Décor', width:40},
      {title:'Présence', width:20}
    ],
    values:  @sorted_universal.collect do |decor|
      [decor.ref, decor.f_pct_presence]
    end
  })

  # L'utilisation des décors par temps d'utilisation
  ret << htitle("Classement des décors par durée d’utilisation", 3)
  ret << table({
    columns:[
      {width:40, title: "Décor"},
      {width:20, title: "Durée", type: :time}
    ],
    values:@sorted_per_duree.collect do |decor|
      [decor.hname, decor.use_duree]
    end
  })

  # L'utilisation des décors par nombre de scènes
  ret << htitle("Classement des décors par nombre de scènes", 3)
  ret << table({
    columns:[
      {width:70, title: "Décor"},
      {width:20, title: "Nombre de scènes", type: :scenes}
    ],
    values: @sorted_per_count.collect do |decor|
      [decor.hname, decor.use_count]
    end
  })

  return ret.join("\n")
end #/ build_stats_decors

# Méthode qui prend la liste des décors et fait les listes classées par
# durée, nombre de scènes, etc.
def make_liste_classees
  @liste = film.decors.values

  # Initialiser les valeurs
  @liste.each do |decor|
    decor.use_duree = 0
    decor.use_count = 0
  end

  @durees_lieux = {}
  LIEUX.each {| k,d| @durees_lieux.merge!(k => [0, 0])} # [temps, nombre fois]
  @durees_effets = {}
  EFFETS.each {| k,d| @durees_effets.merge!(k => [0, 0])} # [temps, nombre fois]

  # Note : il faut travailler avec la liste des scènes classées pour
  # que leur durée soit définie
  film.sorted_scenes.each do |scene|
    decor = film.decor(scene.decor)
    @durees_lieux[scene.lieu][0] += scene.duree
    @durees_lieux[scene.lieu][1] += 1
    @durees_effets[scene.effet][0] += scene.duree
    @durees_effets[scene.effet][1] += 1
    next if decor.nil?
    decor.use_duree += scene.duree
    decor.use_count += 1
    if decor.parent
      decor.parent.use_duree += scene.duree
      decor.parent.use_count += 1
    end
  end
  @sorted_per_duree    = @liste.sort_by(&:use_duree).reverse
  @sorted_per_count    = @liste.sort_by(&:use_count).reverse
  @sorted_universal = @liste.sort_by(&:presence).reverse
end #/ make_liste_classees

def film
  @film ||= Film.current
end

end # /Decor << self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
# Pour enregistrer leur durée d'utilisation et leur nombre de scène
attr_accessor :use_duree, :use_count

# La "Présence" est une moyenne entre la durée et le nombre de scène,
# qui permet de connaitre le classement absolu d'un décor
def presence
  @presence ||= ((taux_duree + taux_scenes).to_f / 2)
end
def f_pct_presence
  @f_pct_presence ||= "#{(presence * 100).round(1)} %"
end

def taux_duree
  @taux_duree ||= use_duree.to_f / Film.current.duration
end
def taux_scenes
  @taux_scenes ||= use_count.to_f / Film.current.scenes_count
end

end #/Decor
