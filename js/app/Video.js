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
  this.obj.play()
  this.playing = true
}
pause(){
  this.obj.pause()
  this.playing = false
}

init(){
  const my = this
  this.obj.src = this.src
  this.obj.load()
  $(this.obj).on('canplaythrough', (res) => {
    my.calcValues()
    my.observe()
    my.setReady()
  })
}

// Méthode pour informer que la vidéo est prête
setReady(){
  message("La vidéo est prête.")
}
observe(){
  this.obj.addEventListener('click', this.onClick.bind(this))
  this.obj.addEventListener('mousemove', this.onMouseMove.bind(this))
}

/**
* Méthode calculant les valeurs après le chargement de la vidéo, et notamment
* le rapport px/temps
***/
calcValues(){
  this.timeRatio = $(this.obj).width() / this.obj.duration
  console.info("this.timeRatio = ", this.timeRatio)
}
px2time(px){ return px / this.timeRatio}
time2px(time){ return parseInt(time * this.timeRatio, 10)}

onMouseMove(ev){
  if ( ! this.frozen ) {
    this.setTime(this.px2time(ev.offsetX))
    this.moving = true
  }
}
onMouseOut(ev){
  this.moving = false
  this.frozen = false
}
onClick(){
  if ( this.frozen ) {
    this.frozen = false
    message("J'ai dégelé la vidéo, tu peux déplacer la souris pour chercher un temps")
  } else {
    this.frozen = true
    message("J'ai gelé la vidéo pour choisir ce temps. Tu peux affiner avec les flèches")
  }
}

setTime(time){
  this.obj.currentTime = time
}
setWidth(w){
  this.obj.style.width = px(w)
}

}
