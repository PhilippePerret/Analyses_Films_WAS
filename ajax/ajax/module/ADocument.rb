# encoding: UTF-8
# frozen_string_literal: true
=begin
  Pour les documents d'analyse (personnalisés principalement)
=end
require_relative 'data'

class ADocument
class << self

end # /<< self
# ---------------------------------------------------------------------
#
#   INSTANCE
#
# ---------------------------------------------------------------------
attr_reader :name, :invalidity

def initialize(name)
  @name = name
end #/ initialize
def build_html_file
  require_module('on_formatage')
  File.delete(html_path) if File.exists?(html_path)
  File.open(html_path,'wb'){|f| f.write( kramdown(md_path) )}
end #/ build_html_file

# Retourne TRUE si le document est valide.
# Pour le moment, un document est valide si :
#   - il ne porte pas le nom (affixe) d'un document réservé,
#
# Quand le document n'est pas valide, on en met la raison dans la propriété
# publique @invalidity
def valid?
  if AUTO_DOCUMENTS.key?("#{affixe}.html")
    raise "il porte un nom réservé à un document automatique (#{affixe}.html)"
  end
  return true
rescue Exception => e
  log(e)
  @invalidity = e.message
  return false
end #/ valid?


# ---------------------------------------------------------------------
#
#   PATHS
#
# ---------------------------------------------------------------------

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
