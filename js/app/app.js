'use strict';

class App {

  // Quand la page est chargée
  static init(){
    return new Promise((ok,ko) => {
      // console.log("Initialisation en cours…")
      Aide.runAide()
      UI.init()
      Options.init()
      Locators.init()
      Console.init()
      Controller.init()
      AEvent.init()
      AEventEditor.init()
      AEvent.onActivate() // pour mettre le focus
      ok()
    })
  }

  /**
  * Méthode appelée quand on quitte le film ou l'application
  ***/
  static onQuit(ev){
    return true
  }

  static setVeryReady(){
    UI.endInit()
    window.setModeClavier('command')

    // Sélection du dernier évènement sélectionné
    // Note : il faut le faire avant le réglage du dernier temps mémorisé, car
    // ce temps a pu être défini après la sélection du dernier évènement
    if ( film.config.last_selected_event ) {
        const aev = AEvent.get(film.config.last_selected_event)
        aev && aev.select()
    }
    // setTimeout(AEventEditor.edit.bind(AEventEditor, AEvent.get(10)), 2*1000)
    Options._('memorize_last_time') && film.config.last_time && (DOMVideo.current.time = film.config.last_time)
    message("Nous sommes prêts.", {keep:false})
  }
}

window.addEventListener('unload', App.onQuit.bind(App))
