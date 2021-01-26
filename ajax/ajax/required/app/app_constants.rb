# encoding: UTF-8

DATA_PERSO_PATH = File.join(APP_FOLDER,'ajax','secret','perso')

EBOOK_CONVERT_CMD = '/Applications/calibre.app/Contents/console.app/Contents/MacOS/ebook-convert'


# Table des documents qui sont créés de façon automatique
AUTO_DOCUMENTS = {
  'cover.html'        => {hname:'Couverture', required_data:['book_title','cover_img_path','cover_img_left','cover_img_top','cover_img_width','cover_img_height','author_name','publisher_name', 'publisher_logo']},
  'pfa.jpg'           => {hname:'Paradigme de Field Augmentée du film'},
  'synopsis.html'     => {hname:'Synopsis'},
  'sequencier.html'   => {hname:'Séquencier'},
  'traitement.html'   => {hname:'Traitement'},
  'statistiques.html' => {hname:'Statistiques'},
  'composition.html'  => {hname:'Page d’information sur la composition du livre', required_data:['isbn','publisher_name', 'publisher_address', 'depot_legal', 'imprimeur','print_date']},
  'quatrieme.html'    => {hname:'Quatrième de couverture', required_data:['resume','isbn','author_cv', 'cover4_img_path','prix']}
}
