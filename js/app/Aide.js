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
  const idx = this.idxAide < 5 ? this.idxAide : getRandom(this.messagesCount)
  new this(this.MESSAGES[idx]).show()
}
// Pour afficher/masquer les raccourcis pour le contrôleur
static toggleControllerShortcuts(){
  if ( this.running ){
    this.stopAide()
    UI.insert('controller_shortcuts', this.obj)
  } else {
    this.runAide()
  }
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
      , {content: '<span class="key">⌘</span><span class="key">⌥</span><span class="key">k</span> pour afficher/masquer les raccourcis du contrôleur'}
      , {content: 'Déplacer la souris sur la vidéo pour choisir le temps (puis clic pour la figer)'}
      , {content: '<span class="key">⌘</span><span class="key">a</span> pour afficher/masquer cette aide'}
      , {content: 'Quand le contrôleur est ouvert (<span class="key">⌘</span><span class="key">k</span>), on peut rejoindre facilement les 9 premiers signets à l’aide des touches 1 à 9'}
      , {content: 'Pour obtenir une seconde vidéo du film, il suffit de définir :video2 dans la configuration du film.'}
      , {content: 'Sixième aide'}
    ]
  }return this._messages
}
}
