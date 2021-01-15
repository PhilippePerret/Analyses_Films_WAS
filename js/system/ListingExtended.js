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

/**
* Liste des events classés (par la méthode this.sortMethod )
***/
static get orderedList(){
  if ( !this._orderedList ){
    this._orderedList = Object.values(this.table).sort(this.sortMethod.bind(this))
    // On renseigne la donnée 'index' de chaque évènement
    for(var i = 0, len = this._orderedList.length; i < len ; ++i){
      this._orderedList[i].index = Number(i)
    }
    this.count = this._orderedList.length
    this.lastIndex = this.count - 1
  }
  return this._orderedList
}

/**
* Retourne TRUE si l'item +item+ est le dernier de la liste
***/
static isLastItem(item){
  return this.isOrdered && (item.index === this.lastIndex)
}

/**
* Actualiser la liste ordonnée (après une création, un suppression,
un déplacement)
***/
static resetOrderedList(){
  delete this._orderedList
  this.orderedList // pour actualiser et notamment remettre à jour les index
  // console.log("_orderedList = ", this._orderedList)
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
    this.selectFirst()
    // error("Aucun item trouvé… Impossible de passer au suivant.", {keep:false})
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
    this.selectLast()
    // error("Aucun item trouvé… Impossible de passer au précédent.", {keep:false})
  }
}

static get(itemId){return this.table[itemId]}

static newId(){return ++this.lastId}

/**
* Méthode qui charge les items (locators ou events) et les instancie
***/
static load(){
  __in("%s::load", this.name)
  this.init()
  return Ajax.send(this.loadScript)
  .then(this.dispatchItems.bind(this))
  .then(this.addItemsToListing.bind(this))
  __out("%s::load", this.name)
}
static dispatchItems(ret){
  __in("%s::dispatchItems", this.name)
  // ret.items.forEach(loc => this.addFromData(loc))
  ret.items.forEach(this.addFromData.bind(this))
  __out("%s::dispatchItems", this.name)
}
/**
Pour afficher les items dans le listing
Si une méthode 'sortMethod' existe, c'est une liste classée qu'on doit
afficher
*/
static addItemsToListing(){
  __in("%s::addItemsToListing", this.name)
  const list = this.isOrdered ? this.orderedList : Object.values(this.table)
  list.forEach(item => this.listing.add(item) )
  __out("%s::addItemsToListing", this.name)
}
static addFromData(data){
  const item = new this(data)
  if(item.id > this.lastId) this.lastId = Number(item.id)
  Object.assign(this.table, {[item.id]: item})
}

static create(data){
  Object.assign(data, {id: this.newId()})
  const item = new this(data)
  Object.assign(this.table, {[item.id]: item})
  item.save()
  return item // pour l'ajouter à la liste
}

/**
* Méthode système appelée après l'ajout de l'item dans la liste, quand
c'est une création.
***/
static __afterCreate(item){
  if (this.isOrdered) {
    this.resetOrderedList()
    item.repositionne()
    item.select()
  }
}

/**
* Actualisation des données
***/
static update(data){
  var item = this.get(data.id)
  if (item) {
    item.update(data)
  } else {
    console.error("Impossible de trouver l'item %s dans ", String(data.id), this.table)
  }
}

/**
Appelé par le listing quand on détruit un item
Note : si c'est une liste ordonnée, elle est actualisée
*/
static onDestroy(item){
  const isSelectedItem = this.listing.selection.lastItem && item.id == this.listing.selection.lastItem.id
  item.isSelectedItem = isSelectedItem
  Ajax.send(this.destroyItemScript, {id: item.id})
  .then(() => {
    delete this.table[item.id]
    this.isOrdered && this.resetOrderedList()
  })
}

static afterDestroy(item){
  console.log("item détruit : ", item)
  if ( item.isSelectedItem ) {
    console.log("Je dois sélectionner un élément autour")
  }
}


static get isOrdered(){
  return this._isorderedlist || (this._isorderedlist = 'sortMethod' in this)
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
  return Ajax.send(this.constructor.saveItemScript, {data: this.data})
  // .then(ret => console.log(ret))
}
update(data){
  const timeHasChanged = parseFloat(data.time) != this.time
  const oldIndex = this.index
  this.dispatchData(data)
  this.save()
  this.listingItem.replaceInList() // mais ne change pas la position
  if ( timeHasChanged ) {
    this.constructor.resetOrderedList()
    this.index == oldIndex || this.repositionne()
  }
}
destroy(lefaire = false){
  lefaire = lefaire || confirm("Es-tu certain de vouloir détruire cet éléments ?")
  lefaire && this.constructor.listing.onMoinsButton({}, true)
}

/**
* Méthode qui repositionne l'item au bon endroit dans la liste
en fonction de son index
Rappel : l'index n'est calculé que lorsque c'est une liste classée
Rappel : le listing ne fonctionne par liste classée (orderedList) que
         lorsque la méthode this.sortMethod est définie.
***/
repositionne(){
  console.log(`Repositionnement de ${this.ref}`)
  const li = this.listingItem.obj
      , listing = li.parentNode
  if ( this.constructor.isLastItem(this) ) {
    listing.appendChild(li)
  } else {
    listing.removeChild(li)
    listing.insertBefore(li, listing.children[this.index])
  }
}

}
