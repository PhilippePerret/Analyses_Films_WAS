'use strict';
/** ---------------------------------------------------------------------
*   Class HorlogeMini
    -----------------
    Gestion des minihorloges pour les vidéos

Note : elles servent lorsque la vidéo n'est pas sensible au déplacement
de la souris.
*** --------------------------------------------------------------------- */
class HorlogeMini {
constructor(vid) {
  this.video = vid
}
show(time){
  this.built || this.build()
  this.obj.classList.remove('hidden')
  this.content = s2h(time)
}
hide(){
  this.obj && this.obj.classList.add('hidden')
}

build(){
  this.obj = DCreate('DIV', {class:'mini-horloge-container', inner:[
    DCreate('SPAN',{class:'time'})
  ]})
  this.video.container.appendChild(this.obj)
  this.built = true
}

set content(t){
  this.objContent.textContent = t
}

get objContent(){
  return this._objcontent || (this._objcontent = DGet('.time', this.obj))
}

}
