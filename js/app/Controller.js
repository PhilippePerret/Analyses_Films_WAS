'use strict';
/** ---------------------------------------------------------------------
*   Class Controller
    ----------------
    Pour le contrôle de la vidéo

    En bas de ce module est défini : window.controller = new Controller()
*** --------------------------------------------------------------------- */
class Controller {
static init(){
  // Pour forcer l'affichage du listing des locateurs
  Locators.listing
}
static toggle(){
  if(this.isOpened){ this.close() }
  else { this.open() }
}
static open(){
  this.container.classList.remove('hidden')
  this.activateGestionClavier()
  this.isOpened = true
}
static close(){
  this.container.classList.add('hidden')
  this.desactivateGestionClavier()
  this.isOpened = false
}

// Méthode qui active la gestion du clavier pour le contrôleur
static activateGestionClavier(){
  window.onkeydown  = this.onKeyDown.bind(this)
  window.onkeyup    = this.onKeyUp.bind(this)
}
static desactivateGestionClavier(){
  window.onkeydown = window.gestionKeyDown.bind(window)
  window.onkeyup   = window.gestionKeyUp.bind(window)
}

static onKeyDown(ev){
  gestionnaireTouchesController(ev)
}
static onKeyUp(ev){

  return stopEvent(ev)
}

static get obj(){return this._obj||(this._obj = DGet('div#controller'))}
static get container(){return this._cont||(this._cont = DGet('div#controller-container'))}
}//Controller
