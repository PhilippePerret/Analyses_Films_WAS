'use strict'
/** ---------------------------------------------------------------------
*   Classe abstraite ExtendedListing
*
*** --------------------------------------------------------------------- */
class ListingExtended {
/** ---------------------------------------------------------------------
*   CLASSE
*
*** --------------------------------------------------------------------- */
static init(){
  this.table = {}
  this.lastId = 0
}

// Pour sélectionner le premier item (if any)
static selectFirst(){
  if ( Object.keys(this.table).length ) {
    var litem = this.listing.liste.firstChild
    var item = this.get(parseInt(litem.id.split('-')[1]))
    this.listing.select(item)
  } else {
    error("Impossible de sélectionner le premier élément. Il n'y en a pas.", {keep:false})
  }
}
// Pour sélectionner le dernier item (if any)
static selectLast(){
  if ( Object.keys(this.table).length ) {
    var litem = this.listing.liste.lastChild
    var item = this.get(parseInt(litem.id.split('-')[1]))
    this.listing.select(item.listingItem)
  } else {
    error("Impossible de sélectionner le dernier élément. Il n'y en a pas.", {keep:false})
  }
}
// Pour sélectionner l'item suivant (if any)
static selectNext(){
  var item = this.listing.getSelection()[0]
  if ( item ) {
    const litem = item.listingItem.obj.nextSibling
    if (litem) {
      const item  = this.get(Number(litem.id.split('-')[1]))
      this.listing.select(item)
    } else {
      this.selectFirst()
    }
  } else {
    error("Aucun item trouvé… Impossible de passer au suivant.")
  }
}
// Pour sélectionner l'item précédent (if any)
static selectPrevious(){
  var item = this.listing.getSelection()[0]
  if ( item ) {
    const litem = item.listingItem.obj.previousSibling
    if (litem) {
      const item  = this.get(Number(litem.id.split('-')[1]))
      this.listing.select(item)
    } else {
      this.selectLast()
    }
  } else {
    error("Aucun item trouvé… Impossible de passer au précédent.")
  }
}

static get(itemId){return this.table[itemId]}

static newId(){return ++this.lastId}

/**
* Méthode qui charge les items (locators ou events) et les instancie
***/
static load(){
  this.init()
  return Ajax.send(this.loadScript)
  .then(this.dispatchItems.bind(this))
}
static dispatchItems(ret){
  ret.items.forEach(loc => this.addFromData(loc))
}
static addFromData(data){
  const item = new this(data)
  if(item.id > this.lastId) this.lastId = Number(item.id)
  Object.assign(this.table, {[item.id]: item})
  this.listing.add(item)
}

static create(data){
  Object.assign(data, {id: this.newId()})
  const item = new this(data)
  item.save()
  return item
}
static update(data){
  var item = this.get(data.id)
  if (item) {
    item.update(data)
  } else {
    console.error("Impossible de trouver l'item %s dans ", String(data.id), this.table)
  }
}

// Appelé par le listing quand on détruit un item
static onDestroy(item){
  Ajax.send(this.destroyItemScript, {id: item.id})
  .then(() => delete this.table[item.id])
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
save(){
  return Ajax.send(this.constructor.saveItemScript, {data: this.data}).then(ret => console.log(ret))
}
update(data){
  this.dispatchData(data)
  this.save()
  this.listingItem.replaceInList()
}

}
