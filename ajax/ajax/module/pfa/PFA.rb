# encoding: UTF-8
# frozen_string_literal: true
class PFA

  PFA_WIDTH   = 4000 # 4000px (en 300dpi)
  PFA_HEIGHT  = PFA_WIDTH / 5
  PFA_LEFT_MARGIN   = 100
  PFA_RIGHT_MARGIN  = 100
  LINE_HEIGHT = PFA_HEIGHT / 15
  log("LINE_HEIGHT = #{LINE_HEIGHT}")

class << self

# Position verticale (y) des horloges du paradigme absolu
def top_horloge_part_absolue
  @top_horloge_part_absolue ||= 6*LINE_HEIGHT
end

def top_horloge_part_relative
  @top_horloge_part_relative ||= top_horloge_part_absolue + LINE_HEIGHT
end #/ top_horloge_part_relative

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :film
attr_accessor :noeuds
attr_reader :errors, :lakes
def initialize(film)
  @film = film
end #/ initialize

# Construction du PFA
# -------------------
# Cette construction doit produire une image de 4000 pixels de large
# sur ? de haut
def build
  File.delete(path) if File.exists?(path)

  cmd = ["/usr/local/bin/convert -size #{PFA_WIDTH}x#{PFA_HEIGHT}"]
  cmd << "xc:white"
  cmd << "-units PixelsPerInch -density 300"
  cmd << "-background white -stroke black -fill white"
  # cmd << '-draw "text 100,100 \'Montexte\'"'

# -draw "rectangle 10,10 400,400"
#  -draw "text 1000,100 'EXPOSITION'"
  # cmd << "-draw 'rectangle 10,400 400,800'"
# -draw "text 2000,100 'DÉVELOPPEMENT'"
# -gravity center -draw "text 2000,100 'DÉVELOPPEMENT'"

=begin
convert sea.jpg \( -size 173x50 -background none label:"A" -trim -gravity center -extent 173x50 \) -gravity northwest -geometry +312+66 -composite result.png
=end

  # Pour la font à utiliser
  # cmd << '-font "Arial" -pointsize 10'
  cmd << "-strokewidth 3"
  # cmd << "-pointsize 10"

  # On dessine d'abord le fond, avec les actes
  DATA_PFA.each do |kpart, dpart|
    ne = NoeudAbs.new(dpart)
    cmd << ne.draw_command
  end
  # Et on dessine ensuite le contenu
  DATA_PFA.each do |kpart, dpart|
    dpart[:inner].each do |kin, din|
      ne = NoeudAbs.new(din.merge!(pfa: self, film: film))
      cmd << ne.draw_command
    end
  end

  cmd << horloges_parties

  # cmd << "-colorspace sRGB"
  cmd << "-set colorspace sRGB"
  cmd << path.gsub(/ /, "\\ ")

  cmd = cmd.join(' ')
  log("CMD IMAGE: #{cmd.inspect}")
  res = `#{cmd} 2>&1`
  log("retour de commande: #{res.inspect}")
  # Pour l'ouvrir tout de suite
  begin
    sleep 0.3
  end until File.exists?(path)
  `open -a Aperçu "#{path}"`
end #/build

def realpos(val)
  (PFA_LEFT_MARGIN + realpx(val)).to_i
end
def realpx(val)
  (val * coef_pixels).to_i
end
alias :realwidth :realpx

# Renvoie le temps qui correspond à la "valeur 120" donnée
def realtime(val)
  (val * coef_time).to_i
end

# La fin est 120
# => coef_time * 120 = PFA-WIDTH
# => coef_time = PFA-WIDTH / 120
def coef_pixels
  @coef_pixels ||= (PFA_WIDTH - PFA_LEFT_MARGIN - PFA_RIGHT_MARGIN).to_f / 120
end

# La fin est 120
# La durée réelle est real_duree
# Donc : coef_time * 120 = real_duree
# => coef_time = real_duree / 120
def coef_time
  @coef_time ||= real_duree.to_f / 120
end

# Code pour les horloges des parties
def horloges_parties
  cmd = []
  cmd << %{Q-pointsize 6.5 -strokewidth 2 stroke gray50}
  # Pour le paradigme absolu
  decs = [0,30,60,90,120] # on en aura besoin ci-dessous
  decs.each do |dec|
    h = Horloge.new(horloge:realtime(dec).to_horloge, top:self.class.top_horloge_part_absolue, left:realpos(dec), bgcolor:'gray50', color:'gray90')
    cmd << h.magick_code
  end
  
  # Pour le paradigme propre au film
  [ne(:ex), ne(:dv), ne(:d2)||ne(:cv), ne(:dn), ne(:pf)].each_with_index do |noeud, idx|
    next if noeud.nil?
    h = Horloge.new(horloge:noeud.time.to_i.to_horloge, top:self.class.top_horloge_part_relative, left:realpos(decs[idx]), bgcolor:'gray20', color:'white')
    cmd << h.magick_code
  end

  return cmd.join(' ')
end #/ horloges_parties


# La durée "réelle", c'est-à-dire entre le point zéro et
# le point final
def real_duree
  @real_duree ||= ne(:pf).time - ne(:zr).time
end #/ real_duree

# Retourne TRUE si on peut faire le paradigme complet
# Note : la méthode doit être appelée après enabled?
def complet?
  errors.empty? && lakes.empty?
end #/ complets?

# Méthode qui retourne true si on peut construire le PFA
def enabled?
  errs = []
  noeud(:zr) || errs << "manque le “point zéro”"
  noeud(:pf) || errs << "manque le “point final”"
  noeud(:ex) || errs << "manque le début de l'exposition"
  if ne(:dv) && ne(:ex)
    bon_ordre?(:ex, :dv) || errs << "le développement commence avant l'exposition…"
  else
    errs << "manque le début du développement"
  end
  if ne(:d2)
    !ne(:dv) || bon_ordre?(:dv, :d2) || errs << "la seconde partie de développement devrait se trouver APRÈS la première…"
    !ne(:ex) || bon_ordre?(:ex, :d2) || errs << "l'exposition devrait se trouver AVANT la seconde part de développement"
  else
    errs << "manque le début de la seconde partie de développement"
  end
  if noeud(:dn)
    !ne(:dv) || bon_ordre?(:dv, :dn) || errs << "le dénouement commence avant le développement"
    !ne(:d2) || bon_ordre?(:d2, :dn) || errs << "le dénouement commence avant la part II de développement"
    !ne(:ex) || bon_ordre?(:ex, :dn) || errs << "le dénouement commence avant l'exposition"
  else
    errs << "manque le début du dénouement"
  end
  if ne(:p1)
    !ne(:dv) || bon_ordre?(:p1, :dv) || errs << "le pivot 1 doit se trouver AVANT le développement"
    !ne(:dn) || bon_ordre?(:p1, :dn) || errs << "le pivot 1 doit se trouver AVANT le dénouement"
  else
    errs << "manque le pivot 1"
  end


  if ne(:p2)
    !ne(:dn) || bon_ordre?(:p2, :dn) || errs << "le pivot 2 devrait se trouver AVANT le dénouement"
    !ne(:ex) || bon_ordre?(:ex, :p2) || errs << "le pivot 2 devrait se trouver APRÈS l'exposition"
    !ne(:dv) || bon_ordre?(:dv, :p2) || errs << "le pivot 2 doit se trouver APRÈS le début du développement"
  else
    errs << "manque le pivot 2"
  end

  if ne(:id)
    !ne(:dv) || bon_ordre?(:id, :dv) || errs << "l'incident déclencheur doit se trouver AVANT le développement"
    !ne(:ip) || bon_ordre?(:ip, :id) || errs << "l'incident déclencheur doit se trouver APRÈS l'incident perturbateur"
  else
    errs << "manque l'incident déclencheur"
  end

  if ne(:cx)
    !ne(:dn) || bon_ordre?(:dn, :cx) || errs << "le climax devrait se trouver DANS le dénouement"
  else
    errs << "manque le climax"
  end

  # S'il n'y a pas d'erreurs jusque-là, on peut déjà établir un PFA succinct
  # On vérifie s'il sera complet (self.complet?)
  laks = []
  if errs.empty?
    [:ip, :cv, :cr].each do |k|
      na = noeudAbs(k) # un Hash, ici
      ne(k) || laks << "#{na[:hname]}"
    end
  end

  @errors = errs
  @lakes  = laks # les manques pour qu'il soit complet
  return errors.empty?
end #/ enabled?

def noeud(key)
  noeuds[key]
end #/ noeud
alias :ne :noeud

# Données absolu du noeud
def noeudAbs(key)
  DATA_NOEUDS[key]
end #/ noeudAbs

# Chemin d'accès au fichier image du paradigme
def path
  @path ||= File.join(film.folder,'pfa.jpg')
end


private

# Renvoie true si le noeud de clé +kav+ se situe bien avant le noeud de
# clé +kap+
def bon_ordre?(kav, kap)
  noeud(kav).time < noeud(kap).time
end #/ bon_ordre?

end #/PFA
