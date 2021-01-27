'use strict'
/** ---------------------------------------------------------------------
*   Class Analyse
    -------------
    Pour la gestion de l'analyse en tant que telle.

Utiliser 'film.analyse' pour travailler avec l'instance courante
*** --------------------------------------------------------------------- */
class Analyse {
constructor(film) {
  this.film = film
}

buildPFA(keep_messages = false, option){
  if (option == '-html') {
    return Ajax.send('build_pfa.rb').then(ret => {
      ret.message && message(ret.message,{keep:true})
    })
  } else {
    return Ajax.send('build_image_pfa.rb').then(ret => {
      message(ret.message, {keep:keep_messages}) // toujours
    })
  }
}
openPFA(){
  error("Je ne sais pas encore ouvrir le PFA.")
}

}//Analyse
