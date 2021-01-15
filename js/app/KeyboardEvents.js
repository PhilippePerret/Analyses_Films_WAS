'use strict'

/**
* Pour changer de mode clavier
***/
function setModeClavier(mode){
  window.modeClavier = mode
  switch(mode){
    case 'command':
      window.onkeydown = window.gestionKeyDown.bind(window)
      break
    case 'text':
      window.onkeydown = window.gestionnaireTouchesFormField.bind(window)
      break
    case 'select':
      window.onkeydown = window.gestionnaireTouchesFormField.bind(window)
      break
    default: return error("Le mode clavier "+mode+" est inconnu…")
  }
  DGet('#mode-clavier').textContent = `mode clavier : ${mode}`
}

function gestionnaireTouchesFormField(ev){
  if ( ev.key == 'Escape' ){
    document.activeElement.blur()
    return stopEvent(ev)
  } else {
    return true
  }
}
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
        case 'k': Controller.toggle();break
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
    case ' ': DOMVideo.current.togglePlay();break
    case 'l': DOMVideo.current.replay(ev); break
    case 'k': DOMVideo.current.pause(); break
    case 'j': DOMVideo.current.rerewind(ev); break
    case 'c': DOMVideo.synchronizeVideos();break
    case 'x': focusIn(DGet('#console'));break
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
        case 's': AEvent.listing.onSaveButton({});break
        case 'u': AEvent.current.updateTime(undefined);break
        case 't': AEvent.focusTexte();break
        case 'i': AEvent.initForm();break
        case 'Backspace': AEvent.current.destroy();break
        case 'ArrowDown': AEvent.selectNext();break
        case 'ArrowUp': AEvent.selectPrevious();break
        default: return
      }
    } else {
      /* Si aucun évènement n'est sélectionné */
      switch(ev.key){
        case 's': AEvent.listing.onSaveButton(null);break
        case 't': AEvent.focusTexte();break
        case 'i': AEvent.initForm();break
        case 'ArrowDown': AEvent.selectFirst();break
        case 'ArrowUp': AEvent.selectLast();break
        default: return
      }
    }
    return true
  } // si aucune touche modificatrice
}

/**
* Le gestion des touches quand on est en dehors d'un champ de texte
***/
window.gestionKeyDown = function(ev){
  // console.log("ev.key = '%s'", ev.key)
  if ( gestionnaireTouchesController(ev) ) return stopEvent(ev)
  // console.log("Je poursuis après touches controller")
  if ( gestionnaireTouchesEditeurEvents(ev) ) return stopEvent(ev)
  // console.log("Je poursuis après touches éditeur")

  // console.log("-> onkeydown (%s)", ev.key)
  if (ev.metaKey){
    if(ev.shiftKey){
      if(ev.altKey){ // Cmd + MAJ + ALT
        switch(ev.key){
          case 'Æ': Aide.editManuel(); break
        }
      } else { // juste Cmd + MAJ
        switch(ev.key){
          case 'a': Aide.toggle(); break
        }
      }
    } else {
      switch(ev.key){
        case 'a': Aide.openPDF(); break
      }
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
// Note : le onkeydown ne sera affecté que lorsque les vidéos seront chargées
// window.onkeydown  = window.gestionKeyDown.bind(window)
window.onkeyup    = window.gestionKeyUp.bind(window)

window.onresize = function(){UI.setBody()}
