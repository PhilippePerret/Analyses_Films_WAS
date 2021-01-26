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
    if AUTO_DOCUMENTS.key?(doc_name)
      affixe = File.basename(doc_name,File.extname(doc_name))
      require_relative "build_#{affixe}"
      documents_built << AUTO_DOCUMENTS[doc_name][:hname]
    else
      adoc = ADocument.new(doc_name)
      adoc.valid? || raise("Le document #{doc_name.inspect} est invalide pour la raison suivante : #{adoc.invalidity}")
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
