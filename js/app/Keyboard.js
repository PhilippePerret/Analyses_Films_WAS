'use strict'

window.gestionKeyDown = function(ev){
  // console.log("-> onkeydown (%s)", ev.key)
  if (ev.metaKey){
    switch(ev.key){
      case 'k':
        if (ev.altKey) Aide.toggleControllerShortcuts()
        else Controller.toggle()
        break
      case 'h':
        Aide.toggle()
        break
    }
    return stopEvent(ev)
  }
}
window.gestionKeyUp = function(ev){
  // console.log("-> onkeyup")
  return stopEvent(ev)
}

// Pour pouvoir les désactiver et les remettre
window.onkeydown  = window.gestionKeyDown.bind(window)
window.onkeyup    = window.gestionKeyUp.bind(window)

window.onresize = function(){UI.setBody()}
