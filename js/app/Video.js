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
  this.obj.src = this.src
  this.obj.load()
  $(this.obj).on('canplaythrough', (res) => {
    console.info("La vidéo est prête")
    this.obj.addEventListener('click', this.togglePlay.bind(this))
  })
}

setWidth(w){
  this.obj.style.width = px(w)
}

}
