# encoding: UTF-8
# frozen_string_literal: true
class Film
  def build_pfa
    ensure_required_folders
    PFA.new(self).build
  end
end

class PFA
attr_reader :film
def initialize(film)
  @film = film
end
def build

  # Pour le message final
  msg = []

  # Avant toute chose, il faut s'assurer que les données requises soient
  # définies
  File.delete(pfa_path) if File.exists?(pfa_path)

  stream = File.open(pfa_path,'a')

  stream << File.read(template_path).force_encoding('utf-8')

  if File.exists?(commentaires_pfa_path)
    stream << '<div class="commmentaires_pfa">'
    stream << htitle('Commentaires sur le PFA du film',3)
    stream << kramdown(commentaires_pfa_path)
    stream << '</div>'
  else
    msg << "<div>Tu peux ajouter des commentaires au PFA en rédigeant le document <code>./documents/commentaires_pfa.md</code>.</div>"
  end


  # Et enfin, si le document 'pfa.html' n'est pas dans la liste
  # des documents du livre, on le signale
  if not film.document?('pfa.html')
    msg << "<div>Le document 'pfa.html' doit être ajouté à la liste des documents dans config.yml pour être construit avec les livres.</div>"
  end

  unless msg.empty?
    Ajax << {message: msg.join('')}
  end

ensure

  stream.close if stream

end #/ build_page_composition

def pfa_path
  @pfa_path ||= File.join(film.folder_products,'pfa.html')
end

def commentaires_pfa_path
  @commentaires_pfa_path ||= File.join(film.folder_documents,'commentaires_pfa.md')
end

private

  def fconfig ; @fconfig ||= FConfig.new(film) end

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','pfa.html')
  end


end #/Film
