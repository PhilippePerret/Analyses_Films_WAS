'use strict'

/**
* Méthode qui formate le texte +str+, mais assez sommairement contrairement
à la méthode similaire en ruby
Ici, l'utilisation principale concerne les menus, comme les décors par exemple.
***/
function formate(str){
  for (var pid in film.personnages ) {
    const reg = new RegExp(`\b${pid}\b`, 'g')
    str = str.replace(reg, film.personnages[pid].full_name)
  }
  return str
}
