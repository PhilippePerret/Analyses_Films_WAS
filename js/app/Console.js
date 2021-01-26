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
  this.parse()
  switch(this.command){
    case 'filtre': case 'filter': return AEvent.runFiltreCommand(this.params)
    case'aide':case'manuel':case'help': return this.run_open_command('aide')
    case 'options':   return Options.togglePanel()
    case 'open':      return this.run_open_command(this.params[1], this.params[2])
    case 'build':     return this.run_build_command(this.params[1], this.params[2], this.params[3])
    case 'pfa':       return this.run_pfa_command(this.params[1])
    case 'goto':      return DOMVideo.current.goto(this.params[1], this.params[2])
    case 'create':    return this.run_create_command(this.params[1], this.params[2])
    case 'update': case 'reload': return film.update()
    case 'draw':      return DOMVideo.current.draw(this.params[1])
    case 'erase':     return DOMVideo.current.erase(this.params[1])
    case 'set':       return this.run_set_command(this.params[1], this.params[2])
    case 'rewind': case 'back': case '-' : case 'backward':  return DOMVideo.current.backward(this.params[1])
    case 'for': case '+': case 'forward':   return DOMVideo.current.forward(this.params[1])
    case 'essai': return this.run_essai()
    default:
      erreur(`Je ne connais pas la commande “${this.command}”`)
  }
}

run_essai(){
  // Je lance des tests pour connaitre le rapport entre le rate et la vitesse
  const param1 = this.params[1]
      , param2 = this.params[2]
  // message("Aucun essai pour le moment")


  const audio = DGet('audio#audio')
  audio.addEventListener('canplaythrough', this.StartTestsAudio.bind(this))
  audio.src = '_FILMS_/Essais/marion.mp3'
  audio.load()
}

StartTestsAudio(){
  const itest = new TestAudio()
  itest.tests = [2, 3, 4]
  itest.startTests()
}

/**
* Les commandes de construction
***/
run_build_command(what, extra, option1){
  switch(what){
    case 'all': return this.run_build_all()
    case 'books': case 'livres': return this.run_build_books()
    case 'book': case 'livre':
      if ( option1 == '-update'){
        return this.run_build_all(extra, option1)
      } else {
        return this.run_build_books(extra, option1)
      }
    case 'document':case'documents': return this.run_build_documents(extra,option1)
    case 'pfa': return film.analyse.buildPFA()
    case 'cover': case 'couverture': return this.run_build_cover()
    case 'sequencier': return this.run_build_sequencier()
    case 'statistiques': case 'stats': return this.run_build_statistiques(extra)
    case 'synopsis': return this.run_build_synopsis()
    case 'traitement':case'treatment': return this.run_build_traitement()
    case 'quatrieme': return this.run_build_quatrieme()
    case 'frontispice': return this.run_build_frontispice()
    default: erreur(`Je ne sais pas comment construire un ou une ${what}`)
  }
}
run_create_command(what, name){
  switch(what){
    case 'document': case 'doc': return this.run_create_document(name)
    case 'film': case'analyse': return this.run_create_new_film(name)
    default: return erreur(`Je ne sais pas créer un élément de type “${what}”…`)
  }
}

run_create_new_film(name){
  // J'essaie de charger un module js
  if ( 'undefined' == typeof(FilmCreator) ){
    const script = DCreate('SCRIPT',{src:"js/module/FilmCreator.js", type:"text/javascript"})
    document.body.appendChild(script)
    script.addEventListener('load', ev => { FilmCreator.createNew(name) })
  } else {
    FilmCreator.createNew(name)
  }
}

run_create_document(name){
  if (name) {
    Ajax.send('create_document.rb', {name:name}).then(ret => {
      console.log(ret)
      message(`Document créé. Utiliser la commande suivante pour l'ouvrir : open document ${name}`,{keep:false})
      message("Il faut éditer le fichier config (commande <code>open config</code>) pour placer ce document au bon endroit.")
    })
  } else {
    erreur("Il faut indiquer le nom du document à créer !")
  }
}

/**
* Les commandes d'ouverture
***/
run_open_command(what, name){
  switch(what){
    case 'pfa':   return this.run_open_pfa()
    case 'film':  return this.open_film()
    case 'aide':  return Aide.openPDF();
    case 'manuel':
      Ajax.send(`open_${what}.rb`).then(ret => message(ret.message||"Ouverture effectuée"))
      break
    case 'config': return this.open_config_file()
    case 'document': case 'doc': return this.run_open_document(name)
    case 'book': case 'livre': return this.run_open_book(name)

    default: erreur(`Je ne sais pas ouvrir '${what}'…`)
  }
}

/**
* Les commandes de construction
***/

// Commande qui lance la construction de tout
run_build_all(type, option1){
  message('Reconstruction de tout…', {keep:false})
  this.run_build_sequencier(true)
  .then(this.run_build_cover.bind(this, null, true))
  .then(this.run_build_quatrieme.bind(this, null, true))
  .then(this.run_build_statistiques.bind(this, null, true))
  .then(this.run_build_traitement.bind(this, null, true))
  .then(this.run_build_sequencier.bind(this, null, true))
  .then(this.run_build_synopsis.bind(this, null, true))
  .then(this.run_build_pfa.bind(this, true))
  .then(this.run_build_books.bind(this, type, option1, true))
}

run_build_documents(doc_name,option1,keep_messages=false){
  var msg
  if (doc_name){ msg = `Construction du document '${doc_name}'`}
  else { msg = `Construction de tous les documents du film « ${film.title} » (définis dans config.yml)` }
  message(`${msg}, merci de patienter…`, {keep:keep_messages})
  return Ajax.send('build_documents.rb',{doc_name:doc_name, option:option1})
  .then(ret => {
    console.log(ret)
    if (doc_name){
      message(`Le document « ${doc_name} » du film « ${film.title} » a été construit avec succès. Tu peux le voir dans le dossier './products' du film (avec l'extension '.html')`,{keep:keep_messages})
    } else {
      message(`Les documents du film « ${film.title} » ont été construits avec succès. Tu peux les voir dans le dossier './products'.`,{keep:keep_messages})
    }
    ret.message && message(ret.message)
  })
}

run_build_books(type, option1, keep_messages = false){
  var msg
  if (type) msg = `Construction du livre de type '${type}'`
  else msg = `Construction de tous les livres du film « ${film.title} »`
  message(`${msg}, merci de patienter…`, {keep:keep_messages})
  return Ajax.send('build_books.rb', {type: type}).then(ret => {
    console.log(ret)
    message(`Les livres de l'analyse du film « ${film.title} » ont été construits avec succès.`,{keep:keep_messages})
    message("Consulter le dossier dans le Finder (dans le dossier <code>./livres</code>).", {keep:true})
    if ( ret.export_errors.length > 0 ) {
      error("Mais des erreurs ont été trouvées (consulter la console du navigateur pour les voir)")
      console.error(ret.export_errors)
    }
  })
}

run_build_cover(option1, keep_messages = false){
  message("Construction de la COUVERTURE, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_cover.rb').then(ret => {
    message("Couverture construite avec succès. Jouer 'open cover' pour le voir",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_frontispice(option1, keep_messages = false){
  message("Construction du FRONTISPICE, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_frontispice.rb').then(ret => {
    message("Frontispice construit avec succès.",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_quatrieme(option1, keep_messages = false){
  message("Construction de la QUATRIÈME DE COUVERTURE, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_quatrieme.rb').then(ret => {
    message("4e de couverture construite avec succès. Jouer 'open quatrieme' pour le voir",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_sequencier(keep_messages = false){
  message("Construction du SÉQUENCIER, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_sequencier.rb').then(ret => {
    // console.log(ret);
    message("Séquencier construit avec succès. Jouer 'open sequencier' pour le voir",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_synopsis(keep_messages = false){
  message("Construction du SYNOPSIS, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_synopsis.rb').then(ret => {
    // console.log(ret);
    message("Synopsis construit avec succès. Jouer 'open synopsis' pour le voir",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_traitement(keep_messages = false){
  message("Construction du TRAITEMENT, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_traitement.rb').then(ret => {
    // console.log(ret);
    message("Traitement construit avec succès. Jouer 'open traitement' pour le voir",{keep:keep_messages})
    ret.message && message(ret.message)
  })
}

run_build_statistiques(which, keep_messages = false){
  message("Construction des STATISTIQUES, merci de patienter…", {keep:keep_messages})
  return Ajax.send('build_statistiques.rb', {type: which}).then(ret => {
    // console.log(ret)
    message("Statistiques construites avec succès. Jouer 'open statistiques' pour les voir.")
    ret.message && message(ret.message)
  })
}

run_build_pfa(keep_messages = false){
  return film.analyse.buildPFA(keep_messages)
}


/**
  * Les commande d'ouverture
***/

run_open_pfa(){
  const my = this
  Ajax.send('check_if_exists.rb', {rpath: 'products/pfa.jpg'})
  .then(ret => {
    if ( ret.exists ) {
      my.open_pfa()
    } else {
      erreur("Le PFA du film n'est pas encore construit. Lancer la commande 'build pfa'.")
    }
  })
}
open_pfa(){
  window.open(`./_FILMS_/${film.folder}/products/pfa.jpg`, 'pfa')
}

run_open_document(name){
  if (name) {
    Ajax.send('open_document.rb', {name:name}).then(ret => {
      console.log(ret)
      message(`Document ouvert.`)
    })
  } else {
    erreur("Il faut indiquer le nom du document à ouvrir !")
  }
}

run_open_book(type){
  if (type) {
    Ajax.send('open_book.rb', {type:type}).then(ret => message(`Livre ouvert.`))
  } else {
    erreur("Il faut indiquer le type du livre à ouvrir ! (parmi 'html', 'epub', 'mobi', 'pdf')")
  }
}
/**
* Les commandes pour le PFA du film
***/
run_pfa_command(cmd){
  switch(cmd){
    case 'build': return this.run_build_pfa()
    case 'open':  return film.analyse.openPFA()
  }
}


run_set_command(what, value){
  switch(what){
    case 'current': return this.run_set_current_command(value)
    default: message(`Je ne sais pas définir ${what}…`)
  }
}

run_set_current_command(value){
  message("Définition de l'analyse courante. Je recharge la page pour en prendre compte.",{keep:false})
  Ajax.send('set_current.rb',{dossier: value})
  .then(ret => {
    ret.message && message(ret.message)
    window.location.reload()
  })
}


/**
* Méthode pour "parser" le code de la console, i.e. l'analyser pour pouvoir
le jouer
***/
parse(){
  this.params = this.code.split(' ')
  // console.log("This.params:", this.params)
  this.command = this.params[0]
}

/** ---------------------------------------------------------------------
*   LES COMMANDES
*
*** --------------------------------------------------------------------- */

// Pour ouvrir le dossier du film dans le Finder
open_film(){
  return Ajax.send('open_film.rb').then(ret => {
    message("J'ai ouvert le dossier du film dans le Finder", {keep:false})
  })
}
open_config_file(){
  return Ajax.send('open_fichier_config.rb').then(ret => {
    message("J'ai ouvert le fichier config.yml du film (dans Atom)", {keep:false})
  })
}
}//Console


/**
* Pour faire des tests pour trouver le rapport exact entre le rate de
l'audio et la vitesse. Pour pouvoir synchroniser le son et l'image avec
mon système d'accélération.
***/

class TestAudio {

constructor(){
  this.observe()
}

startTests(){
  this.tests = []
  var i = 1
  while(i < 8){
    i += 0.1
    this.tests.push(i)
  }
  this.duration = this.obj.duration * 1000
  console.info({'Durée totale (msecs)': this.duration})
  console.log("Je commence le test")
  this.runNextTest()
}

runNextTest(){
  const rateTest = this.tests.shift()
  if (rateTest) {
    this.start(rateTest)
  } else {
    console.log("Fini !")
  }
}
displayBilanAndNext(){
  const duree   = this.endTime - this.startTime
  const rapport = parseFloat(parseFloat(this.duration / duree).toFixed(2))
  console.info({
      start: this.startTime, end: this.endTime, rate: this.rate
    , duree:duree, acceleration: rapport
  })
  this.runNextTest()
}

start(rate){
  this.rate = rate
  this.obj.playbackRate = rate
  this.obj.currentTime  = 0
  this.startTime = this.now()
  this.obj.play()
}
observe(){
  this.obj.addEventListener('ended', this.onEnded.bind(this))
}
// Appelé quand ça finit
onEnded(){
  this.endTime = this.now()
  this.displayBilanAndNext()
}

now() { return Number(new Date().getTime()) }

get obj(){return this._obj || (this._obj = DGet('audio#audio') )}

}// class
