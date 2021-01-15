# encoding: UTF-8
# frozen_string_literal: true
class PFA
class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_accessor :noeuds
attr_reader :errors, :lakes
def initialize(film)
  @film = film
end #/ initialize

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
  if noeud(:dn)
    !ne(:dv) || bon_ordre?(:dv, :dn) || errs << "le dénouement commence avant le développement"
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


private

# Renvoie true si le noeud de clé +kav+ se situe bien avant le noeud de
# clé +kap+
def bon_ordre?(kav, kap)
  noeud(kav).time < noeud(kap).time
end #/ bon_ordre?

end #/PFA
