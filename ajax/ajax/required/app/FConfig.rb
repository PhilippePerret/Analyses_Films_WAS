# encoding: UTF-8
# frozen_string_literal: true
=begin
  Class Config
  ------------
  Pour gérer les configurations du film.
  En premier lieu, cette classe permet d'obtenir n'importe quelle valeur
  de configuration par une propriété simple. Elle est utilisé dans
  AUTO_DOCUMENTS pour connaitre les propriétés requises à la construction de
  chaque type de document.
=end
class FConfig
attr_reader :film, :config
def initialize(film)
  @film   = film
  log("film dans FConfig = #{film.inspect}")
  @config = film.config
end

# Retourne la table pour renseigner (détemplatiser) une page. En clé la balise
# à remplacer (celle dans %{balise}) et en valeur la valeur pour le film.
def get(keys)
  h = {}
  keys.each { |key| h.merge!(key.to_sym => self.send(key.to_sym)) }
  return h
end

def book_title        ; @book_title         ||= config['title']           end
def isbn              ; @isbn               ||= config['isbn']            end
def resume            ; @resume             ||= config['resume']          end
def author_name       ; @author_name        ||= authorinfos['name']       end
def author_cv         ; @author_cv          ||= authorinfos['cv']         end
def author_books      ; @author_books       ||= authorinfos['books']      end
def publisher_name    ; @publisher_name     ||= pubinfos['name']          end
def publisher_logo    ; @publisher_logo     ||= pubinfos['logo']          end
def publisher_address ; @publisher_address  ||= pubinfos['address']       end

def cover_img_path    ; @cover_img_path     ||= coverinfos['path']        end
def cover_img_left    ; @cover_img_left     ||= coverinfos['left']        end
def cover_img_width   ; @cover_img_width    ||= coverinfos['width']       end
def cover_img_height  ; @cover_img_height   ||= coverinfos['height']      end
def cover_img_top     ; @cover_img_top      ||= coverinfos['top']         end

def cover4_img_path   ; @cover4_img_path    ||= cover4infos['img_path']   end
def depot_legal       ; @depot_legal        ||= bookinfos['depot_legal']  end
def printer_name      ; @printer_name       ||= printerinfos['name']      end
def printer_address   ; @printer_address    ||= printerinfos['address']   end
def print_date        ; @print_date         ||= bookinfos['print_date']   end


def copyright         ; @copyright          ||= bookinfos['copyright']    end
def prix              ; @prix               ||= config['prix']            end

def dedicace
  if File.exists?(dedicace_path)
    kramdown(dedicace_path) + "\n"
  else
    '&nbsp;' # pour ne jamais générer d'erreur
  end
end
def dedicace_path
  @dedicace_path ||= File.join(film.folder_documents,'dedicace.md')
end

def printerinfos
  @printerinfos ||= bookinfos['printer'] || raise("Il faut définir 'book_infos > printer >' dans le fichier config.yml du film !")
end
def bookinfos
  @bookinfos ||= config['book_infos'] || raise("Il faut définir 'book_infos' dans le fichier config.yml du film")
end
def authorinfos
  @authorinfos ||= bookinfos['author']  || raise("Il faut définir 'book_infos > author' dans le fichier config.yml du film")
end
def coverinfos
  @coverinfos ||= bookinfos['cover'] || raise("Il faut définir 'book_infos > cover' dans le fichier config.yml du film")
end
def cover4infos
  @cover4infos ||= bookinfos['cover4']  || raise("Il faut définir 'book_infos > cover4' dans le fichier config.yml du film")
end
def pubinfos
  @pubinfos ||= bookinfos['publisher']
end
def filminfos
  @filminfos ||= config['film_infos']  || raise("Il faut définir 'film_infos' dans le fichier config.yml du film")
end

end #/Class FConfig
