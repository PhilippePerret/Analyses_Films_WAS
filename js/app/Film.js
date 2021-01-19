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

/**
* Pour actualiser les données du film, souvent après une modification du
fichier de configuration.
***/
update(){
  Ajax.send('load_config_current_film.rb')
  .then(ret => {
    this.config = ret.config
    this.updateMenuPersonnages()
    AEventEditor.updateMenuDecors()
    window.video.setWidth(this.config.video.width || 400)
    if ( window.video2 ) {
      if (this.config.video2) {
        window.video2.setWidth(this.config.video2.width || 400)
      } else {
        window.video2.remove()
        delete window.video2
        window.video2 = null
      }
    } else if (this.config.video2) {
      this.prepareVideo2()
    }
    message("Film actualisé d'après son fichier config.", {keep:false})
  })
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
  this.updateMenuPersonnages()
  menuPersonnages.addEventListener('change', this.onChoosePersonnage.bind(this))
}
updateMenuPersonnages(){
  const menuPersonnages = DGet('select#personnages')
  menuPersonnages.textContent = ''
  this.personnages = this.config.personnages
  for(var pid in this.personnages){
    menuPersonnages.appendChild(DCreate('OPTION',{value:pid, text:`${this.personnages[pid]} (${pid})`}))
  }
}
// À régler
get decorsForMenus(){
  const decors = this.config.decors || {}
  const liste_decors = []
  for(var kdecor in decors ) {
    const data_decor = decors[kdecor]
    liste_decors.push({id:kdecor, hname:data_decor.hname})
    var sous_decors = data_decor.items
    if ( sous_decors ) {
      for(var ksdecor in sous_decors){
        liste_decors.push({id:`${kdecor}:${ksdecor}`, hname:`${data_decor.hname} : ${sous_decors[ksdecor]}`})
      }
    }
  }
  return liste_decors
}

get title(){return this.config.title}

get pointZero(){return this._pointzero}
set pointZero(nd){this._pointzero = nd}
get pointFin(){return this._pointfin}
set pointFin(nd){this._pointfin = nd}
definePointsLimites(nd){
  switch(nd.type){
    case 'nc:zr': this.pointZero = nd ; break
    case 'nc:ex': if (!this.pointZero){this.pointZero = nd}; break
    case 'nc:pf': this.pointFin = nd ; break
  }
}

// Calcul des valeurs en fonction des vrais débuts et fin
get realDuration(){
  return this._realduration || (this._realduration = this.realEnd - this.realStart)
}
get realStart(){ return this.pointZero ? this.pointZero.time : 0 }
get realEnd(){ return this.pointFin  ? this.pointFin.time  : video.duration }

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

get analyse(){return this._analyse || (this._analyse = new Analyse(this))}

get folder(){return this._folder || (this._folder = this.config.film_folder)}
}// Film
