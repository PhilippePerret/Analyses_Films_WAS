'use strict'

window.gestionKeyDown = function(ev){
  // console.log("-> onkeydown (%s)", ev.key)
  if (ev.metaKey){
    switch(ev.key){
      case 'È':
        if (ev.altKey) Aide.toggleControllerShortcuts() // Alt+Cmd+k
        break
      case 'k':
        Controller.toggle()
        break
      case 'a':
        Aide.toggle()
        break
      default: console.log("ev.key = '%s'", ev.key)
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
