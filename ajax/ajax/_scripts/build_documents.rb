# encoding: UTF-8
# frozen_string_literal: true


doc_name = Ajax.param(:doc_name)
film = Film.current
require_module('ADocument')

if doc_name.nil?
  documents_built = []
  # Construction de tous les documents
  # ----------------------------------
  # Les documents .md sont construit "normalement" par leur méthode
  # build_html_file
  # Les documents .html sont soit des documents automatiques, soit
  # des documents déjà formatés
  (film.config['documents']||[]).each do |doc_name|
    case doc_name
    when 'pfa.html'
      require_relative 'build_pfa'
      documents_built << 'PFA'
    when 'synopsis.html'
      require_relative 'build_synopsis'
      documents_built << 'Synopsis'
    when 'sequencier.html'
      require_relative 'build_sequencier'
      documents_built << "Séquencier"
    when 'traitement.html'
      require_relative 'build_traitement'
      documents_built << 'Traitement'
    when 'statistiques.html'
      require_relative 'built_statistiques'
      documents_built << 'Statistiques'
    else
      adoc = ADocument.new(doc_name)
      if File.exists?(adoc.md_path)
        adoc.build_html_file
        documents_built << doc_name
      end
    end
  end
  Ajax << {message: "Documents construits : #{documents_built.join(', ')}"}
else
  # Construction d'un seul document
  doc_name = "#{doc_name}.md" if File.extname(doc_name) == ''
  adoc = ADocument.new(doc_name)
  if File.exists_with_case?(adoc.md_path)
    adoc.build_html_file
    if not film.config['documents'].include?(doc_name)
      Ajax << {message: "Il faut ajouter le document « #{doc_name} » à config.yml (propriété 'documents') pour qu'il soit mis dans les livres."}
    end
  else
    ajout = ""
    if File.exists?(adoc.md_path)
      ajout = " (mais j'ai trouvé un autre document avec le même nom mais une autre casse)"
    end
    Ajax << {error: "Le document « #{doc_name} » est introuvable#{ajout}… (cherché dans #{adoc.md_path.inspect})"}
  end
end
