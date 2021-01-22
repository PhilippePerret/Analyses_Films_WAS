'use strict'

const SNIPPETS = {
  t: {method: 'baliseTime'}
}


class Snippets {

/**
* Méthode appelée quand on joue tabulation dans un champ de texte.
La méthode renvoie TRUE si un snippet a été joué, FALSE dans le cas contraire
***/
static traiteIn(field){
  console.log("field", field)
  const selector = new Selector(field)
  const snip = selector.beforeUpTo(' ')
  if ( !SNIPPETS[snip] ) return false
  const remp = this[SNIPPETS[snip].method]()
  this.checkAndReplace(selector, snip, remp)
  return true
}

/**
* Méthode qui checke le possible snippet +snip+ et le remplace
* dans le sélector +sel+ (vraiment class Selector) le cas échéant.
**/
static checkAndReplace(sel, snip, remp){
  sel.set(sel.startOffset - snip.length, null)
  sel.insert(remp)
  // Si le texte contient '$0' on doit s'y rendre et le
  // sélectionner
  var dol_index = remp.indexOf('$0')
  if(dol_index < 0) return // pas de $0
  var remp_len = remp.length
  var curOffset = 0 + sel.startOffset
  sel.startOffset = curOffset - remp_len + dol_index
  sel.endOffset   = sel.startOffset + 2
}

static baliseTime(){
  return `[time:${t2h(DOMVideo.current.time)}]`
}

static baliseRefFilm(){

}

}
