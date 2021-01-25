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
  # Possède-t-on suffisamment d'informations pour procéder à l'opération ?
  informations_valides? || return

  File.delete(cover_path) if File.exists?(cover_path)

  code = File.read(template_path).force_encoding('utf-8')
  File.open(cover_path,'wb') do |f|
    f.write(code % {
      editor_top:editor,
      cover_filename:cover_img_name,
      img_left: dcover['left'],
      img_width: dcover['width']||'auto',
      img_height: dcover['height']||'auto',
      book_title:title,
      book_author: author, editor_bottom:editor})
  end

  # Copier if needed l'image de couverture dans le dossier 'products'
  FileUtils.copy(cover_img_original_path, cover_img_path) unless File.exists?(cover_img_path)

  # Copier if needed l'image du logo de l'édition dans le dossier 'products'
  FileUtils.copy(logo_editor_original_path,logo_editor_products_path) unless File.exists?(logo_editor_products_path)

  if not documents.include?('cover.html')
    Ajax << {message: "Il faut ajouter 'cover.html' à la liste des documents, dans config.yml, pour que la couverture soit utilisée pour les livres."}
  end
end #/ build_cover

def author
  @author ||= book_infos['author']
end

def editor
  @editor ||= %Q{<span class="logo-editor"><img src="#{File.basename(book_infos['publisher']['logo'])}" alt="Logo éditeur"></span>#{book_infos['publisher']['name']}}
end

def book_infos
  @book_infos ||= config['book_infos']
end
def dcover
  @dcover ||= book_infos['cover']
end

def cover_path
  @cover_path ||= File.join(film.folder_products,'cover.html')
end


def cover_img_path
  @cover_img_path ||= File.join(film.folder_products,cover_img_name)
end
def cover_img_original_path
  @cover_img_original_path ||= File.join(film.folder,dcover['path'])
end
def cover_img_name
  @cover_img_name ||= File.basename(book_infos['cover']['path'])
end

def logo_editor_original_path
  @logo_editor_original_path ||= File.join(film.folder,book_infos['publisher']['logo'])
end
def logo_editor_products_path
  @logo_editor_products_path ||= File.join(film.folder_products, logo_editor_img_name)
end
def logo_editor_img_name
  @logo_editor_img_name ||= File.basename(book_infos['publisher']['logo'])
end
private

  def template_path
    @template_path ||= File.join(APP_FOLDER,'_TEMPLATES_','cover.html')
  end

  def informations_valides?
    # === Les données minimales sont-elles définies ? ===
    begin
      config.key?('title') || raise("le titre du film (title)")
      config.key?('book_infos') || raise("les informations du film dans le fichier de configuration ('book_infos')")
      binfos = config['book_infos']
      binfos.is_a?(Hash) || raise("book_infos comme une table comportant les clés 'author', 'publisher' et 'cover'")
      binfos.key?('author') || raise("l'auteur de l'analyse (book_infos > author)")
      binfos.key?('publisher') || raise("l'éditeur de l'analyse (book_infos > publisher)")
      binfos.key?('cover') || raise("les données de couverture (book_infos > cover)")
      pubinfos = binfos['publisher']
      pubinfos.is_a?(Hash) || raise("book_infos > publisher comme une table comportant les clés 'name' et 'logo'")
      pubinfos.key?('name') || raise("le nom de l'éditeur (book_infos > publisher > name)")
      # Note le logo ('logo') est optionnel
      cinfos = binfos['cover']
      cinfos.is_a?(Hash) || raise("book_infos > cover comme une table comportant les clés 'path' et 'width'")
      cinfos.key?('path') || raise("le chemin d'accès à l'image de couverture (book_infos > cover > path)")
      # La taille ('width') est optionnelle
    rescue Exception => e
      log(e)
      Ajax << {error: "Dans 'config.yml', il faut définir #{e.message} (se reporter au manuel)"}
    end

    # === Les éléments existent-ils ? ===
    begin
      # Le logo de l'éditeur
      pubinfos['logo'] && not(File.exists_with_case?(File.join(folder,pubinfos['logo']))) && raise("Le logo de l'éditeur est introuvable (#{pubinfos['logo']})")
      # L'image de couverture
      File.exists_with_case?(File.join(folder,cinfos['path'])) || raise("L'image de couverture est introuvable (#{cinfos['path']})")
    rescue Exception => e
      log(e)
      Ajax << {error: "#{e.message}"}
    end
  end #/ informations_valides?

  def film ; @film ||= Film.current end
end #/Film
