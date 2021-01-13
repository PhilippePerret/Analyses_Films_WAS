'use strict'

function gestionnaireTouchesController(ev){
  if ( ev.metaKey ) {
    if ( ev.altKey ) {
      switch(ev.key){
        case 'È': Aide.toggleControllerShortcuts(); break
        default: return ev
      }
    } else {
      switch(ev.key){
        case 'k':Controller.toggle();break
        case 'ArrowRight':  DOMVideo.current.avance(ev); break
        case 'ArrowLeft':   DOMVideo.current.recule(ev); break
        default: return ev
      }
    }
    return stopEvent(ev)
  }
  // Les touches seules
  switch(ev.key){
    case 'l': DOMVideo.current.replay(); break;
    case 'k': DOMVideo.current.pause(); break;
    case 'j': DOMVideo.current.rerewind(); break;
    case 'ArrowRight':  DOMVideo.current.avance(ev); break
    case 'ArrowLeft':   DOMVideo.current.recule(ev); break
    case 'ArrowUp':   Locators.gotoSignet('prev'); stopEvent(ev); break
    case 'ArrowDown': Locators.gotoSignet('next'); stopEvent(ev); break
    case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8':
    case '9': Locators.gotoSignet(Number(ev.key) - 1);break
    default:
      console.log("key = '%s'", ev.key)
      return ev
  }
  return stopEvent(ev)
}

/**
* Le gestion des touches quand on est en dehors d'un champ de texte
***/
window.gestionKeyDown = function(ev){
  ev = gestionnaireTouchesController(ev)
  if ( ! ev ) return
  // console.log("-> onkeydown (%s)", ev.key)
  if (ev.metaKey){
    switch(ev.key){
      case 'È':
        if (ev.altKey) Aide.toggleControllerShortcuts() // Alt+Cmd+k
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
