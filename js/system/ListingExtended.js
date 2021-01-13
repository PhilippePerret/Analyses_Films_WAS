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
