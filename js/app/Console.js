'use strict'
/** ---------------------------------------------------------------------
*   Class Console
*   -------------
    Gestion de la console qui permet de tout commander en ligne
*** --------------------------------------------------------------------- */
class Console {
static run(){
  new Console(this.obj.value).run()
}
static init(){
  this.obj.addEventListener('keypress', this.onKey.bind(this))
}
static onKey(ev){
  if ( ev.key == 'Enter') this.run()
}
static get obj(){return this._obj || (this._obj = DGet('input#console'))}

/** ---------------------------------------------------------------------
  *   INSTANCE (UNE COMMANDE)
  *
*** --------------------------------------------------------------------- */
constructor(code){
  this.code = code
}
/**
* = main =
Méthode qui joue le code
***/
run(){
  message(`Je joue le code '${this.code}'`, {keep:false})
  this.parse()
  switch(this.command){
    case 'rewind':
    case 'back':
    case '-' :
    case 'backward':  return DOMVideo.current.backward(this.params[1])
    case 'for':
    case '+':
    case 'forward':   return DOMVideo.current.forward(this.params[1])
    case 'goto':      return DOMVideo.current.goto(this.params[1])
    default:
      erreur(`Je ne connais pas la commande “${this.command}”`)
  }
}

/**
* Méthode pour "parser" le code de la console, i.e. l'analyser pour pouvoir
le jouer
***/
parse(){
  this.params = this.code.split(' ')
  console.log("This.params:", this.params)
  this.command = this.params[0]
}

/** ---------------------------------------------------------------------
*   LES COMMANDES
*
*** --------------------------------------------------------------------- */

}
