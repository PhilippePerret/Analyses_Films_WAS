# encoding: UTF-8
# frozen_string_literal: true
=begin
  Extension de Film pour la construction de la couverture

  Pour trouver les polices qui vont bien ensemble
    https://icons8.com/fonts/roboto/arial

  Données par rapport à la couverture

  KINDLE (AMAZONE)
    SOURCE        https://kdp.amazon.com/fr_FR/help/topic/G200645690
    FORMAT        Tiff ou Jpeg
    DIMENSIONS
        hauteur   2560px
        Hauteur minimale : 2500px
        largeur   1600px
    COMPRESSION     minimale

    RAPPORT H/L   1,6:1
        Exemple   1600px de haut pour 1000px de large

    PPI           300 (incohérence page amazon : 72)
    TAILLE        < 50Mo
    PROFIL COULEUR  RVB
                    Sans séparation de couleurs
=end
class Film

def build_cover
  ensure_required_folders
  FCover.new(self).build
end

end #/ class Film

class FCover
attr_reader :film
def initialize(film)
  @film = film
end
def build
  # Possède-t-on suffisamment d'informations pour procéder à l'opération ?
  data_valid? || raise("Données invalides : #{@invalidity}")

  File.delete(cover_path) if File.exists?(cover_path)

  code = File.read(template_path).force_encoding('utf-8')
  File.open(cover_path,'wb') do |f|
    f.write(code % fconfig.get(AUTO_DOCUMENTS['cover.html'][:required_data]))
  end

  # Copier if needed l'image de couverture dans le dossier 'products'
  if not File.exists?(cover_img_path_in_products)
    FileUtils.copy(cover_img_original_path, cover_img_path_in_products)
  end
  if not File.exists?(cover_img_path_in_livres)
    FileUtils.copy(cover_img_original_path, cover_img_path_in_livres)
  end

  # Copier if needed l'image du logo de l'édition dans le dossier 'products'
  if not File.exists?(logo_editor_products_path)
    FileUtils.copy(logo_editor_original_path,logo_editor_products_path)
  end
  if not File.exists?(logo_editor_livres_path)
    FileUtils.copy(logo_editor_original_path,logo_editor_livres_path)
  end

  if not film.document?('cover.html')
    Ajax << {message: "Il faut ajouter 'cover.html' à la liste des documents, dans config.yml, pour que la couverture soit utilisée pour les livres."}
  end
end #/ FCover#build

def data_valid?
  required_data = AUTO_DOCUMENTS['cover.html'][:required_data]
  lakes = []
  required_data.each do |kdata|
    fconfig.send(kdata.to_sym) || lakes << kdata
  end
  @invalidity = lakes.join(', ')
  return lakes.empty?
end #/ data_valid?

def cover_path
  @cover_path ||= File.join(film.folder_products,'cover.html')
end

def cover_img_path_in_products
  @cover_img_path_in_products ||= File.join(film.folder_products,fconfig.cover_img_path)
end
def cover_img_path_in_livres
  @cover_img_path_in_livres ||= File.join(film.folder_livres,fconfig.cover_img_path)
end
def cover_img_original_path
  @cover_img_original_path ||= File.join(film.folder,dcover['path'])
end
def cover_img_name
  @cover_img_name ||= File.basename(book_infos['cover']['path'])
end

def logo_editor_original_path
  @logo_editor_original_path ||= File.join(film.folder, fconfig.publisher_logo)
end
def logo_editor_products_path
  @logo_editor_products_path ||= File.join(film.folder_products, fconfig.publisher_logo)
end
def logo_editor_livres_path
  @logo_editor_livres_path ||= File.join(film.folder_livres, fconfig.publisher_logo)
end

private

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','cover.html')
  end

  def fconfig ; @fconfig ||= FConfig.new(film) end

end #/Film
