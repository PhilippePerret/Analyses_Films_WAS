'use strict'
class Film {

/**
Méthode qui charge le film courant (c'est-à-dire le film se trouvant
dans le dossier _FILMS_ qui est défini par le fichier _FILMS_/CURRENT)
*/
static load(){
  const my = this
  Ajax.send('load_config_current_film.rb')
  .then(my.maybeSomethingToDo.bind(my))
  .then(my.prepareFilm.bind(my))
  .then(AEvent.load.bind(AEvent))
  .then(Locators.load.bind(Locators))
}

static maybeSomethingToDo(retourAjax){
  console.log("retour ajax: ", retourAjax)
  retourAjax.message && message(retourAjax.message)
  delete retourAjax.message
  return new Promise( (ok,ko) => {
    this.preActionsRequired = []
    if ( retourAjax.require_retrieve_video ) {
      this.preActionsRequired.push('video')
      message("La vidéo doit être copiée. Merci de patienter un moment…", {timer:false})
      Ajax.send('retrieve_video.rb').then(this.onActionsPreparatoiresRequired.bind(this,'video',ok, retourAjax))
      return
    }
    if (retourAjax.require_audio_file) {
      this.preActionsRequired.push('audio')
      message("Le fichier son doit être produit. Merci de patienter un moment…", {timer:false})
      Ajax.send('product_audio_file.rb').then(this.onActionsPreparatoiresRequired.bind(this,'audio',ok, retourAjax))
      return
    }
    ok(retourAjax)
  })
}

/**
* Quand des actions préparatoires ont été requises, on attend leur
exécution dans cette méthode
***/
static onActionsPreparatoiresRequired(keyAction, whenOkMethod, retourAjax, ret){
  // console.log("ret %s = ", keyAction, ret)
  this.preActionsRequired.pop()
  if (keyAction == 'audio' && !ret.ok){
    console.error("Problème avec la production du fichier audio. Consulter le retour en console")
    console.error(ret)
  }
  if (this.preActionsRequired.length == 0) {
    console.info("OK, les actions ont été accomplies ")
    whenOkMethod(retourAjax)
  }
}

static prepareFilm(ret){
  console.log("-> prepareFilm(%s)", ret)
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

setConfig(key, value){
  Ajax.send('set_config.rb', {config_key:key, config_value:value})
  .then(ret => {
    this.config[key] = value
    // console.log("ret :", ret)
    // Note : pas de message, la méthode est trop souvent appelée
  })
}

prepare(){
  this.options = this.config.options = Options.defaultize(this.config.options)
  this.config.snippets && Snippets.addCustomSnippets(this.config.snippets)
  this.setTitle()
  DOMVideo.nombreVideosToPrepare = this.config.video2 ? 2 : 1
  this.prepareAudio()
  this.prepareVideo()
  this.config.video2 && this.prepareVideo2()
  Options.set()
  this.prepareEditor()
  this.prepareMenuPersonnages()
}

setTitle(){
  document.querySelector('head title').textContent = `Analyse du film : ${this.title.toUpperCase()}`
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

prepareAudio(){
  window.audio = DGet('audio#audio')
  audio.addEventListener('canplaythrough', (ret) => { console.log("L'audio est prête")})
  audio.src = `_FILMS_/${this.config.film_folder}/${this.audio_name}`
}
get audio_name(){
  const vname = this.config.video.name
  return vname.substr(0, vname.lastIndexOf('.')) + '.mp3'
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
}

// Afficher/masquer la liste des personnages
togglePersonnages(){
  const montrer = this.menuPersonnages.classList.contains('hidden')
  this.menuPersonnages.classList[montrer?'remove':'add']('hidden')
}
prepareMenuPersonnages(){
  this.menuPersonnages.appendChild(DCreate('OPTION', {value:'', text:"Choisir…"}))
  this.updateMenuPersonnages()
  this.menuPersonnages.addEventListener('change', this.onChoosePersonnage.bind(this))
}
updateMenuPersonnages(){
  this.menuPersonnages.textContent = ''
  this.personnages = this.config.personnages
  for(var pid in this.personnages){
    this.menuPersonnages.appendChild(DCreate('OPTION',{value:pid, text:`${pid} = ${this.personnages[pid].full_name||this.personnages[pid]}`}))
  }
}
// À régler
get decorsForMenus(){
  var data_decor
  const decors = this.config.decors || {}
  const liste_decors = []
  for(var kdecor in decors ) {
    data_decor = decors[kdecor]
    if ( 'string' == typeof(data_decor) ) data_decor = {hname:data_decor, items: null}
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

onChoosePersonnage(ev){
  clip(this.menuPersonnages.value)
  message("ID du personnage mis dans le clipboard.")
}

/** ---------------------------------------------------------------------
*   PRIVATE METHODS AND PROPERTIES
*
*** --------------------------------------------------------------------- */

get menuPersonnages(){
  return this._menupersos || (this._menupersos = DGet('select#personnages'))
}
get analyse(){return this._analyse || (this._analyse = new Analyse(this))}

get folder(){return this._folder || (this._folder = this.config.film_folder)}
}// Film
