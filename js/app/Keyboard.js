'use strict'

window.onkeydown = function(ev){
  // console.log("-> onkeydown (%s)", ev.key)
  if ( ev.altKey ) {
    if ( ev.key == '¬') {
      video.togglePlay()
      return stopEvent(ev)
    } else if ( ev.key == 'È' ) {
      video.stop()
      return stopEvent(ev)
    }
  }
}
window.onkeyup = function(ev){
  // console.log("-> onkeyup")
  ev.stopImmediatePropagation()
  return stopEvent(ev)
}
