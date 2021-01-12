'use strict'
class Film {

// Méthode qui charge le film courant (c'est-à-dire le film se trouvant
// dans le dossier _FILMS_)
static load(){
  const my = this
  Ajax.send('load_config_current_film.rb')
  .then(my.prepareFilm.bind(my))
  .then(my.loadFilmEvents.bind(my))
}
static prepareFilm(ret){
  return new Promise((ok,ko) => {
    if ( ret.config ){
      window.film = new Film(ret.config)
      window.film.prepare()
      ok()
    }
  })
}
static loadFilmEvents(){
  return Ajax.send('load_events.rb', {film: film.folder})
  .then(film.dispatchEvents.bind(film))
}


/** ---------------------------------------------------------------------
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(config) {
  this.config = config // contient tout ce qui est défini dans config.yml
}

prepare(){
  this.prepareVideo()
  this.prepareEditor()
}
prepareVideo(){
  window.video = new DOMVideo(DGet('video'), `_FILMS_/${this.config.film_folder}/${this.config.video.name}`)
  window.video.setWidth(this.config.video.width || 400)
}
prepareEditor(){
  if ( this.config.personnages ){
    this.prepareMenuPersonnages()
  } else {
    DGet('select#personnages').classList.add('hidden')
  }
}
prepareMenuPersonnages(){
  const menuPersonnages = DGet('select#personnages')
  menuPersonnages.appendChild(DCreate('OPTION', {value:'', text:"Choisir…"}))
  this.personnages = this.config.personnages
  for(var pid in this.personnages){
    menuPersonnages.appendChild(DCreate('OPTION',{value:pid, text:`${this.personnages[pid]} (${pid})`}))
  }
  menuPersonnages.addEventListener('change', this.onChoosePersonnage.bind(this))
}

/**
* Méthode appelée après le chargement par ajax de tous les évènements
du film courant
***/
dispatchEvents(ret){
  ret.events.forEach(devent => AEvent.addFromData(devent))
}

/** ---------------------------------------------------------------------
*   Méthodes d'évènement
  *
*** --------------------------------------------------------------------- */

onChoosePersonnage(){
  message("Un personnage a été choisi")
}


}
