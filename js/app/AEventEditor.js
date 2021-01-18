'use strict'
/** ---------------------------------------------------------------------
    Class éditor
    ------------
    Gestion de l'édition "séparée" d'un évènement

Note : il ne s'agit pas de l'éditeur de listing qu'on trouve dans le
listing des évènements d'analyse mais d'un ou de plusieurs éditeurs qui
peuvent s'ouvrir lorsque l'on clique la touche Enter sur l'évènement
sélectionné.
*** --------------------------------------------------------------------- */
class AEventEditor {
/** ---------------------------------------------------------------------
*   CLASSE
*** --------------------------------------------------------------------- */

/**
* Méthode principale pour mettre l'évènement d'analyse +aevent+ en édition
***/
static edit(aevent){
  let editor ;
  if ( this.table[aevent.id] ) {
    editor = this.table[aevent.id]
  } else {
    editor = new AEventEditor(aevent)
    editor.open()
    editor.positionneAs(Object.keys(this.table).length)
    Object.assign(this.table, {[aevent.id]: editor})
  }
  this.current = editor
}

static activate(editor){
  editor.obj.style.zIndex = 2000
  UI.setFocusOn(editor)
}
static desactivate(editor){
  editor.obj.style.zIndex = 10
  UI.setFocusOn(AEvent)
}

static get current(){return this._current}
static set current(editor){
  if ( this._current ) this.desactivate(this.current)
  this._current = editor
  editor && this.activate(editor)
}

/**
* Méthode appelée quand on referme un éditeur
***/
static close(editor){
  const isCurrentEditor = editor.id == this.current.id
  if ( isCurrentEditor ){
    this.current = null
  }
  delete this.table[editor.aevent.id]
  if ( isCurrentEditor ) {
    this.current = Object.values(this.table).reverse()[0]
  }
}

static init(){
  this.table  = {}
}

/*** ---------------------------------------------------------------------
  INSTANCE
***/
constructor(aevent){
  this.aevent = aevent
}

get ref(){return this._ref || (this._ref = `AEvent #${this.aevent.id}`)}
get id(){ return this._id || ( this._id = `editor-${this.aevent.id}` )}
get name(){return this._name || (this._name = `Éditor #${this.aevent.id}`)}

open(){
  message(`AEvent #${this.aevent.id} en édition.`)
  this.build()
  this.setValues()
  this.observe()
}
close(){
  this.obj.remove()
  this.constructor.close(this)
}
onClick(){
  this.constructor.current = this
}

/**
* Appelé par la touche 't' en mode commande
***/
focusTexte(ev){
  focusIn(this.oContent)
}

/**
* Appelé par la touche 's' en mode commande
***/
onSave(ev){ this.save() }
/**
* Appelé par la touche 'u' pour actualiser le temps
***/
onUpdateTime(ev){
  message("Je dois actualiser le temps de l'event #"+this.aevent.id)
}

/**
* Méthode pour sauvegarder l'évènement d'analyse
Note : on utilise la méthode d'actualisation du listing, pour rester DRY
***/
save(){
  var newData = AEvent.checkValues(this.getValues())
  newData && this.aevent.update(newData)
}

/**
* Construction de l'éditeur
Note : on peut en créer autant qu'on veut
***/

build(){
  const oid = this.divId

  this.oContent = DCreate('TEXTAREA', {id:`${oid}-content`, class:'content'})
  this.oMainType  = DCreate('SELECT',   {id:`${oid}-mtype`, class:'mtype', inner: AEvent.buildOptionsMainTypes()})
  this.oSubType   = DCreate('SELECT',   {id:`${oid}-stype`, class:'stype', inner: AEvent.buildOptionsTypesNoeudCle()})
  this.oTime      = DCreate('INPUT',    {id:`${oid}-time`, class:'time'})

  this.obj = DCreate('DIV', {id: oid, class:'editor', inner:[
      DCreate('SPAN',     {id:`${oid}-id`, class:'id', text:`#${this.aevent.id}`})
    , DCreate('IMG', {src:'img/ui/b_close.png', class:'close-btn'})
    , this.oContent
    , this.oMainType
    , this.oSubType
    , this.oTime
  ]})
  document.body.appendChild(this.obj)
}

positionneAs(windowNumber = 0){
  this.obj.style.left = px(160 - (windowNumber * 20))
  this.obj.style.top  = px(300 + (windowNumber * 20))
}

getValues(){
  return {
      id: this.aevent.id
    , content: this.oContent.value.trim()
    , type: this.getTypeValue()
    , time: this.getTimeValue()
  }
}

setValues(){
  const ae  = this.aevent
  this.oContent.value   = ae.content
  this.oMainType.value  = ae.mainType
  this.oSubType.value   = ae.subType
  this.oTime.value      = s2h(ae.time)
}


getTypeValue(){
  var ty = this.oMainType.value
  if ( ty == 'nc' ) { ty += `:${this.oSubType.value}` }
  return ty
}
getTimeValue(){
  var t = this.oTime.value.trim()
  if ( t == '' ) t = video.time
  else t = h2t(t)
  return t
}



observe(){
  $(this.obj).draggable()
  this.obj.addEventListener('click', this.onClick.bind(this))
  DGet('.close-btn', this.obj).addEventListener('click', this.close.bind(this))
  // On observe les champs éditables (pour le mode clavier)
  UI.observeEditFieldsIn(this.obj)
}

get divId(){return this._divid || (this._divid = `editor-${this.aevent.id}`)}
}
