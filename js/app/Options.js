'use strict'

const DATA_OPTIONS = {
    video_follows_mouse: {hname:'La vidéo suit la souris quand la souris se déplace sur elle.'}
  , synchro_videos_on_stop: {hname:'Synchronise les vidéos au stop'}
  , follow_selected_event: {hname: 'Suivre l’évènement sélectionné dans la liste'}
  , show_current_event: {hname:'En jouant, afficher l’évènement le plus proche'}
  , memorize_last_time: {hname:'Mémoriser le dernier temps joué'}
}

class Options {

// ---------------------------------------------------------------------
//  Public Methods

/**
* Initialise les options
***/
static init(){
  this.items = {}
  this.build()
}

/**
* Retourne TRUE de l'option +koption+ est cochée
***/
static option(koption){
  return this.get(koption).isChecked()
}

/**
* Retourne l'instance Option de l'option de clé +optKey+
***/
static get(optKey) { return this.items[optKey] }

/**
* Règle les valeurs de toutes les options
***/
static set(){
  Object.values(this.items).forEach(option => option.set())
}
// /Public Methods
// ---------------------------------------------------------------------


/**
* Construit les options
***/
static build(){
  for(var k in DATA_OPTIONS){
    const opt = new this(k, DATA_OPTIONS[k])
    Object.assign(this.items, {[k]: opt})
    opt.build()
    opt.observe()
  }
}

static defaultize(opts = {}){
  this.keys.forEach( kopt => {
    if (undefined === opts[kopt]) Object.assign(opts, {[kopt]: true})
  })
  return opts
}

static get keys(){return this._keys || (this._keys = Object.keys(DATA_OPTIONS))}
static get oOptions(){return this._ooptions || (this._ooptions = DGet('div#video-options'))}

/** ---------------------------------------------------------------------
*
*   INSTANCE
*
*** --------------------------------------------------------------------- */
constructor(key, data) {
  this.key  = key
  this.data = data
}

isChecked(){ return this.obj.checked === true }

/**
* Pour régler la valeur de l'option (en la prenant dans les options du film)
***/
set(){
  this.obj.checked = film.options[this.key]
}

build(){
  this.obj = DCreate('input',{type:'checkbox', id:this.key})
  this.class.oOptions.appendChild(DCreate('div',{inner:[
      this.obj
    , DCreate('label',{for:this.key, text: this.data.hname})
  ]})
)
}

observe(){
  this.obj.addEventListener('click', this.onChange.bind(this))
}

onChange(ev){
  film.options[this.key] = film.config.options[this.key] = this.obj.checked
  film.save()
  if ( this.key == 'show_current_event' ) {
    video._showcurevent = null
    video2 && (video2._showcurevent = null)
  }
}

get class(){return this.constructor}
}
