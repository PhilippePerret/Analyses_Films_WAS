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
    , video2_width:{condition_prop:'video2', condition_value:true, question:'Taille du second retour', default:400}
    , as_current:{question:'Dois-je la mettre en analyse courante ?'}
  }

  // On demande toutes les données pour le films
  const data = AskTor.submit(h)

  // === Pour les essais ===
  // const data = {
  //   title: "Arrival", folder: "Arrival",
  //   video_path:"/Volumes/BackupPlusDrive/AnalyseFilms-videos/Arrival_720p-subtitles.mp4",
  //   video_width:"600", video2:true, video2_with:'400',
  //   as_current: true
  // }
  // ==== /fin pour les essais ===

  if ( data /* si pas annulé */) {
    message("Je crée la nouvelle analyse, merci de patienter (notamment pour la copie de la vidéo)…", {keep:false})
    Ajax.send('create_film.rb', {data:data})
    .then(ret => {
      message("Film créé avec succès.")
      if ( data.as_current.value == true ) {
        alert("Je vais recharger la page pour mettre le nouveau film en film courant.")
        window.location.reload()
      }
    })
  } else {
    message("Création annulée.")
  }
}
}

class AskTor {
/** ---------------------------------------------------------------------
*   CLASSE
*
*** --------------------------------------------------------------------- */

/**
* Reçoit la table des requêtes
* Retourne la table des données
***/
static submit(request){
  for(var i in request){
    request[i].value = request[i].default = new AskTor(i, request).submit()
    if ( request[i].value === undefined ) return null
  }
  if ( AskTor.confirm(request) ) {
    var data = {}
    for(i in request){Object.assign(data, {[i]: request[i].value})}
    return data
  } else {
    return this.submit(request)
  }
}

/**
* Pour confirmer les valeurs
***/
static confirm(request){
  var msg = []
  for(var k in request){msg.push(`${k} = ${request[k].value}`)}
  msg.push('')
  msg.push('Confirmez-vous ces informations ?')
  return confirm(msg.join("\n"))
}

/** ---------------------------------------------------------------------
*
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(key, data) {
  this.key = key
  this.keyData = data[key]
  this.allData = data
}

/**
* On pose la question
***/
submit(){
  if (this.isConditionnal && !this.conditionIsOK) return null
  var res, msg = `${this.question}`
  if ( this.isBoolean ) {
    res = confirm(this.question)
  } else {
    while ( this.isMandatory && !res ) {
      res = prompt(msg, this.default)
      if ( res === null ) { // Annulation
        return undefined
      } else if (res && res.trim() != ''){
        res = res.trim()
      } else {
        res = null
        if (this.isMandatory) {
          msg = `RÉPONSE INDISPENSABLE\n\n${this.question}`
        }
      }
    }
  }
  return res
}


get question(){ return this._question || (this._question = this.keyData.question.trim()) }
get default(){ return this.keyData.default }
get isBoolean(){return this._isbool || (this._isbool = this.question.substr(this.question.length-1,1) == '?')}
get isMandatory(){return !(this.keyData.required === false)}
get isConditionnal(){return this.keyData.condition_prop}
get conditionIsOK(){
  return this.allData[this.keyData.condition_prop].value === this.keyData.condition_value
}

}// class AskTor
