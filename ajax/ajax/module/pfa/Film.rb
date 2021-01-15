# encoding: UTF-8
# frozen_string_literal: true
class Film
def build_pfa
  duration || raise("La durée du film doit absolument être défini.")
  # On récupère les évènements de type nœud-clé (nc)
  noeuds = {}
  get_events.each do |devent|

  end
  Ajax << {message: "Le PFA a été construit avec succès."}
rescue Exception => e
  Ajax << {error: e.message}
end #/ build_pfa

end #/Film
