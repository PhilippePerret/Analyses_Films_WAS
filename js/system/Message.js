'use strict';

function message(msg, options){
  (new Message(msg)).display(options)
}
function erreur(msg, options){
  if (undefined != msg.message){
    console.error(msg)
    msg = msg.message
  }
  (new Message(msg, 'error').display(options))
}
function suivi(msg, debugLevel){
  if (DEBUG_LEVEL < debugLevel) return
  console.log('%c'+msg, 'font-family:courier;font-size:8pt;color:grey;margin-left:2em;')
}

window.error = window.erreur.bind(window)

class Message {
  static get obj(){
    if (undefined === this._obj){
      this._obj = DCreate('DIV', {id:'messages-container'})
      document.body.appendChild(this._obj)
    }; return this._obj;
  }

  constructor(str, type){
    this.str = str
    this.type = type // peut-être 'error' ou rien
    this.correctText()
  }
  get div(){
    if ( undefined === this._div){
      let css = ['message']
      if ( this.type == 'error' ) css.push('error')
      this._div = DCreate('DIV',{class:css.join(' '), text:this.str})
    }; return this._div;
  }
  correctText(){
    this.str = String(this.str).replace(/\r?\n/g, '<br> '/* espace utile pour comptage mots */)
  }
  display(options){
    options = options || {}
    if ( options.cleanup || false === options.keep) {
      this.constructor.obj.innerHTML = ''
    }
    this.constructor.obj.appendChild(this.div)
    if ( !(options.timer === false)){
      this.timer = setTimeout(this.remove.bind(this), 1000 * this.tempsLecture)
    }
  }
  remove(){
    this.div.remove()
  }
  get tempsLecture(){
    return this.str.split(' ').length * 2
  }
}
