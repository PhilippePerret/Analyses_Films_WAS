# encoding: UTF-8
# frozen_string_literal: true
class Film
  def build_quatrieme_couverture
    Quatrieme.new(self).build
  end
end #/class Film

class Quatrieme
attr_reader :film
def initialize(film)
  @film = film
end
def build
  # Avant toute chose, il faut s'assurer que les données requises soient
  # définies
  data_valid? || raise("Données invalides : #{@invalidity}")
  File.delete(cover4_path) if File.exists?(cover4_path)
  code = File.read(template_path).force_encoding('utf-8')
  File.open(cover4_path,'wb') do |f|
    code % fconfig.get(['resume','author_cv','isbn','prix','cover4_img_path'])
  end

  # On doit copier l'image
  img_path = File.join(film.folder, cover4_img_path)
  if not File.exists?(cover4_img_path_in_products)
    mkdir(File.dirname(cover4_img_path_in_products))
    FileUtils.copy(img_path, cover4_img_path_in_products)
  end
  if not File.exists?(cover4_img_path_in_livres)
    mkdir(File.dirname(cover4_img_path_in_livres))
    FileUtils.copy(img_path, cover4_img_path_in_livres)
  end

  # Et enfin, si le document 'quatrieme.html' n'est pas dans la liste
  # des documents du livre, on le signale
  if not film.config['documents'].include?('quatrieme.html')
    Ajax << {message: "Le document 'quatrieme.html' doit être ajouté à la liste des documents dans config.yml pour être construit avec les livres."}
  end

end #/ build_page_composition

def data_valid?
  required_data = AUTO_DOCUMENTS['quatrieme.html'][:required_data]
  lakes = []
  required_data.each do |kdata|
    fconfig.send(kdata.to_sym) || lakes << kdata
  end
  @invalidity = lakes.join(', ')
  return lakes.empty?
end #/ data_valid?

def cover4_img_path_in_products
  @cover4_img_path_in_products ||= File.join(film.folder_products, cover4_img_path)
end
def cover4_img_path_in_livres
  @cover4_img_path_in_livres ||= File.join(film.folder_livres, cover4_img_path)
end
def cover4_img_path
  @cover4_img_path ||= fconfig.send(:cover4_img_path)
end

def cover4_path
  @cover4_path ||= File.join(film.folder_products,'quatrieme.html')
end #/ cover4_path

private

  def fconfig ; @fconfig ||= FConfig.new(film) end

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','quatrieme.html')
  end


end #/Film
