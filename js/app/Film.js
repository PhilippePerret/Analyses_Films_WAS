'use strict'
class Film {

// Méthode qui charge le film courant (c'est-à-dire le film se trouvant
// dans le dossier _FILMS_)
static load(){
  const my = this
  Ajax.send('load_config_current_film.rb')
  .then(my.prepareFilm.bind(my))
  .then(AEvent.load.bind(AEvent))
  .then(Locators.load.bind(Locators))
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


/** ---------------------------------------------------------------------
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(config) {
  this.config = config // contient tout ce qui est défini dans config.yml
}

// Sauvegarde des configurations du film
save(){
  Ajax.send('save_config.rb', {config: this.config})
}

prepare(){
  this.options = this.defaultizeOptions(this.config.options)
  DOMVideo.nombreVideosToPrepare = this.config.video2 ? 2 : 1
  this.prepareVideo()
  this.config.video2 && this.prepareVideo2()
  DOMVideo.setOptions()
  this.prepareEditor()
}
prepareVideo(){
  window.video = new DOMVideo(DGet('video#video1'), `_FILMS_/${this.config.film_folder}/${this.config.video.name}`)
  window.video.setWidth(this.config.video.width || 400)
}
prepareVideo2(){
  window.video2 = new DOMVideo(DGet('video#video2'), `_FILMS_/${this.config.film_folder}/${this.config.video.name}`)
  window.video2.setWidth(this.config.video2.width || 400)
  window.video2.show()
}
prepareEditor(){
  AEvent.listing // juste pour le faire apparaitre si aucun event
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

/** ---------------------------------------------------------------------
*   Méthodes d'évènement
  *
*** --------------------------------------------------------------------- */

onChoosePersonnage(){
  message("Un personnage a été choisi")
}

onChangeOption(key){
  this.options[key] = DGet('#'+key).checked
  this.save()
}

/** ---------------------------------------------------------------------
*   PRIVATE METHODS AND PROPERTIES
*
*** --------------------------------------------------------------------- */

defaultizeOptions(opts = {}){
  const keysOptions = ['follow_selected_event', 'show_current_event','video_follows_mouse']
  keysOptions.forEach(key => {
    if ( undefined === opts[key] ) Object.assign(opts, {[key]: true})
  })
  return opts
}
}// Film
