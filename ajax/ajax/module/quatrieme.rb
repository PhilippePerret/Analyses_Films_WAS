# encoding: UTF-8
# frozen_string_literal: true
class Film
  def build_quatrieme_couverture
    ensure_required_folders
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
  data_valid? || raise("Données manquantes : #{@invalidity}")
  File.delete(cover4_path) if File.exists?(cover4_path)
  File.open(cover4_path,'wb') do |f|
    f.write(File.read(template_path).force_encoding('utf-8') % fconfig.get(required_data))
  end

  # On doit copier les deux images
  src = img_resume_path
  FileUtils.copy(src, img_resume_in_products)
  FileUtils.copy(src, img_resume_in_livres)

  src = File.join(film.folder,photo_auteur)
  FileUtils.copy(src, photo_auteur_in_products)
  FileUtils.copy(src, photo_auteur_in_livres)

  # Et enfin, si le document 'quatrieme.html' n'est pas dans la liste
  # des documents du livre, on le signale
  if not film.document?('quatrieme.html')
    Ajax << {message: "Le document 'quatrieme.html' doit être ajouté à la liste des documents dans config.yml pour être construit avec les livres."}
  end

end #/ build_page_composition

def data_valid?
  lakes = []
  required_data.each do |kdata|
    fconfig.send(kdata.to_sym) || lakes << kdata
  end
  File.exists?(img_resume_path) || lakes << "L'image #{img_resume} est introuvable…"
  File.exists?(photo_auteur_path) || lakes << "L’image #{photo_auteur} est introuvable…"

  @invalidity = lakes.join(', ')
  return lakes.empty?
end #/ data_valid?

private

  def required_data
    @required_data ||= AUTO_DOCUMENTS['quatrieme.html'][:required_data]
  end

  def img_resume_in_products
    @img_resume_in_products ||= File.join(film.folder_products, img_resume)
  end
  def img_resume_in_livres
    @img_resume_in_livres ||= File.join(film.folder_livres, img_resume)
  end
  def img_resume_path
    @img_resume_path ||= File.join(film.folder,img_resume)
  end
  def img_resume
    @img_resume ||= File.join('img',fconfig.send(:cover4_img_path))
  end

  def photo_auteur_in_products
    @photo_auteur_in_products ||= File.join(film.folder_products, photo_auteur)
  end
  def photo_auteur_in_livres
    @photo_auteur_in_livres ||= File.join(film.folder_livres, photo_auteur)
  end
  def photo_auteur_path
    @photo_auteur_path ||= File.join(film.folder,photo_auteur)
  end
  def photo_auteur
    @photo_auteur ||= File.join('img',fconfig.send(:author_photo))
  end

  def fconfig ; @fconfig ||= FConfig.new(film) end

  def cover4_path
    @cover4_path ||= File.join(film.folder_products,'quatrieme.html')
  end #/ cover4_path

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','quatrieme.html')
  end


end #/Film
