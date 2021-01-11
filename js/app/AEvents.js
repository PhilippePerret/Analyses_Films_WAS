'use strict'
/** ---------------------------------------------------------------------
*   Class AEvents
    -------------
    Gestion des évènements d'analyse
*** --------------------------------------------------------------------- */
class AEvent {

  static get PROPERTIES(){
    if (undefined == this._properties){
      this._properties = [
          {name:"content", hname:"Contenu", type:'textarea', required:false}
        , {name: "type", hname:'Type', type:'text', form:"buildMenuType", setter:"setType", getter:"getType", default:'no'}
        , {name:'time', hname:"Temps", type:'number', vtype:'text', setter:"setTemps", getter:'getTemps'}
      ]
    };return this._properties
  }

  // --- Pour le type d'évènement ---
  static get TYPES(){
    if (undefined == this._types){
      this._types = {
          sc: {id:'sc', hname: "Scène"}
        , nc: {id:'nc', hname: "Nœud clé"}
        , no: {id:'no', hname: "Note"}
      }
    }; return this._types
  }

  static get TYPES_NOEUDS(){
    if (undefined == this._types_noeuds){
      this._types_noeuds = {
          ex: {id:'ex', hname:'Début Exposition'}
        , ip: {id:'ip', hname:'Incident perturbateur'}
        , id: {id:'id', hname:'Incident déclencheur'}
        , p1: {id:'p1', hname:'Premier pivot'}
        , dv: {id:'dv', hname:'Début Développement'}
        , t1: {id:'t1', hname:'Scène de 1er tiers'}
        , cv: {id:'cv', hname:'Clé de voûte'}
        , t2: {id:'t2', hname:'Scène de 2nd tiers'}
        , cr: {id:'cr', hname:'Crise (développement)'}
        , p2: {id:'p2', hname:'Pivot 2'}
        , cd: {id:'cd', hname:'Crise (dénouement)'}
        , cx: {id:'cx', hname:'Climax'}
        , de: {id:'de', hname:'Désinence'}
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
    const ty = this.menuType.value
    if ( ty == 'nc' ) ty += `:${this.menuTypeNoeud.value}`
    return ty
  }
  static setType(v){this.menuType.value = v}
  static get menuType(){return this._menutype || (this._menutype = document.querySelector('select#item-type'))}
  static get menuTypeNoeud(){return this._menutynoeud || (this._menutynoeud = document.querySelector('select#item-ntype'))}

  // --- Méthode pour l'horloge ---
  static getTemps(){return video.time}
  static setTemps(v){this.listing.obj.querySelector('#item-time').value = t2h(v)}

  // Initialisation
  static init(){
    this.lastId = 0 // avant de charger le film
    this.listing // simplement pour voir ce que fait l'initialisation
  }

  static getNewId(){
    ++this.lastId
    return this.lastId
  }

  static get listing(){
    return this._listing || (this._listing = new Listing(this, {
        titre: "Évènements d'analyse"
      , id: "aevents"
      , createOnPlus: true
      , top: 20
      , left: 550
      , sortable: false
    }))
  }

  static get(eid){return this.table[eid]}
  static create(data){
    Object.assign(data, {id: this.getNewId()})
    console.log("Création de l'évènement", data)
    const newItem = new AEvent(data)
    return newItem
  }
  static update(data){
    console.log("Actualisation de l'évènement", data)
  }

constructor(data) {
  this.data = data
  this.id = data.id
  this.content = data.content
}
get li(){
  const LI = DCreate("LI", {id: `aevent-${this.id}`, class:"listing-item li-aevent", text:this.content})
  return LI
}


}
