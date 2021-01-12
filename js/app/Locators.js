'use strict'
/** ---------------------------------------------------------------------
*   Class Locators
    --------------
    Gestion des locators

Les "locators" permettent de définir des points clés dans le film pour
s'y déplacer plus rapidement. Ils sont reliés au Controller
*** --------------------------------------------------------------------- */
class Locators extends ListingExtended {

/**
* Méthode appelée quand on sélectionne un item dans le listing
***/
static onSelect(item){ video.time = item.data.time }


static get loadScript(){return 'load_locators.rb'}
static get saveItemScript(){return 'save_locator.rb'}
static get destroyItemScript(){return 'destroy_locator.rb'}

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
      , no_id: true // ne pas montrer l'identifiant
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
static gotoSignet(which){
  if ( undefined == this.orderedItems ) this.orderedItems = this.getOrderedItems()
  if ( undefined == this.indexCurrentSignet ){
    this.indexCurrentSignet = 0
  } else {
    switch(which){
      case 'next' :
        if ( this.indexCurrentSignet > this.orderedItems.length - 1 ) return error("C'est le dernier signet !")
        ++ this.indexCurrentSignet
        break
      case 'prev':
        if ( this.indexCurrentSignet == 0 ) return error("C'est le premier signet !")
        -- this.indexCurrentSignet
        break
      default:
        this.indexCurrentSignet = which
    }
  }
  this.orderedItems[this.indexCurrentSignet].select()
}

/**
* Méthode qui retourne la liste des items tels que classés dans la liste
affichée
***/
static getOrderedItems(){
  var ary = []
  this.listing.liste.querySelectorAll('.listing-item').forEach(li =>{
    ary.push(this.get(Number(li.id.split('-')[1])))
  })
  return ary
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
