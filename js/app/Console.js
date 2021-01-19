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
    case 'open':      return this.run_open_command(this.params[1], this.params[2])
    case 'build':     return this.run_build_command(this.params[1])
    case 'pfa':       return this.run_pfa_command(this.params[1])
    case 'goto':      return DOMVideo.current.goto(this.params[1], this.params[2])
    case 'create':    return this.run_create_command(this.params[1], this.params[2])
    case 'update':    return film.update()
    case 'draw':      return DOMVideo.current.draw(this.params[1])
    case 'erase':     return DOMVideo.current.erase(this.params[1])
    case 'rewind': case 'back': case '-' : case 'backward':  return DOMVideo.current.backward(this.params[1])
    case 'for': case '+': case 'forward':   return DOMVideo.current.forward(this.params[1])
    default:
      erreur(`Je ne connais pas la commande “${this.command}”`)
  }
}

/**
* Les commandes de construction
***/
run_build_command(what){
  switch(what){
    case 'books': case 'livres': return this.run_build_books()
    case 'sequencier': return this.run_build_sequencier()
    case 'pfa': return film.analyse.buildPFA()
  }
}
run_create_command(what, name){
  switch(what){
    case 'document': case 'doc': return this.run_create_document(name)
    default: return erreur(`Je ne sais pas créer un élément de type “${what}”…`)
  }
}
/**
* Les commandes d'ouverture
***/
run_open_command(what, name){
  switch(what){
    case 'film':
    case 'manuel':
      Ajax.send(`open_${what}.rb`).then(ret => message(ret.message||"Ouverture effectuée"))
      break
    case 'config': return this.open_config_file()
    case 'document': case 'doc': return this.run_open_document(name)

    default: erreur(`Je ne sais pas ouvrir '${what}'…`)
  }
}

/**
* Les commandes de construction
***/
run_build_books(){
  message("Construction des livres, merci de patienter…", {keep:false})
  Ajax.send('build_books.rb').then(ret => {
    console.log(ret)
    message("Les livres ont été construits avec succès.",{keep:false})
    message("Consulter le dossier dans le Finder (dans le dossier <code>./finaux</code>).", {keep:true})
  })
}

run_build_sequencier(){
  message("Construction du séquencier, merci de patienter…", {keep:false})
  Ajax.send('build_sequencier.rb').then(ret => {
    console.log(ret);
    message("Séquencier construit avec succès. Jouer 'open sequencier' pour le voir",{keep:false})
  })
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
run_open_document(name){
  if (name) {
    Ajax.send('open_document.rb', {name:name}).then(ret => {
      console.log(ret)
      message(`Document ouvert.`)
    })
  } else {
    erreur("Il faut indiquer le nom du document à créer !")
  }
}

/**
* Les commandes pour le PFA du film
***/
run_pfa_command(cmd){
  switch(cmd){
    case 'build': return film.analyse.buildPFA()
    case 'open':  return film.analyse.openPFA()
  }
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

open_config_file(){
  return Ajax.send('open_fichier_config.rb').then(ret => {
    message("J'ai ouvert le fichier config.yml du film (dans Atom)", {keep:false})
  })
}
}//Console
