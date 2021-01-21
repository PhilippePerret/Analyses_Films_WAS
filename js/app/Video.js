'use strict'
/** ---------------------------------------------------------------------
*   Class Video
*   -----------
    Pour la commande de la vidéo

On peut avoir plusieurs vidéo dans l'écran, pour pouvoir faire des
comparaison. La vidéo principale est une propriété 'video' de window.
On peut donc y faire appel de n'importe où par 'video'.
*** --------------------------------------------------------------------- */

const DATA_SPEEDS = {
    '-x3'   :  {hname:'↫ x 3',   value: [-.015,1]}
  , '-x2'   :  {hname:'↫ x 2',   value: [-.01, 1]}
  , '-x1.5' :  {hname:'↫ x 1.5', value: [-.01, 2]}
  , '-x1'   :  {hname:'↫ x 1',   value: [-.01,8]}
  , 'x1'    :  {hname:'↬ x 1',   value: null} // <===== ISPEED_X1
  , 'x1.5'  :  {hname:'↬ x 1.5', value: [.01, 2]}
  , 'x2'    :  {hname:'↬ x 2',   value: [.01, 1]}
  , 'x2.5'  :  {hname:'↬ x 2.5', value: [.0125, 1]}
  , 'x3'    :  {hname:'↬ x 3',   value: [.015,1]}
  , 'x3.5'  :  {hname:'↬ x 3.5', value: [.0175,1]}
  , 'x4'    :  {hname:'↬ x 4',   value: [.02, 1]}
  , 'x6'    :  {hname:'↬ x 6',   value: [.03, 1]}
  , 'x8'    :  {hname:'↬ x 8',   value: [.04, 1]}
}
const SPEEDS = Object.keys(DATA_SPEEDS)
const ISPEED_X1 = SPEEDS.indexOf('x1')
const LAST_ISPEED = SPEEDS.length - 1
// console.info("ISPEED_X1 = %i, LAST_ISPEED = %i, SPEEDS:", ISPEED_X1, LAST_ISPEED, SPEEDS)

class DOMVideo {
/** ---------------------------------------------------------------------
*   CLASSE
*
*** --------------------------------------------------------------------- */

// La vidéo courante, donc activée, qui recevra toutes les commandes
static get current(){return this._current || (this._current = video)}
static set current(v){
  this.current.container.classList.remove('selected')
  this._current = v
  this._current.container.classList.add('selected')
}

/**
* Méthode qui permet de suivre les évènements en même temps que la vidéo

  Doit déterminer this.nextTime qui est le temps du prochain évènement
***/
static setCurrentVideoEvent(){
  // console.log("-> setCurrentVideoEvent (%f)", video.time)
  // S'il y a un évènement courant
  const evs = AEvent.getEventsAround(video.time)
  // console.log("evs = ", evs)
  evs.previous && evs.previous.listingItem.removeClass('current-in-video')
  evs.current && evs.current.listingItem.addClass('current-in-video')
  this.nextTime = evs.next ? evs.next.time : 10000000
  // console.log("this.nextTime = %f", this.nextTime)
}

/**
* Au démarrage, régler les options pour la vidéo
On en profite aussi pour placer les observateurs pour changer les
options quand il y a un travail à faire.
***/
static setOptions(){
  const videosOptions = ['follow_selected_event', 'show_current_event','video_follows_mouse','synchro_videos_on_stop']
  videosOptions.forEach(key => {
    const cb = DGet('#' + key)
    cb.checked = film.options[key]
    cb.addEventListener('click', film.onChangeOption.bind(film, key))
  })
}

static incVideosReady(){
  if(undefined === this.nombreVideosReady) this.nombreVideosReady = 0
  ++ this.nombreVideosReady
  if ( this.nombreVideosReady == this.nombreVideosToPrepare ) {
    App.setVeryReady()
  }
}

/**
* Méthode qui synchronise les deux vidéos (donc qui les cale sur le même temps)
***/
static synchronizeVideos(){
  if (video2){
    this.current.otherVideo.time = this.current.time
    message("Retours vidéos synchronisés", {keep:false})
  } else {
    error("Il y a un seul retour vidéo. Impossible de les synchroniser.")
  }
}
/** ---------------------------------------------------------------------
*
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(obj, src) {
  this.obj = obj
  this.container = this.obj.parentNode
  this.id = this.obj.id // p.e. "video1"
  this.src = src
  this.init()
}
show(){
  this.container.classList.remove('hidden')
}
hide(){
  this.container.classList.add('hidden')
}
remove(){
  this.obj.src = ""
  this.hide()
}


/** ---------------------------------------------------------------------

  MOTEUR DE VIDÉO

  Méthodes pour la VITESSE

*** --------------------------------------------------------------------- */

togglePlay(){
  if (this.playing) {
    this.pause()
  } else {
    this.play()
  }
}

/**
Menu quand on change la vitesse
this.ispeed contient l'indice courant d'accélération (qui peut être égal à ISPEED_X1
et dans ce cas ne présenter aucune accélération ni aucun ralentissement)
***/
setSpeed(newispeed){
  const isPlaying = !!this.playing
  this.ispeed = newispeed
  this.showSpeed()
  isPlaying && this.obj.pause()
  this.playMethod = this[this.ispeed == ISPEED_X1 ? 'playRegular' : 'playWithSpeed'].bind(this)
  isPlaying && this.play()
}

/**
* Méthode pour mettre en route la vidéo
---------------------------------------
Elle appelle une méthode différente suivante qu'il faut jouer à la
vitesse normale ou qu'il faut jouer plus vite ou plus lentement.
***/
play(){
  this.timerPlay && this.stopPlayWithSpeed()
  if ( undefined == this.playMethod ) this.playMethod = this.playRegular.bind(this)
  this.playMethod.call(this)
  this.playing = true
}
// Quand on doit jouer à la vitesse normale
playRegular(){
  this.obj.play()
}
playWithSpeed(){
  if ( undefined == this.timerPlay ) {
    const dataSpeed = DATA_SPEEDS[SPEEDS[this.ispeed]]
    const enAvant = this.ispeed >= ISPEED_X1
    this.timerPlay = setInterval(this[`fakePlaying${enAvant?'':'Backward'}`].bind(this, dataSpeed.value[0]), dataSpeed.value[1])
  } else {
    console.warn("Le timerPlay est déjà lancé, je ne le relance pas.")
  }
}
fakePlaying(cran){
  if ( this.obj.currentTime >= film.duration ){
    this.pause()
  } else {
    this.obj.currentTime += cran
  }
}
fakePlayingBackward(cran){
  if ( this.obj.currentTime <= 0 ){
    this.pause()
  } else {
    this.obj.currentTime += cran
  }
}

stopPlayWithSpeed(){
  clearInterval(this.timerPlay)
  this.timerPlay = undefined
  delete this.timerPlay
  // console.info("timerPlay arrêté")
}

pause(){
  this.obj.pause()
  this.playing = false
  if ( undefined != this.timerPlay ) this.stopPlayWithSpeed()
  if ( ! this.speedIsFrozen ) this.setSpeed(ISPEED_X1)
  this.synchroOtherVideoOnStop && this.constructor.synchronizeVideos()
  // console.info("STOP")
}


// Touche pour aller en avant pressée
onKeyL(ev){
  // console.log("-> onKeyL")
  if ( this.playing ){
    if ( this.ispeed < ISPEED_X1 /* marche arrière */) {
      this.setSpeed(ISPEED_X1)
    } else {
      if ( this.speedIsFrozen ) return
      this.upSpeed()
    }
  } else {
    this.play()
  }
}
// Touche pour aller en arrière pressée
onKeyJ(ev){
  if ( this.playing ) {
    if ( this.ispeed > ISPEED_X1 /* marche avant */) {
      this.setSpeed(ISPEED_X1 - 1)
    } else {
      if ( this.speedIsFrozen ) return
      this.downSpeed()
    }
  } else {
    this.setSpeed(ISPEED_X1 - 1)
    this.play()
  }
}
/**
Touche pour s'arrêter pressée
-----------------------------
Trois comportement possible :
  1. la vidéo joue => On l'arrête à l'endroit joué
  2. la vidéo est arrêtée après le point-zéro => on rejoint le point zéro
  3. la vidéo est arrêtée au point zéro => on rejoint le tout début de la vidéo
**/
onKeyK(ev){
  if ( this.playing ) {
    this.pause()
  } else if ( this.time > (film.realStart + 0.1) ) {
    this.time = film.realStart
  } else if ( this.time > 0.1 ) {
    this.time = 0
  }
}

// Méthode appelée quand on change la vitesse par le menu
onChangeSpeedWithMenu(ev){
  this.setSpeed(Number(this.oMenuSpeed.value))
  this.oMenuSpeed.blur()
}
upSpeed(){
  if ( this.ispeed < LAST_ISPEED ){
    this.setSpeed(++this.ispeed)
  } else {
    erreur("C'est la vitesse maximale.",{keep:false})
  }
}
downSpeed(){
  if ( this.ispeed > 0 ) {
    this.setSpeed(--this.ispeed)
  } else {
    erreur("C'est la vitesse minimale.",{keep:false})
  }
}

// Pour afficher la vitesse
showSpeed() { this.oMenuSpeed.value = this.ispeed }

/**
* Méthode qui, à l'initialisation de la vidéo, construit le menu pour
choisir et afficher la vitesse
***/
buildMenuSpeeds(){
  var ispeed, speed_id, dspeed
  for(ispeed in SPEEDS){
    speed_id  = SPEEDS[ispeed]
    dspeed    = DATA_SPEEDS[speed_id]
    this.oMenuSpeed.appendChild(DCreate('OPTION',{value:ispeed, text:dspeed.hname}))
  }
  this.setSpeed(ISPEED_X1)
}

// ---------------------------------------------------------------------

/**
* Pour avancer ou reculer d'un "cran"
Par défaut, on avance d'une frame (25 par secondes)
Mais avec des modifieurs :
  - maj:      avance par seconde
  - command   avance par dizaine de secondes
***/
avance(ev){
  // message(`-> avance (time = ${this.time})`, {keep:false})
  const nt = this.calcPas(this.time, ev, 1)
  this.time = nt
  // message("Temps fin vidéo dans avance = " + this.time)
}
recule(ev){
  // message(`-> recule (time = ${this.time})`, {keep:false})
  this.time = this.calcPas(this.time, ev, -1)
  // message("Temps fin recule = " + this.time)
}
calcPas(t, ev, factor){
  var p
  if ( ev.shiftKey )      p = 10
  else if ( ev.metaKey )  p = 1
  else                    p = .04
  t += p * factor
  // console.log("Nouveau temps à appliquer = %f (pas = %f)", t, p)
  return t
}

init(){
  const my = this
  my._frozenspeed = false
  this.obj.src = this.src
  this.rewindRate = 60
  this.obj.load()
  // On attend que la vidéo soit chargée
  $(this.obj).on('canplaythrough', (res) => {
    my.calcValues()
    my.observe()
    my.setReady()
  })
  // On construit le menu des vitesses
  this.buildMenuSpeeds()
}

/**
* Pour mettre une balise de temps de type [temps:h:mm:ss] dans le presse-papier
***/
baliseTimeInClipboard(){
  const balise = `[time:${s2h(this.time, /* frames = */ false)}]`
  clip(balise)
  message(`La balise « ${balise} » a été placé dans le presse-papier.`)
}

/** ---------------------------------------------------------------------
*   Properties
*** --------------------------------------------------------------------- */

get time(){ return parseFloat(Number.parseFloat(this.obj.currentTime).toFixed(3)) }
set time(v){
  v = parseFloat(v) // peut être un string
  if ( v <= this.duration ) {
    this.obj.currentTime = v + .001
  } else {
    error(`Le temps ${t2h(v)} dépasse la durée du film.`, {keep:false})
  }
}

get duration(){return this._duration || (this._duration = this.obj.duration)}

// Méthode pour informer que la vidéo est prête
setReady(){
  this.onTimeChange(null) // pour régler l'horloge
  this.constructor.incVideosReady()
}
observe(){
  this.obj.addEventListener('click', this.onClick.bind(this))
  this.obj.addEventListener('mouseover', this.onMouseOver.bind(this))
  this.obj.addEventListener('mouseout',  this.onMouseOut.bind(this))
  this.obj.addEventListener('mousemove', this.onMouseMove.bind(this))
  this.obj.addEventListener('timeupdate', this.onTimeChange.bind(this))
  // Pour modifier la vitesse
  this.oMenuSpeed.addEventListener('change', this.onChangeSpeedWithMenu.bind(this))
  // Pour geler ou dégeler la vitesse
  this.cadenasSpeed.addEventListener('click', this.onLockUnlockSpeed.bind(this))

}

get isMouseSensible(){ return film.options.video_follows_mouse }
get synchroOtherVideoOnStop(){ return film.options.synchro_videos_on_stop}

/**
* Méthode calculant les valeurs après le chargement de la vidéo, et notamment
* le rapport px/temps
***/
calcValues(){
  this.timeRatio = $(this.obj).width() / this.obj.duration
}
px2time(px){ return px / this.timeRatio}
time2px(time){ return parseInt(time * this.timeRatio, 10)}

/**
* Méthode appelée au changement de temps
  - elle règle l'horloge
  - elle regarde si un évènement doit être "sélectionné"
  - elle déplace la petite tête de lecture sous la vidéo
***/
onTimeChange(ev){
  this.horloge.set(this.time)
  if ( film.options.show_current_event && this.time > (this.constructor.nextTime||0) ){
    this.constructor.setCurrentVideoEvent()
  }
  this.tete_lecture = DGet('.tete-lecture',this.container)
  this.tete_lecture.style.left = px(this.time2px(this.time))
}
get horloge(){
  return this._horloge || (this._horloge = new Horloge(this))
}
onMouseMove(ev){
  if ( !this.frozen ) {
    if (this.isMouseSensible){
      this.time = this.px2time(ev.offsetX)
      this.moving = true
    } else {
      this.miniHorloge.show(this.px2time(ev.offsetX))
    }
  }
}
onMouseOut(ev){
  if (this.isMouseSensible){
    // this.obj.removeEventListener('keydown', this.onKey.bind(this))
  } else {
  }
  this.resetOnMouse()
}
/**
* Méthode appelée quand on passe la souris sur la vidéo. Ça active
* les raccourcis propres à la vidéo
***/
onMouseOver(ev){
  if (this.isMouseSensible){
    // this.obj.addEventListener('keydown', this.onKey.bind(this))
  } else {
    this.miniHorloge.show(this.px2time(ev.offsetX))
  }
}
resetOnMouse(){
  this.miniHorloge.hide()
  this.moving = false
  this.frozen = false
}

/**
* Méthode captant les touches clavier QUAND LA SOURIS EST SUR LA VIDÉO
***/
onKey(ev){
  switch(ev.key){
    case 'ArrowLeft':
      this.recule(ev)
      return stopEvent(ev)
    case 'ArrayRight':
      this.avance(ev)
      return stopEvent(ev)
    default:
      message("Touche "+ev.key)
  }
}

onClick(ev){
  if ( this.isMouseSensible ){
    if ( this.frozen ) {
      this.frozen = false
      message("Vidéo dégelée. Tu peux déplacer la souris pour chercher un temps", {keep:false})
    } else {
      message("Vidéo gelée.", {keep:false})
      this.frozen = true
    }
  } else {
      // Quand la vidéo n'est pas sensible à la souris, un clic dessus
      // met le temps courant.
      this.time = this.px2time(ev.offsetX)
  }
  // La mettre en vidéo courante
  this.constructor.current = this
}


/** ---------------------------------------------------------------------
*   Méthodes de navigation
*** --------------------------------------------------------------------- */

// Pour avancer du nombre +frames+ de frames
forward(s){
  this.time = this.time + parseFloat(s)
}
// Pour reculer du nombre +frames+ de frames
backward(s){
  this.time = this.time - parseFloat(s)
}
/*
  Pour aller à un temps précis ou à un lieu précis (sert à la console)
  +s+   Peut être :
          - un nombre de secondes
          - une horloge h:m:s.f
          - un lieu précis (comme 'milieu', 'trois-quart', etc.)
          - une scène (+offset+ est alors le numéro de la scène)
  +offset+  {Number} Le décalage en secondes avec le point à rejoindre
*/
goto(s, offset){
  switch(s){
    case 'quart':
    case 'tiers':
    case 'milieu':
    case 'deux-tiers':
    case 'trois-quarts': return this.gotoLieu(s, offset)
    case 'scene' : return this.gotoScene(offset)
    default:
      this.time = s.match(/[:\.]/) ? h2t(s) : parseFloat(s)
  }
}
gotoLieu(lieu, offset){
  var m ;
  switch(lieu){
    case 'quart':         m = 1/4; break
    case 'tiers':         m = 1/3; break
    case 'milieu':        m = 1/2; break
    case 'deux-tiers':    m = 2/3; break
    case 'trois-quarts':  m = 3/4; break
    default:
      return erreur(`Je ne connais pas le lieu '${lieu}'`)
  }
  const v = film.realDuration * m ;
  this.time = film.realStart + v + parseFloat(offset||0)
}
// Méthode pour rejoindre une scène
gotoScene(numero){
  numero = Number(numero)
  var numCourante = 0
    , i = 0
    , len ;
  for(i, len = AEvent.count; i < len ; ++i){
    const ev = AEvent.orderedList[i]
    if (ev.type == 'sc'){
      ++numCourante
      if (numCourante == numero){
        AEvent.listing.select(ev)
        return true
      }
    }
  }
  const errAjout = numCourante == 0
    ? 'cette analyse ne définit aucune scène'
    : `dernier numéro de scène : ${numCourante}`
  erreur(`Aucune scène de numéro ${numero} n’a été trouvée… (${errAjout})`)
}

// ---------------------------------------------------------------------

// Pour afficher/masquer tous les repères PFA
toggleReperesPFA(){
  if (this.reperesPfaON) this.erase('all')
  else this.draw('all')
  this.reperesPfaON = !this.reperesPfaON
}

// === Commandes pour dessiner sur la vidéo ===
draw(what){
  message("Je dessine…", {keep:false})
  // On masque le début et la fin si nécessaire
  this.drawMasqueHorsFilm()
  switch(what){
    case 'quarts': return this.drawQuarts()
    case 'tiers':  return this.drawTiers()
    case 'all': this.drawQuarts(); return this.drawTiers()
    default: return erreur(`Je ne sais pas dessiner de '${what}'.`)
  }
}
erase(what){
  message("J'efface…", {keep:false})
  // On masque le début et la fin si nécessaire
  this.eraseMasqueHorsFilm()
  switch(what){
    case 'quarts': return this.eraseQuarts()
    case 'tiers':  return this.eraseTiers()
    case 'all': this.eraseQuarts(); return this.eraseTiers()
    default: return erreur(`Je ne sais pas dessiner de '${what}'.`)
  }
}


drawMasqueHorsFilm(){
  if ( film.realStart > 0 ) {
    const sty = {left:0, width:this.time2px(film.realStart), height: this.height}
    this.container.appendChild(DCreate('DIV',{class:'repere mask', style:px(sty,true)}))
  }
  if ( film.realEnd < this.duration - 1 ) {
    const sty = {left:this.time2px(film.realEnd), right:0, height: this.height}
    this.container.appendChild(DCreate('DIV',{class:'repere mask', style:px(sty,true)}))
  }
}
eraseMasqueHorsFilm(){
  $('.repere.mask').remove()
}

drawQuarts(){
  const duree = film.realDuration
  const left  = this.time2px(film.realStart)
  for(var i = 1 ; i < 4 ; ++i){
    const sty = { left: left + this.time2px(duree * i / 4), height: this.height }
    this.container.appendChild(DCreate('DIV', {class:'repere quart', style:px(sty, true)}))
  }
}
eraseQuarts(){$('.repere.quart').remove()}
drawTiers(){
  const duree = film.realDuration
  const left  = this.time2px(film.realStart)
  for(var i = 1 ; i < 3 ; ++i){
    const sty = { left: left + this.time2px(duree * i / 3), height: this.height }
    this.container.appendChild(DCreate('DIV', {class:'repere tiers', style:px(sty, true)}))
  }
}
eraseTiers(){$('.repere.tiers').remove()}

// ---------------------------------------------------------------------

setWidth(w){
  // console.log("Je dois avancer de ", frames)
  this.obj.style.width = px(w)
}

get cadenasSpeed(){return DGet('img.cadenas-speed',this.container) }

onLockUnlockSpeed(ev){
  stopEvent(ev)
  this._frozenspeed = !this._frozenspeed
  this.cadenasSpeed.src = `img/ui/cadenas-${this._frozenspeed?'':'un'}locked.png`
}

get speedIsFrozen(){ return this._frozenspeed }

get miniHorloge(){
  return this._minihorloge || (this._minihorloge = new HorlogeMini(this))
}

get oMenuSpeed(){
  return this._spanspeed || ( this._spanspeed = DGet('select.speed',this.container))
}

get height(){
  return this._height || (this._height = this.obj.offsetHeight)
}

get otherVideo(){
  return this._othervideo || (this._othervideo = (this.id =='video1' ? video2 : video))
}

}// DOMVideo
