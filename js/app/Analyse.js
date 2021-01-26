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

buildPFA(keep_messages = false){
  return Ajax.send('build_pfa.rb')
  .then(ret => {
    // console.log(ret)
    message(ret.message, {keep:keep_messages})
  })
}
openPFA(){
  error("Je ne sais pas encore ouvrir le PFA.")
}

}//Analyse
