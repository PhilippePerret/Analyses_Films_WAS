'use strict'
/** ---------------------------------------------------------------------
*   Class Video
*   -----------
    Pour la commande de la vidéo

On peut avoir plusieurs vidéo dans l'écran, pour pouvoir faire des
comparaison. La vidéo principale est une propriété 'video' de window.
On peut donc y faire appel de n'importe où par 'video'.
*** --------------------------------------------------------------------- */

const SPEEDS = [.25, .5, .75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75]

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
  const videosOptions = ['follow_selected_event', 'show_current_event','video_follows_mouse']
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
    const otherVideo = this.current.id == 'video1' ? video2 : video
    otherVideo.time = this.current.time
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
togglePlay(){
  if (this.playing) {
    this.pause()
  } else {
    this.play()
  }
}
play(){
  this.rewinding && this.resetRewind()
  this.resetPlaying()
  this.obj.play()
  this.playing = true
}
resetPlaying(){
  this.obj.pause()
  this.playing = false
  if ( ! this.speedIsFrozen ) {
    this.ispeed = 3
    this.setSpeed()
  }
}
pause(){
  if ( this.playing ){ this.resetPlaying() }
  else if ( this.rewinding ) { this.resetRewinding() }
  else {
    if ( parseInt(this.time,10) > parseInt(film.realStart,10) ) {
      // <= Seconde pression
      // => Début du film
      this.stop(film.realStart)
    } else if (parseInt(this.time,10) == 0) {
      // <= Film à 0
      // => On se place au début s'il existe
      this.stop(film.realStart)
    } else {
      // <= Troisième pression
      // => Tout début de la vidéo
      this.stop(0)
    }
  }
}
// Un "vrai" stop, qui retourne au tout début
stop(at){
  this.playing && this.resetPlaying()
  this.time = at
}
rewind(){
  this.playing && this.resetPlaying()
  this.startRewind()
  this.rewinding  = true
}
resetRewinding(){
  this.stopRewind()
  this.rewinding  = false
  this.rewindRate = 60
}
startRewind(){
  const my = this
  this.rewindTimer = setInterval(() => {
    my.obj.currentTime -= .1
  }, my.rewindRate)
}
stopRewind(){
  if ( this.rewindTimer ) {
    clearInterval(this.rewindTimer)
    delete this.rewindTimer
  }
}

// Pour accéler le jeu à chaque impulsion (appel)
// Note : sauf si la vitesse est bloquée
replay(ev){
  if (this.playing) {
    this.speedIsFrozen || this[ev.ctrlKey?'downSpeed':'upSpeed']()
  }
  else {
    this.play()
  }
}
// Pour accéler le rewind à chaque impulsion (appel)
rerewind(){
  this.stopRewind() // même si ça ne joue pas encore
  this.rewindRate -= 2
  this.rewind()
}

/** ---------------------------------------------------------------------
*   Méthodes pour la VITESSE
*
*** --------------------------------------------------------------------- */
onClickOnSpeed(ev){
  ++ this.ispeed
  this.ispeed < 8 || (this.ispeed = 1)
  this.setSpeed()
}
upSpeed(){
  ++ this.ispeed
  SPEEDS[this.ispeed] || (this.ispeed = 3) // 1
  this.setSpeed()
}
downSpeed(){
  -- this.ispeed
  this.ispeed < 0 && (this.ispeed = 0)
  this.setSpeed()
}
setSpeed(){
  this.obj.playbackRate = SPEEDS[this.ispeed]
  this.showSpeed()
}
/**
* Pour afficher la vitesse
***/
showSpeed(){
  this.spanSpeed.textContent = `x ${String(this.obj.playbackRate).padEnd(4,' ')}`
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
  this.obj.src = this.src
  this.rewindRate = 60
  this.obj.load()
  $(this.obj).on('canplaythrough', (res) => {
    my.calcValues()
    my.observe()
    my.setReady()
  })
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
  // Pour modifier la vitesse en cliquant sur elle
  DGet('span.speed',this.container).addEventListener('click', this.onClickOnSpeed.bind(this))
}

get isMouseSensible(){ return film.options.video_follows_mouse }

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

// Retourne TRUE si la vitesse de la vidéo est bloquée
get speedIsFrozen(){
  return DGet('.opt-freeze-speed', this.container).checked
}

get miniHorloge(){
  return this._minihorloge || (this._minihorloge = new HorlogeMini(this))
}

get spanSpeed(){
  return this._spanspeed || ( this._spanspeed = this.container.querySelector('.speed'))
}

get height(){
  return this._height || (this._height = this.obj.offsetHeight)
}
}// DOMVideo
