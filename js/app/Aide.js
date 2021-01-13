'use strict'
/***
* Classe Aide
------------
Pour affichage de tout ce qui concerne l'aide, et principalement les messages
"transparents"
***/
class Aide {
// Méthode qui lance la boucle sur les messages d'aide pour les afficher
// régulièrement.
static runAide(){
  this.aideTimer = setInterval(this.showNextAide.bind(this), 10*1000)
}
static stopAide(){
  if(this.aideTimer){
    clearInterval(this.aideTimer)
    this.aideTimer = null
  }
}
static showNextAide(){
  if (undefined == this.idxAide) this.idxAide = 0
  else ++ this.idxAide
  if (this.idxAide >= this.messagesCount) this.idxAide = 0
  const idx = this.idxAide < 5 ? this.idxAide : Math.floor(Math.random() * Math.floor(messagesCount))
  new this(this.MESSAGES[idx]).show()
}
static get messagesCount(){
  return this._msgcount || ( this._msgcount = this.MESSAGES.length )
}
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
      , {content: '<span class="key">⌘</span><span class="key">a</span> pour afficher/masquer les raccourcis du contrôleur'}
      , {content: 'Déplacer la souris sur la vidéo pour choisir le temps (puis click pour la figer)'}
      , {content: 'Troisième aide'}
      , {content: 'Quatrième aide'}
      , {content: 'Cinquième aide'}
      , {content: 'Sixième aide'}
    ]
  }return this._messages
}
}
