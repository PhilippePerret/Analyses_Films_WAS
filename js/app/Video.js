'use strict'
/** ---------------------------------------------------------------------
*   Class Video
*   -----------
    Pour la commande de la vidéo

On peut avoir plusieurs vidéo dans l'écran, pour pouvoir faire des
comparaison. La vidéo principale est une propriété 'video' de window.
On peut donc y faire appel de n'importe où par 'video'.
*** --------------------------------------------------------------------- */
class DOMVideo {
/** ---------------------------------------------------------------------
*   CLASSE
*
*** --------------------------------------------------------------------- */

// La vidéo courante, donc activée, qui recevra toutes les commandes
static get current(){return this._current || (this._current = video)}
static set current(v){
  this.current.obj.classList.remove('selected')
  this._current = v
  this._current.obj.classList.add('selected')
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
togglePlay(){
  if (this.playing) {
    this.pause()
  } else {
    this.play()
  }
}
play(){
  this.rewinding && this.resetRewind()
  this.obj.play()
  this.playing = true
}
resetPlaying(){
  this.obj.pause()
  this.playing = false
  this.obj.playbackRate = 1
}
pause(){
  if ( this.playing ){ this.resetPlaying() }
  else if ( this.rewinding ) { this.resetRewinding() }
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
replay(){
  this.obj.playbackRate += 0.2
  this.playing || this.play()
}
// Pour accéler le rewind à chaque impulsion (appel)
rerewind(){
  this.stopRewind() // même si ça ne joue pas encore
  this.rewindRate -= 2
  this.rewind()
}

/**
* Pour avancer ou reculer d'un "cran"
Par défaut, on avance d'une frame (25 par secondes)
Mais avec des modifieurs :
  - maj:      avance par seconde
  - command   avance par dizaine de secondes
***/
avance(ev){
  console.log("-> avance (time = %f)", this.time)
  const nt = this.calcPas(this.time, ev, 1)
  console.log("Temps retourné à avance : ", nt, typeof(nt))
  this.time = nt
  console.log("Temps fin vidéo dans avance = ", this.time)
}
recule(ev){
  console.log("-> recule (time = %f)", this.time)
  this.time = this.calcPas(this.time, ev, -1)
  console.log("Temps fin recule = ", this.time)
}
calcPas(t, ev, factor){
  var p
  if ( ev.shiftKey )      p = 10
  else if ( ev.metaKey )  p = 1
  else                    p = 1 / 25
  t += p * factor
  console.log("Nouveau t = %f (p = %f)", t, p)
  console.log("this.time = ", parseFloat(this.time, 10))
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

get time(){ return parseFloat(Number.parseFloat(this.obj.currentTime).toPrecision(3)) }
set time(v){
  if ( 'string' == typeof(v) ) v = parseFloat(v) // peut être un string
  if ( v <= this.obj.duration ) {
    console.log("Temps appliqué à la vidéo : ", v, typeof(v))
    this.obj.currentTime = v
  } else {
    error(`Le temps ${t2h(v)} dépasse la durée du film.`, {keep:false})
  }
}

// Méthode pour informer que la vidéo est prête
setReady(){
  this.onTimeChange(null) // pour régler l'horloge
  message(`La vidéo ${this.id} est prête.`)
}
observe(){
  this.obj.addEventListener('click', this.onClick.bind(this))
  this.obj.addEventListener('mouseover', this.onMouseOver.bind(this))
  this.obj.addEventListener('mouseout',  this.onMouseOut.bind(this))
  this.obj.addEventListener('mousemove', this.onMouseMove.bind(this))
  this.obj.addEventListener('timeupdate', this.onTimeChange.bind(this))
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

onTimeChange(ev){
  this.horloge.set(this.time)
}
get horloge(){
  return this._horloge || (this._horloge = new Horloge(this))
}
onMouseMove(ev){
  if (!this.isMouseSensible) return stopEvent(ev)
  if ( ! this.frozen ) {
    this.time = this.px2time(ev.offsetX)
    this.moving = true
  }
}
onMouseOut(ev){
  if (!this.isMouseSensible) return stopEvent(ev)
  this.moving = false
  this.frozen = false
  this.obj.removeEventListener('keydown', this.onKey.bind(this))
}
/**
* Méthode appelée quand on passe la souris sur la vidéo. Ça active
* les raccourcis propres à la vidéo
***/
onMouseOver(ev){
  if (!this.isMouseSensible) return stopEvent(ev)
  this.obj.addEventListener('keydown', this.onKey.bind(this))
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

onClick(){
  if ( this.isMouseSensible ) {
    if ( this.frozen ) {
      this.frozen = false
      message("J'ai dégelé la vidéo, tu peux déplacer la souris pour chercher un temps", {keep:false})
    } else {
      this.frozen = true
      message("J'ai gelé la vidéo pour choisir ce temps.", {keep:false})
    }
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
  Pour aller à un temps précis (sert à la console)
  +s+   Peut être un nombre de secondes ou une horloge h:m:s.f
*/
goto(s){
  this.time = s.match(/[:\.]/) ? h2t(s) : parseFloat(s)
}

setWidth(w){
  // console.log("Je dois avancer de ", frames)
  this.obj.style.width = px(w)
}

}// DOMVideo
