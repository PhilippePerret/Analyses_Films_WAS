# encoding: UTF-8
# frozen_string_literal: true
class Film
  def build_frontispice
    ensure_required_folders
    Frontispice.new(self).build
  end
end

class Frontispice
attr_reader :film
def initialize(film)
  @film = film
end
def build
  # Avant toute chose, il faut s'assurer que les données requises soient
  # définies
  data_valid? || raise("Données invalides : #{@invalidity}")
  File.delete(frontispice_path) if File.exists?(frontispice_path)
  code = File.read(template_path).force_encoding('utf-8')
  log("code du frontispice :\n#{code.inspect}")
  File.open(frontispice_path,'wb') do |f|
    f.write(code % fconfig.get(required_data))
  end

  # Et enfin, si le document 'frontispice.html' n'est pas dans la liste
  # des documents du livre, on le signale
  if not film.document?('frontispice.html')
      Ajax << {message: "Le document 'frontispice.html' doit être ajouté à la liste des documents dans config.yml pour être construit avec les livres."}
  end

end #/ build_page_composition

def required_data
  @required_data ||= AUTO_DOCUMENTS['frontispice.html'][:required_data]
end

def data_valid?
  lakes = []
  required_data.each do |kdata|
    fconfig.send(kdata.to_sym) || lakes << kdata
  end
  @invalidity = lakes.join(', ')
  return lakes.empty?
end #/ data_valid?

def frontispice_path
  @frontispice_path ||= File.join(film.folder_products,'frontispice.html')
end

private

  def fconfig ; @fconfig ||= FConfig.new(film) end

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','frontispice.html')
  end


end #/Film
