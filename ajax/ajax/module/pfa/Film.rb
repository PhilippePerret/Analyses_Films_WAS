# encoding: UTF-8
# frozen_string_literal: true
class Film
def build_pfa
  duration || raise("La durée du film doit absolument être défini.")
  # On récupère les évènements de type nœud-clé (nc)
  @pfa = PFA.new(self)
  noeudsRel = {}
  get_events.each do |devent|
    next unless devent['type'].start_with?('nc:')
    ty, ntype = devent['type'].split(':')
    noeudsRel.merge!(ntype.to_sym => PFANoeud.new(@pfa, devent))
  end
  @pfa.noeudsRel = noeudsRel
  @pfa.prepare_noeuds_abs
  @pfa.enabled? || raise("Les informations sont insuffisantes pour établir le PFA : #{@pfa.errors.join(', ')}.")


  # === CONSTRUCTION ===
  @pfa.build

  # Message de retour
  msg =
  if File.exists?(@pfa.path)
    msg = "Le PFA a été construit avec succès."
    @pfa.complet? || msg = "#{msg} Mais il n'est pas complet à cause de l'absence d'informations sur : #{@pfa.lakes.join(', ')}"
    msg
  else
    "Bizarrement, tout semble s'être bien passé mais l'image n'a pas été produite…"
  end

  Ajax << {message: msg}
end #/ build_pfa

end #/Film
