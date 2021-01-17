'use strict'
/** ---------------------------------------------------------------------
*   Class AEvents
    -------------
    Gestion des évènements d'analyse
*** --------------------------------------------------------------------- */
class AEvent extends ListingExtended {

static get loadScript(){return 'load_events.rb'}
static get saveItemScript(){return 'save_event.rb'}
static get destroyItemScript(){return 'destroy_event.rb'}

static get current() { return this._current }
static set current(e) { this._current = e }

/**
* L'évènement actuellement affiché dans la vidéo (if any)
***/
static get currentInVideo(){return this._currentinvideo}
static set currentInVideo(e){
  if (this.currentInVideo){
    this.currentInVideo.obj.classList.remove('current-in-video')
    this._currentinvideo = e
    this.currentInVideo.obj.classList.add('current-in-video')
  }
}

/**
* Méthode qui permet de classer les items (dans this.orderedList qui
est une extension apportée par ListingExtended)
***/
static sortMethod(a, b){
  return a.time > b.time ? 1 : -1
}


/**
* Méthode qui retourne les évènements autour du temps +time+
C'est-à-dire une table contenant :
{:current, :previous, :next}
***/
static getEventsAround(time){
  const d = {current: null, previous: null, next: null}
  for(var i = 0, len = this.orderedList.length; i < len ; ++i){
    if ( this.orderedList[i].time > time ){
      d.current   = this.orderedList[i - 1]
      d.previous  = this.orderedList[i - 2]
      d.next      = this.orderedList[i]
      break
    }
  }
  return d
}

/**
* Méthode appelée quand on sélectionne un item dans le listing
***/
static onSelect(item){
  this.current = item
  const optFollowItem = DGet('input#follow_selected_event').checked
  optFollowItem && (DOMVideo.current.time = item.data.time)
}

static get PROPERTIES(){
  if (undefined == this._properties){
    this._properties = [
        {name:"content", hname:"Contenu", type:'textarea', required:true}
      , {name: "type", hname:'Type', type:'text', form:"buildMenuType", setter:"setType", getter:"getType", default:'no'}
      , {name:'time', hname:"Temps", type:'number', vtype:'text', setter:"setTemps", getter:'getTemps', placeholder: 'Cliquez le point-temps sur la vidéo'}
    ]
  };return this._properties
}

// --- Pour le type d'évènement ---
static get TYPES(){
  if (undefined == this._types){
    this._types = {
        sc: {id:'sc', hname: "Scène",     letter:'s'}
      , nc: {id:'nc', hname: "Nœud clé",  letter:''}
      , no: {id:'no', hname: "Note",      letter:'n'}
      , if: {id:'if', hname: 'Info',      letter:'i'}
    }
  }; return this._types
}

static get TYPES_NOEUDS(){
  if (undefined == this._types_noeuds){
    this._types_noeuds = {
        zr: {id:'zr', hname:'Point Zéro'}
      , ex: {id:'ex', hname:'Début Exposition'}
      , ip: {id:'ip', hname:'Incident perturbateur'}
      , id: {id:'id', hname:'Incident déclencheur'}
      , p1: {id:'p1', hname:'Premier pivot'}
      , dv: {id:'dv', hname:'Début Développement'}
      , t1: {id:'t1', hname:'Scène de 1er tiers'}
      , cv: {id:'cv', hname:'Clé de voûte'}
      , d2: {id:'d2', hname:'Développement part II'}
      , t2: {id:'t2', hname:'Scène de 2nd tiers'}
      , cr: {id:'cr', hname:'Crise (développement)'}
      , p2: {id:'p2', hname:'Pivot 2'}
      , dn: {id:'dn', hname:'Début Dénouement'}
      , cd: {id:'cd', hname:'Crise (dénouement)'}
      , cx: {id:'cx', hname:'Climax'}
      , de: {id:'de', hname:'Désinence'}
      , pf: {id:'pf', hname:'Point Final'}
    }
  }; return this._types_noeuds
}

static buildMenuType(){
  const options = []
  Object.values(this.TYPES).forEach(d => options.push(DCreate('OPTION',{value:d.id, text:d.hname})))
  // Les types de noeuds clés
  const opts_type_noeud = []
  Object.values(this.TYPES_NOEUDS).forEach(dn => {
    opts_type_noeud.push(DCreate('OPTION',{value:dn.id, text:dn.hname}))
  })

  const row = DCreate('DIV', {id:'row_type', class:'row row-type', inner:[
      DCreate('LABEL', {text:'Type'})
    , DCreate('SELECT', {id:'item-type', inner: options})
    , DCreate('SELECT', {id:'item-ntype', class:'hidden', inner:opts_type_noeud}) // type de noeud
    , DCreate('DIV', {class:'error-message'})
  ]})
  // Pour l'observation des menus
  row.querySelector('#item-type').addEventListener('change', this.onChooseTypeEvent.bind(this))
  return row
}
static onChooseTypeEvent(ev){
  const ty = this.menuType.value
  // Visibility du menu des noeuds
  this.menuTypeNoeud.classList[ty=='nc'?'remove':'add']('hidden')
}
static getType(){
  var ty = this.menuType.value
  if ( ty == 'nc' ) ty += `:${this.menuTypeNoeud.value}`
  return ty
}
static setType(v){
  var nt ;
  if ( v.match(':') ) { [v, nt] = v.split(':')}
  this.menuType.value = v
  nt && $(this.menuTypeNoeud).val(nt)
  this.menuTypeNoeud.classList[nt?'remove':'add']('hidden')
}
static get menuType(){return this._menutype || (this._menutype = document.querySelector('select#item-type'))}
static get menuTypeNoeud(){return this._menutynoeud || (this._menutynoeud = document.querySelector('select#item-ntype'))}

// --- Méthode pour le temps de l'évènement ---
static getTemps(){
  var v = this.tempsField.value
  if (v == '') v = DOMVideo.current.time
  else { v = h2t(v) }
  return v
}
static setTemps(v){
  this.tempsField.value = t2h(v)
}
static get tempsField(){
  return this._tpsfield || (this._tpsfield = this.listing.obj.querySelector('#item-time'))
}

// Pour focusser dans le champ de texte
static focusTexte(){
  focusIn(this.listing.obj.querySelector('#item-content'))
}

// Pour initialiser le formulaire
static initForm(){
  this.listing.deselectAll()
  this.listing.form.cleanup()
  this.menuTypeNoeud.classList.add('hidden')
  delete this._current
  message("Formulaire initialisé.", {keep:false})
}

/**
* Pour la construction du listing
***/
static get listing(){
  return this._listing || (this._listing = new Listing(this, {
      titre: "Évènements d'analyse"
    , container: DGet("div#container-listing")
    , id: "aevents"
    , createOnPlus: true
    , height: 580
    , list_width: 610
    , list_height: 260
    , form_width: 610
    , options:{
        draggable:  false
      , sortable:   false
      , no_id:      true
      , form_under_listing: true
    }
  }))
}


constructor(data) {
  super(data)
  this.content  = this.data.content
  this.time = this.data.time = parseFloat(this.data.time);
  ['nc:zr','nc:ex','nc:pf']
   .includes(this.type) && film.definePointsLimites(this)
}

// Une référence à l'objet (évènement d'analyse) pour les messages
get ref(){
  return this._ref || (this._ref = `AEvent #${this.id}`)
}

// Le LI à afficher dans le listing
get li(){
  const LI = DCreate("LI", {id: `aevent-${this.id}`, class:"listing-item li-aevent", text:this.fcontent})
  return LI
}

// Retourne le contenu formaté de l'évènement
get fcontent(){
  return `${this.htype} ${this.data.content}<span class="show-on-select">${this.hiddenInfos}</span>`
}

get hiddenInfos(){
  return `${t2h(this.time)} #${this.id}`
}

// Retourne le type humain en fonction du nœud
get htype(){
  var ty = this.data.type, cty, st ;
  if ( ty.match(/:/) ) {
    [ty, st] = this.data.type.split(':')
    if ( ty == 'nc') {
      cty = this.constructor.TYPES_NOEUDS[st].hname
    } else {
      cty = ty // à mieux régler
    }
  } else {
    cty = this.constructor.TYPES[ty].letter
  }
  return `<span class="type ${ty}">${cty}</span>`
}

afterUpdate(){
  this.time = this.data.time
}

updateTime(newtime){
  if ( undefined == newtime ) newtime = DOMVideo.current.time
  if ( newtime != this.time ) {
    this.data.time = this.time = newtime
    this.constructor.setTemps(newtime)
    this.setModified()
  }
}
setModified(){
  this.listingItem.addClass('modified')
  message(`${this.ref} modifié. Tape "s" pour l'enregistrer.`, {keep:false})
}
/**
* Marquer non modifié
Note : on doit checker l'existence du listing-item car quand on crée
l'event, ce listing-item n'existe pas encore, ici
***/
unsetModified(){
  this.listingItem && this.listingItem.removeClass('modified')
}

save(){
  super.save()
  message(`${this.ref} enregistré.`, {keep:false})
  this.unsetModified()
}

get type(){return this._type || (this._type = this.data.type)}
set type(v){this._type = this.data.type = v}
}//AEvent
