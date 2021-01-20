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
    ret << tr("Lieux", "Durée", "Nombre scènes", false)
    ret << tr("Scènes en extérieur", @durees_lieux[:e][0], @durees_lieux[:e][1])
    ret << tr("Scènes en intérieur", @durees_lieux[:i][0], @durees_lieux[:i][1])
    if ( @durees_lieux[:ie][1] > 0)
      ret << tr("Scènes en ext. et int.", @durees_lieux[:ie][0], @durees_lieux[:ie][1])
    end
    if ( @durees_lieux[:x][1] > 0)
      ret << tr("Scènes dans autres lieux", @durees_lieux[:x][0], @durees_lieux[:x][1])
    end
    ret << '</table>'

    # Les effets
    # ----------
    de = @durees_effets
    ret << '<table>'
    ret << tr("Effet", "Durée", "Nombre scènes", false)
    ret << tr("De jour", de[:j][0], de[:j][1])
    ret << tr("De nuit", de[:n][0], de[:n][1])
    if ( de[:m][1] > 0)
      ret << tr("Du matin", de[:m][0], de[:m][1])
    end
    if ( de[:s][1] > 0)
      ret << tr("Du soir", de[:s][0], de[:s][1])
    end
    if ( de[:x][1] > 0)
      ret << tr("Autre (p.e. Noir)", de[:x][0], de[:x][1])
    end
    ret << '</table>'

    # Le décor le plus utilisé (en nombre de fois et en durée)
    bestDTime   = @sorted_by_duree.first
    badDduree   = @sorted_by_duree.last
    bestDCount  = @sorted_by_count.first
    badDCount   = @sorted_by_count.last

    ret << table({
      columns:[
        {width:40, title: 'Palmarès'},
        {width:45, title: 'Lieu'},
        {width:15, title: 'Valeur'}
      ],
      values: [
        ["Le plus utilisé en temps", bestDTime.ref, bestDTime.use_duree.to_i.to_horloge+pct(:time, bestDTime.use_duree)],
        ["Le plus utilisé en nombre de scène", bestDCount.ref, bestDCount.use_count.to_s+pct(:scenes, bestDCount.use_count)],
        ["Le moins utilisé en temps",badDduree.ref, badDduree.use_duree.to_i.to_horloge+pct(:time, badDduree.use_duree)],
        ["Le moins utilisé en nombre de scène", badDCount.ref, badDCount.use_count.to_s+pct(:scenes, badDCount.use_count)]
      ]
    })

    # L'utilisation des décors par temps d'utilisation
    ret << '<h3>Décors par durée d’utilisation</h3>'
    values = @sorted_by_duree.collect do |decor|
      [decor.hname, decor.use_duree.to_i.to_horloge+pct(:time, decor.use_duree)]
    end
    ret << table({
      columns:[
        {width:60, title: "Décor"},
        {width:40, title: "Durée"}
      ],
      values:values
    })

    # L'utilisation des décors par nombre de scènes
    ret << '<h3>Décors par nombre de scènes</h3>'
    values = @sorted_by_count.collect do |decor|
      [decor.hname, decor.use_count.to_s+pct(:time, decor.use_count)]
    end
    ret << table({
      columns:[
        {width:70, title: "Décor"},
        {width:20, title: "Nombre de scènes"}
      ],
      values:values
    })

    return ret.join("\n")
  end #/ build_stats_decors

  def tr(label, duree, fois, calculer = true)
    if calculer
      "<tr><td>#{label}</td><td>#{duree.to_i.to_horloge} #{pct(:time, duree)}</td><td>#{fois} #{pct(:scene, fois)}</td></tr>"
    else
      "<tr><td>#{label}</td><td>#{duree}</td><td>#{fois}</td></tr>"
    end
  end #/ tr

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
attr_accessor :use_duree, :use_count
# Retourne la ligne de statistique du décor
def line_stats

end #/ line_stats
end #/Decor
