# encoding: UTF-8
# frozen_string_literal: true


doc_name = Ajax.param(:doc_name)
film = Film.current
require_module('ADocument')

if doc_name.nil?
  # Construction de tous les documents
  (film.config['documents']||[]).each do |doc_name|
    adoc = ADocument.new(doc_name)
    File.exists?(adoc.md_path) && adoc.build_html_file
  end
else
  # Construction d'un seul document
  doc_name = "#{doc_name}.md" if File.extname(doc_name) == ''
  adoc = ADocument.new(doc_name)
  if File.exists?(adoc.md_path)
    adoc.build_html_file
    if not film.config['documents'].include?(doc_name)
      Ajax << {message: "Il faut ajouter le document « #{doc_name} » à config.yml (propriété 'documents') pour qu'il soit mis dans les livres."}
    end
  else
    Ajax << {error: "Le document « #{doc_name} » est introuvable… (cherché dans #{adoc.md_path.inspect})"}
  end
end
