'use strict'
/** ---------------------------------------------------------------------
*   Class Video
*   -----------
    Pour la commande de la vidéo
*** --------------------------------------------------------------------- */
class DOMVideo {
constructor(obj, src) {
  this.obj = obj
  this.src = src
  this.init()
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
  this.time = this.calcPas(this.time, ev, 1)
}
recule(ev){
  this.time = this.calcPas(this.time, ev, -1)
}
calcPas(t, ev, factor){
  console.log("t = ", t)
  var p
  if ( ev.shiftKey )      p = 1
  else if ( ev.metaKey )  p = 10
  else                    p = 1 / 25
  return (t + (p * factor) )
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
  v = parseFloat(v) // peut être un string
  if ( v <= this.obj.duration ) {
    this.obj.currentTime = v
  } else {
    error(`Le temps ${t2h(v)} (${v}) dépasse la durée du film.`)
  }
}

// Méthode pour informer que la vidéo est prête
setReady(){
  this.onTimeChange(null) // pour régler l'horloge
  message("La vidéo est prête.")
}
observe(){
  this.obj.addEventListener('click', this.onClick.bind(this))
  this.obj.addEventListener('mouseover', this.onMouseOver.bind(this))
  this.obj.addEventListener('mouseout', this.onMouseOut.bind(this))
  this.obj.addEventListener('mousemove', this.onMouseMove.bind(this))
  this.obj.addEventListener('timeupdate', this.onTimeChange.bind(this))
}

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
  Horloge.set(this.time)
}
onMouseMove(ev){
  if ( ! this.frozen ) {
    this.time = this.px2time(ev.offsetX)
    this.moving = true
  }
}
onMouseOut(ev){
  this.moving = false
  this.frozen = false
  this.obj.removeEventListener('keydown', this.onKey.bind(this))
}
/**
* Méthode appelée quand on passe la souris sur la vidéo. Ça active
* les raccourcis propres à la vidéo
***/
onMouseOver(ev){
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
  if ( this.frozen ) {
    this.frozen = false
    message("J'ai dégelé la vidéo, tu peux déplacer la souris pour chercher un temps")
  } else {
    this.frozen = true
    message("J'ai gelé la vidéo pour choisir ce temps.")
  }
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
  console.log("Je dois avancer de ", frames)
  this.obj.style.width = px(w)
}

}
