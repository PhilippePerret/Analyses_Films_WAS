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

buildPFA(){
  Ajax.send('pfa_build.rb', { duration: video.duration } )
  .then(ret => {
    console.log(ret)
    message(ret.message, {keep:false})
  })
}
openPFA(){
  error("Je ne sais pas encore ouvrir le PFA.")
}

}//Analyse
