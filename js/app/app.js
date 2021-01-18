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
      AEventEditor.init()
      AEvent.onActivate() // pour mettre le focus
      ok()
    })
  }

  static setVeryReady(){
    UI.endInit()
    window.setModeClavier('command')
    // setTimeout(AEventEditor.edit.bind(AEventEditor, AEvent.get(10)), 2*1000)
    message("Nous sommes prêts.", {keep:false})
  }
}
