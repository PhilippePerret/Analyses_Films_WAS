# encoding: UTF-8
# frozen_string_literal: true
class Film
def build_pfa
  duration || raise("La durée du film doit absolument être défini.")
  # On récupère les évènements de type nœud-clé (nc)
  @pfa = PFA.new(self)
  noeuds = {}
  get_events.each do |devent|
    next unless devent['type'].start_with?('nc:')
    ty, ntype = devent['type'].split(':')
    noeuds.merge!(ntype.to_sym => PFANoeud.new(@pfa, devent))
  end
  @pfa.noeuds = noeuds
  @pfa.enabled? || raise("Les informations sont insuffisantes pour établir le PFA : #{@pfa.errors.join(', ')}.")

  # Message de retour
  msg = "Le PFA a été construit avec succès."
  @pfa.complet? || msg = "#{msg} Mais il n'est pas complet à cause de l'absence d'informations sur : #{@pfa.lakes.join(', ')}"

  Ajax << {message: msg}
rescue Exception => e
  Ajax << {error: e.message}
end #/ build_pfa

end #/Film
