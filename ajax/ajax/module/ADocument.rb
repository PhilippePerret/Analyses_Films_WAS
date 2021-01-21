# encoding: UTF-8
# frozen_string_literal: true
=begin
  Pour les documents d'analyse (personnalisés principalement)
=end
class ADocument
class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :name
def initialize(name)
  @name = name
end #/ initialize
def build_html_file
  require_module('on_formatage')
  File.delete(html_path) if File.exists?(html_path)
  File.open(html_path,'wb'){|f| f.write( kramdown(md_path) )}
end #/ build_html_file
def html_path
  @html_path ||= File.join(film.folder_products,"#{affixe}.html")
end #/ html_path
def md_path
  @md_path ||= File.join(film.folder_documents, name)
end #/ md_path@
def affixe
  @affixe ||= File.basename(name, File.extname(name))
end #/ affixe
def film
  @film ||= Film.current
end #/ film
end #/ADocument
