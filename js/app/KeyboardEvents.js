'use strict'

/**
* Gestionnaire des touches qui concerne le contrôleur de vidéo
***/
function gestionnaireTouchesController(ev){
  if ( ev.metaKey ) {
    if ( ev.altKey ) {
      switch(ev.key){
        case 'È': Aide.toggleControllerShortcuts(); break
        default: return
      }
    } else {
      switch(ev.key){
        case 'k':Controller.toggle();break
        case 'ArrowRight':  DOMVideo.current.avance(ev); break
        case 'ArrowLeft':   DOMVideo.current.recule(ev); break
        case 'ArrowUp':     Locators.gotoSignet('prev'); stopEvent(ev); break
        case 'ArrowDown':   Locators.gotoSignet('next'); stopEvent(ev); break
        default: return
      }
    }
    return true // traité
  }
  // Les touches seules
  switch(ev.key){
    case 'l': DOMVideo.current.replay(); break;
    case 'k': DOMVideo.current.pause(); break;
    case 'j': DOMVideo.current.rerewind(); break;
    case 'ArrowRight':  DOMVideo.current.avance(ev); break
    case 'ArrowLeft':   DOMVideo.current.recule(ev); break
    case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8':
    case '9': Locators.gotoSignet(Number(ev.key) - 1);break
    default: return
  }
  return true
}

/**
* Gestion des touches qui concernent l'éditeur d'évènement
* Traite la touche est renvoie false ou renvoie l'évènement.
***/
function gestionnaireTouchesEditeurEvents(ev){
  if (!ev.metaKey && !ev.altKey && !ev.shiftKey){
    if ( AEvent.current ) {
      /* Si un évènement est sélectionné */
      switch(ev.key){
        case 's': AEvent.current.save();break
        case 'u': AEvent.current.updateTime(undefined);break
        case 't': AEvent.focusTexte();break
        case 'i': AEvent.initForm();break
        case 'ArrowDown': AEvent.selectNext();break
        case 'ArrowUp': AEvent.selectPrevious();break
        default: return
      }
    } else {
      /* Si aucun évènement n'est sélectionné */
      switch(ev.key){
        case 't': AEvent.focusTexte();break
        case 'i': AEvent.initForm();break
        case 'ArrowDown': AEvent.selectFirst();break
        case 'ArrowUp': AEvent.selectLast();break
        default: return
      }
    }
  }
  return true
}

/**
* Le gestion des touches quand on est en dehors d'un champ de texte
***/
window.gestionKeyDown = function(ev){
  if ( gestionnaireTouchesController(ev) ) return stopEvent(ev)

  if ( gestionnaireTouchesEditeurEvents(ev) ) return stopEvent(ev)

  // console.log("-> onkeydown (%s)", ev.key)
  if (ev.metaKey){
    switch(ev.key){
      case 'È':
        if (ev.altKey) Aide.toggleControllerShortcuts() // Alt+Cmd+k
        break
      case 'a': Aide.toggle(); break
    }
    return stopEvent(ev)
  }

  // Si non traité
  // console.log("key = '%s'", ev.key)

}
window.gestionKeyUp = function(ev){
  // console.log("-> onkeyup")
  return stopEvent(ev)
}

// Pour pouvoir les désactiver et les remettre
window.onkeydown  = window.gestionKeyDown.bind(window)
window.onkeyup    = window.gestionKeyUp.bind(window)

window.onresize = function(){UI.setBody()}
