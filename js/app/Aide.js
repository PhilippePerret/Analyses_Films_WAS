'use strict'
/***
* Classe Aide
------------
Pour affichage de tout ce qui concerne l'aide, et principalement les messages
"transparents"
***/
class Aide {
// Ouvrir le fichier PDF dans une autre fenêtre/signet
static openPDF(){
  window.open("./_dev_/Manuel/Manuel_utilisateur.pdf", "manuel-analyseur-de-film")
  message("Le manuel d'utilisation est ouvert.", {keep:false})
}
// Pour modifier le mode d'emploi
static editManuel(){
  message("J'ouvre le manuel en édition…")
  return Ajax.send('open_manuel.rb', {mode:'edit'})
  .then(ret => {
    message("Manuel ouvert en édition.", {keep:false})
  })
}
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
        {content: this.img('A',{cmd:true})+'pour ouvrir le manuel d’utilisation dans une autre fenêtre'}
      , {content: this.img('K',{cmd:true})+'pour afficher/masquer le contrôleur de vidéo'}
      , {content: this.img('K',{alt:true,cmd:true})+'pour afficher/masquer les raccourcis du contrôleur'}
      , {content: 'Déplacer la souris sur la vidéo pour choisir le temps (puis clic pour la figer)'}
      , {content: '<span class="key">⇧</span><span class="key">⌘</span><span class="key">a</span> pour afficher/masquer cette aide flottante'}
      , {content: 'On peut rejoindre facilement les 9 premiers signets à l’aide des touches 1 à 9'}
      , {content: 'Pour obtenir une seconde vidéo du film, il suffit de définir :video2 dans la configuration du film.'}
      , {content: 'Pour créer un signet, ouvrir le contôleur (<span class="key">⌘</span><span class="key">k</span>) et l’ajouter.'}
      , {content: 'Pour sortir d’un champ de texte ou d’un select (=> raccourcis généraux), presser la touche ESCAPE.'}
      , {content: '<span class="key">R</span> pour afficher/masquer les repères du PFA abslu.'}
      , {content: 'Jouer la commande <code>pfa build</code> pour construire le PFA du film.'}
      , {content: this.img('Entree')+' pour mettre l’évènement d’analyse sélectionné en édition séparée.'}
      , {content: this.img('P')+'pour afficher/masquer la liste des personnages'}
    ]
  } return this._messages
}

static img(name, modifiers = {}){
  var imgs = []
  modifiers.maj   && imgs.push(this.pathImage('Maj', true))
  modifiers.ctrl  && imgs.push(this.pathImage('Ctrl', true))
  modifiers.alt   && imgs.push(this.pathImage('Alt', true))
  modifiers.cmd   && imgs.push(this.pathImage('Command', true))
  imgs.push(this.pathImage(name))
  return imgs.join('')
}
static pathImage(name, isModifier){
  return `<img src="_dev_/Manuel/img/clavier/K_${name}.png" class="${isModifier?'modifier':''}" alt="${name}"/>`
}

}//Aide
