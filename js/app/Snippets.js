'use strict'

const SNIPPETS = {
    t:    {method: new Function('return `[time:${t2h(DOMVideo.current.time, false)}]`')}
  , app:  {value: "Analyseur de Film"}
}


class Snippets {

/**
* Méthode appelée quand on joue tabulation dans un champ de texte.
La méthode renvoie TRUE si un snippet a été joué, FALSE dans le cas contraire
***/
static traiteIn(field){
  const selector = new Selector(field)
  const snip = selector.beforeUpTo(' ')
  if ( !SNIPPETS[snip] ) return false
  const remp = SNIPPETS[snip].value || SNIPPETS[snip].method()
  this.checkAndReplace(selector, snip, remp)
  return true
}

/**
* Pour ajouter des snippets personnalisés
Utilisé par exemple si des snippets sont définis dans les préférences
***/
static addCustomSnippets(table){
  var dsnip
  // On vérifie que tout est ok
  for(var snip in table){
    var value ;
    dsnip = table[snip]
    if ( 'string' == typeof(dsnip) ) {
      value = {value: dsnip}
    } else if (dsnip.method) {
      if (!dsnip.method.match('return')) dsnip.method = `return ${dsnip.method}`
      value = {method: new Function("snip", dsnip.method)}
    } else if (dsnip.value) {
      value = dsnip
    } else {
      erreur("Il faut définir la méthode ou la valeur de snippet à utiliser pour '"+snip+"'.", {force_keep:true})
      continue
    }
    Object.assign(SNIPPETS, {[snip]: value})
  }
}

// /Public Methods
// ---------------------------------------------------------------------

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
  return
}

static baliseRefFilm(){

}

}
