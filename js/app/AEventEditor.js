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
  // console.log("-> desactivate", editor)
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
* Actualisation du menu décor dans toutes les fenêtres d'édition ouvertes
***/
static updateMenuDecors(){
  Object.values(this.table).forEach(editor => editor.updateMenuDecors())
}

/**
* Méthode appelée pour fermer un éditeur
***/
static close(editor){
  editor = editor || this.current
  editor && editor.close()
}
/**
* Méthode appelée quand on referme un éditeur
***/
static onClose(editor){
  const isCurrentEditor = editor.id == this.current.id
  if ( isCurrentEditor ){
    this.current = null
  }
  setTimeout(()=>{
    const eid = editor.aevent.id
    delete this.table[eid]
    if ( isCurrentEditor ) {
      // Si c'était l'éditeur courant, il faut mettre le suivant en
      // éditeur courant
      const otherEditor = Object.values(this.table).reverse()[0]
      if ( otherEditor ) { this.current = otherEditor }
      else { UI.setFocusOn(AEvent) }
    }
  }, 100 /* sinon ça va trop vite */)
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
  document.activeElement.blur()
  this.obj.remove()
  this.constructor.onClose(this)
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
* Méthode appelée quand on change le main-type de l'évent. Pour régler la
visibilité et la valeur des autres éléments
***/
onChangeMainType(ev){
  const mtype = this.oMainType.value
  UI.showIf(this.oLieuScene,  mtype == 'sc')
  UI.showIf(this.oEffetScene, mtype == 'sc')
  UI.showIf(this.oDecor, mtype == 'sc')
  UI.showIf(this.oNoeudCleType, mtype == 'nc')
}

/**
* Construction de l'éditeur
Note : on peut en créer autant qu'on veut
***/
build(){
  const oid = this.divId

  this.oContent       = DCreate('TEXTAREA', {id:`${oid}-content`, class:'content'})
  this.oMainType      = DCreate('SELECT',   {id:`${oid}-mtype`, class:'mtype', inner: AEvent.buildOptionsMainTypes()})
  this.oNoeudCleType  = DCreate('SELECT',   {id:`${oid}-stype`, class:'stype', inner: AEvent.buildOptionsTypesNoeudCle()})
  this.oTime          = DCreate('INPUT',    {id:`${oid}-time`, class:'time'})
  this.oLieuScene     = DCreate('SELECT',   {id:`${oid}-lieu`, class:'lieu', inner:AEvent.buildOptionsLieuScene()})
  this.oEffetScene    = DCreate('SELECT', {id:`${oid}-effet`, class:'effet', inner:AEvent.buildOptionsEffetScene()})
  this.oDecor         = DCreate('SELECT', {id:`${oid}-decor`, class:'decor hidden', inner:AEvent.buildOptionsDecorScene()})

  this.obj = DCreate('DIV', {id: oid, class:'editor', inner:[
      DCreate('SPAN',     {id:`${oid}-id`, class:'id', text:`#${this.aevent.id}`})
    , DCreate('IMG', {src:'img/ui/b_close.png', class:'close-btn'})
    , this.oContent
    , DCreate('DIV', {inner:[this.oMainType, this.oNoeudCleType, this.oLieuScene, this.oEffetScene]})
    , this.oDecor
    , this.oTime
  ]})
  document.body.appendChild(this.obj)
}

// Actualisation du menu des décors
updateMenuDecors(){
  this.oDecor.textContent = ''
  AEvent.buildOptionsDecorScene().forEach(o => this.oDecor.appendChild(o))
}

positionneAs(windowNumber = 0){
  this.obj.style.left = px(160 - (windowNumber * 20))
  this.obj.style.top  = px(300 + (windowNumber * 20))
}

getValues(){
  var d = {
      id: this.aevent.id
    , content: this.oContent.value.trim()
    , type: this.getTypeValue()
    , time: this.getTimeValue()
  }
  if ( this.aevent.isScene ) {
    Object.assign(d, { decor: this.oDecor.value })
  }
  return d
}

setValues(){
  const ae  = this.aevent
  this.oContent.value   = ae.content

  this.oMainType.value  = ae.mainType
  this.onChangeMainType()
  this.oNoeudCleType.value   = ae.subType || ''
  // console.log("Lieu mis à ", ae.lieu)
  this.oLieuScene.value   = ae.lieu || 'i'
  // console.log("Effet mis à ", ae.effet)
  this.oEffetScene.value  = ae.effet || 'j'
  ae.isScene && (this.oDecor.value = ae.decor || 'x')
  this.oTime.value = s2h(ae.time)
}


getTypeValue(){
  var ty = this.oMainType.value
  if ( ty == 'nc' ) { ty += `:${this.oNoeudCleType.value}` }
  else if ( ty == 'sc') { ty += `:${this.oLieuScene.value}:${this.oEffetScene.value}` }
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
  this.oMainType.addEventListener('change', this.onChangeMainType.bind(this))

}

get divId(){return this._divid || (this._divid = `editor-${this.aevent.id}`)}
}
