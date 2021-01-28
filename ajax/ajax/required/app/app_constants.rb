# encoding: UTF-8

DATA_PERSO_PATH = File.join(APP_FOLDER,'ajax','secret','perso')

EBOOK_CONVERT_CMD = '/Applications/calibre.app/Contents/console.app/Contents/MacOS/ebook-convert'


# Table des documents qui sont créés de façon automatique
AUTO_DOCUMENTS = {
  'frontispice.html'  => {hname:'Huit premières pages', required_data:['book_title','isbn','author_books','author_name','publisher_name','publisher_address','copyright','dedicace']},
  'pfa.html'          => {hname:'Paradigme de Field Augmentée du film'},
  'synopsis.html'     => {hname:'Synopsis'},
  'sequencier.html'   => {hname:'Séquencier'},
  'traitement.html'   => {hname:'Traitement'},
  'statistiques.html' => {hname:'Statistiques'},
  'composition.html'  => {hname:'Page d’information sur la composition du livre', required_data:['isbn','publisher_name', 'publisher_address', 'depot_legal', 'printer_name', 'printer_address']},
  'quatrieme.html'    => {hname:'Quatrième de couverture', required_data:['resume','isbn','author_cv', 'author_photo', 'cover4_img_path', 'cover4_img_width', 'cover4_img_left','cover4_img_top', 'prix']}
}
