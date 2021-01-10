'use strict'
class Film {

// Méthode qui charge le film courant (c'est-à-dire le film se trouvant
// dans le dossier _FILMS_)
static load(){
  Ajax.send('load_config_current_film.rb')
  .then(ret => {
    console.log(ret)
    const config = ret.config
    const video = new DOMVideo(DGet('video'), `_FILMS_/${config.film_folder}/${config.video.name}`)
    video.setWidth(config.video.width || 400)
  })
}



  constructor() {

  }
}
