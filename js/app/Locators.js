'use strict'
/** ---------------------------------------------------------------------
*   Class Locators
    --------------
    Gestion des locators

Les "locators" permettent de définir des points clés dans le film pour
s'y déplacer plus rapidement. Ils sont reliés au Controller
*** --------------------------------------------------------------------- */
class Locators extends ListingExtended {

static get loadScript(){return 'load_locators.rb'}
static get saveItemScript(){return 'save_locator.rb'}

static get listing(){
  return this._listing || (this._listing = new Listing(this, {
      titre: "Signets"
    , id: 'locators'
    , container: DGet('div#controller div#locators-container')
    , height: 200
    , form_width: 200
    , list_width: 200
    , options: {
        title: false
      , sortable: true
      , draggable: false
    }
    , createOnPlus: true
  }))
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
  super(data)
}
get li(){
  return DCreate('LI', {id:`locator-${this.id}`, class:`listing-item`, text:this.data.name})
}
}
