# encoding: UTF-8
# frozen_string_literal: true

class Decor
class << self

# = main =
#
# Méthode principale qui calcule les statistiques concernant les décors
def build_stats_decors
  require_module('Decors')

  make_liste_classees

  ret = []
  ret << '<table>'
  # Les lieux
  # ---------
  de = @durees_lieux
  ret << table({
    columns:[
      {width:40, title:'Lieux'},
      {width:25, title:'Durée', type: :time},
      {width:20, title:'Nombre scènes', type: :scenes}
    ],
    values:[
      de[:e].unshift("Scènes en extérieur"),
      de[:i].unshift("Scènes en intérieur"),
      de[:ie].unshift("Scènes en ext. et int."),
      de[:x].unshift("Scènes dans autres lieux")
    ],
    options:{no_zeros:true}
  })

  # Les effets
  # ----------
  de = @durees_effets
  ret << table({
    columns:[
      {width:20, title:'Effet'},
      {width:30, title:'Durée',         type: :time},
      {width:30, title:'Nombre scènes', type: :scenes}
    ],
    values:[
      ["De jour",   de[:j][0], de[:j][1]],
      ["De nuit",   de[:n][0], de[:n][1]],
      ["Du matin",  de[:m][0], de[:m][1]],
      ["Du soir",   de[:s][0], de[:s][1]],
      ["Autre (p.e. Noir)", de[:x][0], de[:x][1]]
    ],
    options:{no_zeros:true}
  })

  # Le décor le plus utilisé (en nombre de fois et en durée)
  bestDTime   = @sorted_by_duree.first
  badDduree   = @sorted_by_duree.last
  bestDCount  = @sorted_by_count.first
  badDCount   = @sorted_by_count.last

  ret << table({
    columns:[
      {width:40, title: 'Objet'},
      {width:45, title: 'Lieu'},
      {width:15, title: 'Valeur'}
    ],
    values: [
      ["Le plus utilisé en temps", bestDTime.ref, bestDTime.use_duree, {2 => :time}],
      ["Le plus utilisé en nombre de scène", bestDCount.ref, bestDCount.use_count, {2 => :scenes}],
      ["Le moins utilisé en temps",badDduree.ref, badDduree.use_duree, {2 => :time}],
      ["Le moins utilisé en nombre de scène", badDCount.ref, badDCount.use_count, {2 => :scenes}]
    ]
  })

  # L'utilisation des décors par temps d'utilisation
  ret << '<h3>Décors par durée d’utilisation</h3>'
  ret << table({
    columns:[
      {width:40, title: "Décor"},
      {width:20, title: "Durée", type: :time}
    ],
    values:@sorted_by_duree.collect do |decor|
      [decor.hname, decor.use_duree]
    end
  })

  # L'utilisation des décors par nombre de scènes
  ret << '<h3>Décors par nombre de scènes</h3>'
  ret << table({
    columns:[
      {width:70, title: "Décor"},
      {width:20, title: "Nombre de scènes", type: :scenes}
    ],
    values: @sorted_by_count.collect do |decor|
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
  @sorted_by_duree = @liste.sort_by(&:use_duree).reverse
  @sorted_by_count = @liste.sort_by(&:use_count).reverse
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


end #/Decor
