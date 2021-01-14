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
  this.isOpened = true
}
static close(){
  this.container.classList.add('hidden')
  this.isOpened = false
}

static get obj(){return this._obj||(this._obj = DGet('div#controller'))}
static get container(){return this._cont||(this._cont = DGet('div#controller-container'))}
}//Controller
