'use strict';

class App {

  // Quand la page est chargée
  static init(){
    return new Promise((ok,ko) => {
      console.log("Initialisation en cours…")
      Aide.runAide()
      UI.init()
      Locators.init()
      Console.init()
      Controller.init()
      AEvent.init()
      ok()
    })
  }

  static setVeryReady(){
    UI.endInit()
    window.setModeClavier('command')
    message("Nous sommes prêts.", {keep:false})
  }
}
