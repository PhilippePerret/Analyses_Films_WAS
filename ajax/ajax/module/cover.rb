# encoding: UTF-8
# frozen_string_literal: true
=begin
  Extension de Film pour la construction de la couverture

  Pour trouver les polices qui vont bien ensemble
    https://icons8.com/fonts/roboto/arial

  Pour faire des tests SVG :
    http://www.drawsvg.org/drawsvg.html
    https://developer.mozilla.org/fr/docs/Web/SVG/Element/image

  Données par rapport à la couverture

  KINDLE (AMAZONE)
    SOURCE        https://kdp.amazon.com/fr_FR/help/topic/G200645690
    FORMAT        Tiff ou Jpeg
    DIMENSIONS
        hauteur   2560px
        Hauteur minimale : 2500px
        largeur   1600px
    COMPRESSION     minimale

    RAPPORT H/L   1,6:1
        Exemple   1600px de haut pour 1000px de large

    PPI           300 (incohérence page amazon : 72)
    TAILLE        < 50Mo
    PROFIL COULEUR  RVB
                    Sans séparation de couleurs
=end
class Film

def build_cover
  raise "L'image ne se produit plus informatiquement. Cf. le manuel d'utilisation."
end

end #/Class Film
