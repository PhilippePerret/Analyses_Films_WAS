'use strict'

class FilmCreator {
/** ---------------------------------------------------------------------
  *
  *   CLASSE
  *
*** --------------------------------------------------------------------- */

/**
* Pour la création d'une nouvelle analyse de film

Les choses à demander :
  - le titre du film
  - le nom du dossier (sans espace)
  - Path de la vidéo (pour la copier dans le dossier + mettre le nom)
  - Taille de la vidéo (600)
  - Y a-t-il une seconde vidéo ?
  - Taille de la 2nde vidéo (si 2nde vidéo)
  - Faut-il la mettre en analyse courante ?
    => recharger la page si oui
***/
static createNew(name){
  const h = {
      title: {question:'Titre original du film'}
    , folder: {question:'Nom du dossier (pas d’espace, caractères ASCII)', default:''}
    , video_path: {question:'Chemin complet à la vidéo (pour copie)'}
    , video_width: {question:'Taille du retour vidéo', default:600}
    , video2: {question:'Y aura-t-il deux retours vidéo ?'}
    , video2_width:{condition:'video2', value:false, question:'Taille du second retour', default:400}
    , as_current:{question:'Dois-je la mettre en analyse courante ?'}
  }
  for(var i in h){
    const request = new AskTor(i, h)
  }
  message("Nous allons créer une nouvelle analyse de film.")
}
}

class AskTor {
constructor(key, data) {
  this.key = key
  this.data =
  this.keyData = data[key]
}

/**
* On pose la question
***/
submit(){
  var res
  if ( this.isBoolean ) {
    res = confirm(this.question)
  } else {
    res = prompt(this.question, this.default)
  }
}


get question(){ return this.keyData.question }
get default(){ return this.keyData.default }
get isBoolean(){return this._isbool || (this._isbool = this.question.substring(this.question.length-1,1) == '?')}
}// class AskTor
