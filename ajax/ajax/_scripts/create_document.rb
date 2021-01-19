# encoding: UTF-8
# frozen_string_literal: true
=begin
  Module pour créer un document
=end

doc_name = Ajax.param(:name)
doc_name = "#{doc_name}.md" if File.extname(doc_name).empty?
doc_path = File.join(Film.current.folder_documents, doc_name)
titre_prov = File.basename(doc_name, File.extname(doc_name))

if File.exists?(doc_path)
  Ajax << {error: "Le fichier “#{doc_name}” existe déjà. Jouer 'open doc #{doc_name}' pour l'ouvrir."}
else
  File.open(doc_path,'wb'){|f| f.write("# #{titre_prov}\n\nPremier paragraphe du document #{titre_prov}.")}
  # On l'ajoute au fichier config.yml
  Film.current.add_document_to_config(doc_name)
end
