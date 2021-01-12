'use strict';

class App {

  // Quand la page est chargée
  static init(){
    return new Promise((ok,ko) => {
      console.log("Initialisation en cours…")
      UI.init()
      Locators.init()
      Console.init()
      Controller.init()
      AEvent.init()
      UI.endInit()
      ok()
    })
  }

  // Quand tout est prêt
  static start(){
    // console.clear()
    console.log("On peut commencer !")
    // Pour lancer des procédures directement au cours de l'implémentation

    // Pour essai du code ruby (_scripts_/_essai_.rb)
    // UI.run_script_essai()
  }

}