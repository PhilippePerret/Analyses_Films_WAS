'use strict'
/** ---------------------------------------------------------------------
*   Class AEvents
    -------------
    Gestion des évènements d'analyse
*** --------------------------------------------------------------------- */
class AEvent {

  static get(eid){return this.table[eid]}

  /**
  * Méthode pour créer l'évènement
  ***/
  static create(data){
    Object.assign(data, {id: this.getNewId()})
    const newItem = new AEvent(data)
    Object.assign(this.table, {[newItem.id]: newItem})
    newItem.save()
    return newItem
  }
  // Méthode pour actualiser l'évènement
  static update(data){
    const item = this.get(data.id)
    item.update(data)
    item.save()
  }
  /**
  Méthode pour charger l'évènement (à partir de ses données)
    - crée l'instance
    - l'ajoute à la table des évènements
    - l'ajoute au listing
  */
  static addFromData(data){
    const item = new AEvent(data)
    if ( item.id > this.lastId ) this.lastId = Number(item.id)
    Object.assign(this.table, {[item.id]: item})
    this.listing.add(item)
  }
  // Appelé par le listing quand on détruit un item
  static onDestroy(item){
    Ajax.send('destroy_event.rb', {event_id: item.id})
    .then(() => {
      delete this.table[item.id]
    })
  }

  /**
  * Méthode appelée quand on sélectionne un item dans le listing
  ***/
  static onSelect(item){
    const followItem = DGet('input#follow-selected-event').checked
    followItem && (video.time = item.data.time)
  }

  static get PROPERTIES(){
    if (undefined == this._properties){
      this._properties = [
          {name:"content", hname:"Contenu", type:'textarea', required:false}
        , {name: "type", hname:'Type', type:'text', form:"buildMenuType", setter:"setType", getter:"getType", default:'no'}
        , {name:'time', hname:"Temps", type:'number', vtype:'text', setter:"setTemps", getter:'getTemps', placeholder: 'Cliquez le point-temps sur la vidéo'}
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
        , dn: {id:'dn', hname:'Début Dénouement'}
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
    var ty = this.menuType.value
    if ( ty == 'nc' ) ty += `:${this.menuTypeNoeud.value}`
    return ty
  }
  static setType(v){
    var nt ;
    if ( v.match(':') ) { v, nt = v.split(':')}
    this.menuType.value = v
    nt && $(this.menuTypeNoeud).val(nt)
  }
  static get menuType(){return this._menutype || (this._menutype = document.querySelector('select#item-type'))}
  static get menuTypeNoeud(){return this._menutynoeud || (this._menutynoeud = document.querySelector('select#item-ntype'))}

  // --- Méthode pour le temps de l'évènement ---
  static getTemps(){
    var v = this.tempsField.value
    if (v == '') v = video.time
    else { v = h2t(v) }
    console.log("Temps retourné : ", v)
    return v
  }
  static setTemps(v){
    this.tempsField.value = t2h(v)
  }
  static get tempsField(){
    return this._tpsfield || (this._tpsfield = this.listing.obj.querySelector('#item-time'))
  }

  // Initialisation
  static init(){
    this.lastId = 0 // avant de charger le film
    this.listing // simplement pour voir ce que fait l'initialisation
    this.table = {}
  }

  static getNewId(){
    ++this.lastId
    return this.lastId
  }

  static get listing(){
    return this._listing || (this._listing = new Listing(this, {
        titre: "Évènements d'analyse"
      , container: DGet("div#container-listing")
      , id: "aevents"
      , createOnPlus: true
      , sortable: false
    }))
  }


constructor(data) {
  this.data = data
  this.id       = data.id
  this.content  = data.content
}
get li(){
  const LI = DCreate("LI", {id: `aevent-${this.id}`, class:"listing-item li-aevent", text:this.content})
  return LI
}

update(data){
  this.data = data
}

save(){
  return Ajax.send('save_event.rb', {data: this.data}).then(ret => console.log(ret))
}

}
