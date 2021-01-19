# encoding: UTF-8
# frozen_string_literal: true

doc_name = Ajax.param(:name)
doc_name = "#{doc_name}.md" if File.extname(doc_name).empty?
doc_path = File.join(Film.current.folder_documents, doc_name)

if File.exists?(doc_path)
  `open -a Typora "#{doc_path}"`
else
  Ajax << {error: "Le document “#{doc_path}” est introuvable…"}
end
