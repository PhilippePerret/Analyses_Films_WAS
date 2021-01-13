'use strict'
/** ---------------------------------------------------------------------
*   Class Horloge
*
*** --------------------------------------------------------------------- */
class Horloge {
/** ---------------------------------------------------------------------
*   L'horloge en tant qu'objet DOM
*
*** --------------------------------------------------------------------- */
constructor(video){
  this.video = video
}
set(time){
  this.objCurrentTime.textContent = s2h(time)
}

get objCurrentTime(){
  return this._ocurtime || (this._ocurtime = this.obj.querySelector('.current_time'))
}
get obj(){
  return this._obj || (this._obj = this.video.container.querySelector('.horloge'))
}
}// Class Horloge
