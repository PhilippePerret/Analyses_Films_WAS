'use strict';

const TABS = ['home','crop','analyse','export'];

class UI {

static init(){
  return new Promise((ok,ko) => {
    DGet('button#btn-force-reload').addEventListener('click', this.onClickReload.bind(this))
    ok()
  })
}

static onClickReload(){
  window.location.href = window.location.href.split('?')[0] + `?at=${new Date().getTime()}`
}

static toggle(obj){
  this.showIf(obj, obj.classList.contains('hidden'))
}

/**
* Pour savoir qui a le focus et à qui, donc, on doit envoyer les évènements
***/
static setFocusOn(what){
  if ( this.focusedObject ) {
    this.focusedObject.obj.classList.remove('focused')
  }
  DGet('#mode-focus').textContent = `focus on ${what.name}`
  this.focusedObject = what
  this.focusedObject.obj.classList.add('focused')
}

/**
* Fin de l'initialisation, c'est-à-dire lorsque tout est prêt
***/
static endInit(){
  this.observeEditFieldsIn(document)
  this.setBody()
}

static observeEditFieldsIn(container){
  container.querySelectorAll('textarea, input[type="text"]').forEach(el => {
    el.addEventListener('focus', this.onFocusTextField.bind(this))
    el.addEventListener('blur',  this.onBlurTextField.bind(this))
  })
  container.querySelectorAll('select').forEach(el => {
    el.addEventListener('focus', this.onFocusSelect.bind(this))
    el.addEventListener('blur',  this.onBlurSelect.bind(this))
  })
}


static setBody(){
  // Pour fixer la taille du body car beaucoup d'éléments sont absolus
  document.querySelector('body').style.height = px(window.innerHeight)
}

static onFocusTextField(ev){
  message(`Utiliser ${Aide.img('J',{ctrl:true})}, ${Aide.img('K',{ctrl:true})}, ${Aide.img('L',{ctrl:true})} pour contrôler la vidéo.`, {keep:false})
  setModeClavier('text')
}
static onBlurTextField(ev){
  setModeClavier('command')
}
static onFocusSelect(ev){
  setModeClavier('select')
}
static onBlurSelect(ev){
  setModeClavier('command')
}

/**
* Insertion des éléments HTML (briques)
***/
static insertHTMLElements(){
  __in("UI::insertHTMLElements")
  return UI.insert('panneau-home','div#panneau-home')
  .then(UI.insert.bind(UI, 'form_data_analyse', 'div#form_data_analyse'))
  .then(UI.insert.bind(UI, 'form_infos_score_analyse', 'div#form_infos_score_analyse'))
  // Insérer d'autres éléments ici
  .then(ASync_out("UI::insertHTMLElements"))
}

/**
* Méthode qui règle l'interface en fonction des données connues
* Par exemple, les onglets ne seront pas accessibles si aucun dossier
* d'analyse n'est choisi.
***/
static async setInterface(){
  __in("UI::setInterface")

  __out("UI::setInterface")
}

static observe(){
  __in("UI::observe")
  return new Promise((ok,ko)=>{
    __out("UI::observe")
    ok()
  })
}

/** ---------------------------------------------------------------------
    MÉTHODES PUBLIQUES

    !!! NE RIEN TOUCHER CI-DESSOUS !!!
--------------------------------------------------------------------- **/

/**
* Quand on doit ajouter/retirer la class CSS +css+ de l'objet +obj+
* suivant que +condition+ est vrai ou fausse
***/
static addClassIf(obj, condition, css){
  $(obj)[condition?'addClass':'removeClass'](css)
}

/**
* Affiche ou masque l'objet +obj+ suivant la condition +condition+
***/
static showIf(obj, condition){
  return this.addClassIf(obj, !condition, 'hidden')
}

// Observer le clic sur l'élément DOM +button+ en actionnant la méthode
// +method+
static listenClick(button, method){
  this.listen(button,'click',method)
}
// Inverse de la précédente
static unlistenClick(button, method){
  this.unlisten(button,'click',method)
}

static listen(button, evType, method){
  button.addEventListener(evType,method)
}
static unlisten(button, evType, method){
  button.removeEventListener(evType,method)
}


/**
  Méthode qui insert la brique html de chemin relatif +fname+ (dans ./html)
  dans le container +container+.
**/
static insert(fname, container = document.body){
  return new Promise((ok,ko)=>{
    Ajax.send('system/get-brique.rb', {rpath: fname})
    .then(ret => {
      if ( 'string' == typeof container ) { container = document.querySelector(container) }
      container.insertAdjacentHTML('beforeend', ret.brique)
      ok(ret)
    })
  })
}
}
