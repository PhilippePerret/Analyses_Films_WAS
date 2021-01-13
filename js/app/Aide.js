'use strict'
/***
* Classe Aide
------------
Pour affichage de tout ce qui concerne l'aide, et principalement les messages
"transparents"
***/
class Aide {
// Lancer/arrêter l'aide
static toggle(){
  if (this.running) this.stopAide()
  else this.runAide()
}
// Méthode qui lance la boucle sur les messages d'aide pour les afficher
// régulièrement.
static runAide(){
  this.running = true
  this.aideTimer = setInterval(this.showNextAide.bind(this), 10*1000)
  this.showNextAide()//tout de suite
}
// Pour arrêter la boucle sur l'aide si elle est en route
static stopAide(){
  if(this.aideTimer){
    clearInterval(this.aideTimer)
    this.aideTimer = null
  }
  this.cleanUp()
  this.running = false
}
// Pour afficher le message d'aide suivante
static showNextAide(){
  if (undefined == this.idxAide) this.idxAide = 0
  else ++ this.idxAide
  if (this.idxAide >= this.messagesCount) this.idxAide = 0
  const idx = this.idxAide < 5 ? this.idxAide : getRandom(this.messagesCount))
  new this(this.MESSAGES[idx]).show()
}
// Pour afficher/masquer les raccourcis pour le contrôleur
static toggleControllerShortcuts(){
  this.cleanUp()
  UI.insert('controller_shortcuts', this.obj)
}

static cleanUp(){this.obj.textContent = ''}

static get messagesCount(){
  return this._msgcount || ( this._msgcount = this.MESSAGES.length )
}
// L'objet contenant le message flottant
static get obj(){
  return this._obj||(this._obj = DGet("div#floating-aide"))
}

/** ---------------------------------------------------------------------
* INSTANCE
***/
constructor(data) {
  this.data = data
}
show(){
  this.constructor.obj.textContent = ''
  this.constructor.obj.appendChild(this.build())
}
build(){
  return DCreate('DIV', {class:'floating-message', text: this.data.content})
}

static get MESSAGES(){
  if ( undefined == this._messages){
    this._messages = [
        {content: '<span class="key">⌘</span><span class="key">k</span> pour afficher/masquer le contrôleur de vidéo'}
      , {content: '<span class="key">⌘</span><span class="key">⌥</span><span class="key">k</span> (“help”) pour afficher/masquer les raccourcis du contrôleur'}
      , {content: 'Déplacer la souris 🖱 sur la vidéo pour choisir le temps (puis click pour la figer)'}
      , {content: '<span class="key">⌘</span><span class="key">h</span> pour afficher/masquer cette aide'}
      , {content: 'Quatrième aide'}
      , {content: 'Cinquième aide'}
      , {content: 'Sixième aide'}
    ]
  }return this._messages
}
}
