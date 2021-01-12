'use strict'
/** ---------------------------------------------------------------------
*   Class Locators
    --------------
    Gestion des locators

Les "locators" permettent de définir des points clés dans le film pour
s'y déplacer plus rapidement. Ils sont reliés au Controller
*** --------------------------------------------------------------------- */
class Locators {
/**
* Méthode pour initialiser les locators
***/
static init(){
  this.table = {}
  this.lastId = 0
}
/**
* Méthode qui charge les locateurs du film et les instancie
***/
static load(){

}

static get listing(){
  return this._listing || (this._listing = new Listing(this, {
      titre: "Signets"
    , id: 'locators'
    , container: DGet('div#controller div#locators-container')
    , sortable: true
    , createOnPlus: true
  }))
}
static get(lid){return this.table[lid]}
static create(data){
  Object.assign(data, {id: this.newId()})
  const item = new this(data)
  item.save()
  return item
}
static update(data){
  const item = this.get(data.id)
  item.dispatchData(data)
  item.save()
  return item
}
static get PROPERTIES(){
  if (undefined == this._properties){
    this._properties = [
        {name:'name', hname:'Nom du signet'}
      , {name:'time', hname:'Position', setter:'setTemps', getter:'getTemps'}
    ]
  } return this._properties
}

// --- Méthode pour le temps de l'évènement ---
static getTemps(){
  var v = this.tempsField.value
  if (v == '') v = video.time
  else { v = h2t(v) }
  return v
}
static setTemps(v){
  this.tempsField.value = t2h(v)
}
static get tempsField(){
  return this._tpsfield || (this._tpsfield = this.listing.obj.querySelector('#item-time'))
}

/** ---------------------------------------------------------------------
*
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(data) {
  this.dispatchData(data)
}
dispatchData(data){
  this.data = data
  this.id = data.id
}
li(){
  return DCreate('LI', {id:`locator-${this.id}`, class:`listing-item`, text:this.data.name})
}
}
