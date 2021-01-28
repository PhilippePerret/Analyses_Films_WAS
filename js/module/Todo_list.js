'use strict'
/** ---------------------------------------------------------------------
  * Module pour tenir à jour une todo liste pour l'application ou
  * une partie de l'application.
  *
*** --------------------------------------------------------------------- */
class TodoList {
static newId(){
  if (undefined == this.lastId) this.lastId = 0
  return ++this.lastId
}
constructor(owner, path) {
  this.owner = owner
  this.path  = path
  this.id    = this.constructor.newId()
}

/**
* Méthode pour classer les tâches
  - par priorité,
  - par tag,
  - par date ?
  - autre ?
***/
sortTasks(by){
  if ( by == 'priority' ) {
    // Classement par priorité
    this.tasks.sort(this.sortingMethodByPriority.bind(this))
    this.tasks.forEach(task => this.list.appendChild(task.obj))
  } else {
    // Classement en mettant les tags du type +by+ au-dessus
    // (note : ce qui correspond à mettre toutes les autres en dessous)
    this.tasks.forEach(task => {
      if (task.hasTag(by)) return
      else this.list.appendChild(task.obj)
    })
  }
}
sortingMethodByPriority(a, b){
  return (a.priority||0) > (b.priority||0) ? -1 : 1
}

/**
* Méthode appelée quand on doit supprimer les tâches cochées
***/

onClickSuppChecked(ev){
  var tasksToSave = []
  this.tasks.forEach(task => {
    if ( task.isChecked ){
      task.obj.remove()
      return
    } else tasksToSave.push(task)
  })
  this.tasks = tasksToSave
  this.save()
  return stopEvent(ev)
}
onClickFermer(ev){
  this.close()
  return stopEvent(ev)
}
createNewTask(line){
  console.log("OK,  je crée '%s'", line)
  const newTask = new TodoTask(this, line)
  this.tasks.push(newTask)
  this.save()
  this.list.appendChild(newTask.obj)
  message("La nouvelle tâche a été créée et enregistrée.")
}

open(callback){
  console.log("Ok, j'ouvre")
  if ( ! this.built ) {
    this.loadAndBuild(this.open.bind(this,callback))
    console.log("Je reviens de loadAndBuild")
  } else {
    console.log("La liste des tâches est prête")
    this.obj.classList.remove('hidden')
    this.sortTasks('priority')
    callback && callback()
  }
}
close(){
  this.obj.classList.add('hidden')
}

/**
* Chargement et construction de la liste
***/
loadAndBuild(callback){
  console.log("-> loadAndBuild")
  return this.load(this.build.bind(this,callback))
}
/**
* Construction de la todolist
***/
build(callback){
  console.log("-> build")
  const oid = `todo-list-${this.id}`

  const otasks = []
  this.tasks.forEach(task => otasks.push(task.obj))
  this._list = DCreate('DIV', {class:'task-list', inner:otasks})

  const buttons = [
      DCreate('button',{id:'todolist-btn-sup-checked', type:'button', text:'Retirer les cochées'})
    , DCreate('button',{id:'todolist-btn-close', type:'button', text:'Fermer'})
  ]

  const o = DCreate('DIV',{id:oid, class:'todolist frontPanel',inner:[
      DCreate('DIV',{text:'Todo List', class:'main-titre'})
    , this.list
    , DCreate('DIV',{class:'buttons', inner:buttons})
  ]})
  this.obj = o
  this.observe()
  this.built = true
  document.body.appendChild(this.obj)
  callback && callback.call()
}
rebuild(){
  this.obj && this.obj.remove()
  this.obj = null
  this.built = false
  this.build()
}
observe(){
  DGet('#todolist-btn-sup-checked',this.obj).addEventListener('click', this.onClickSuppChecked.bind(this))
  DGet('#todolist-btn-close', this.obj).addEventListener('click', this.onClickFermer.bind(this))
}

/**
* Chargement de la todolist
***/
load(callback){
  console.log("-> load")
  return Ajax.send('system/todolist_load.rb', {relpath: this.path}).then(ret => {
    this.tasks = []
    ret.tasks.forEach(line => this.tasks.push(new TodoTask(this,line)))
    console.log("Tasks chargées")
    callback && callback.call()
  })
}

/**
* Sauvegarde des tâches
***/
save(){
  Ajax.send('system/todolist_save.rb', {relpath:this.path, tasks:this.getDataTasks()})
}
// Retourne les données des tâches pour les enregistrer
getDataTasks(){
  var d = []
  this.tasks.forEach(tasks => d.push(tasks.line))
  return d
}

get list(){ return this._list }

}//class TodoList



class TodoTask {
static newId(){
  if(undefined == this.lastId) this.lastId = 0
  return ++this.lastId
}
constructor(todolist, line) {
  this.list = todolist
  this.line = line
  this.id = this.constructor.newId()
}

get obj(){return this._obj || this.build() }
set obj(v){this._obj = v}
/**
* Méthode appelée quand on clique sur le cb de la tâche
***/
onClickCB(ev){
  message("Click sur checkbox de "+this.formated_text + " : " + (this.cb.checked ? 'ON' : 'OFF'))
}

get isChecked(){return this.cb.checked == true}

/**
* Méthode appelée quand on clique sur la priorité
***/
onClickPriority(ev){
  this.list.sortTasks('priority')
  return stopEvent(ev)
}

/**
* Retourne TRUE si la tâche possède la tag +tag+
***/
hasTag(tag){
  return !!this.tableTags[tag]
}

/**
* Construction de la tâche
***/
build(){
  var inners = []
  const oid = `task-${this.id}`
  inners.push(DCreate('INPUT',{type:'checkbox',id:`${oid}-cb`}))
  inners.push(DCreate('LABEL',{for:`${oid}-cb`, text:this.formated_text}))
  this.tags.forEach(tag => inners.push(tag.span))
  const o = DCreate('LI', {id:oid,class:'task', inner:inners})
  this.obj = o
  this.observe()
  return o
}
observe(){
  this.cb.addEventListener('click', this.onClickCB.bind(this))
  if (this.priority){
    DGet('.todolist-priority',this.obj).addEventListener('click', this.onClickPriority.bind(this))
  }
}

get formated_text(){
  return this._fline || this.parseLine()
}

parseLine(){
  const my = this
  const tags = []
  this.tableTags = {}
  var lin = this.line.replace(/ ?P:([1-9]) ?/i,(tout, priority) => {
    my.priority = priority && Number(priority)
    return ''
  })
  lin = lin.replace(/ ?T:([a-zA-Z0-9_]+) ?/ig, (tout, tag) => {
    const itag = new TodoTag(this, tag)
    tags.push(itag)
    Object.assign(this.tableTags, {[tag]: itag})
    return ''
  })
  if ( this.priority ) {
    var mark = ""
    for(var i = 0; i < this.priority;++i){mark += '!'}
    lin = lin + `<span class="todolist-mark todolist-priority">${mark}</span>`
  }
  this._fline = lin
  this._tags  = tags
  return this._fline
}

get cb(){return this._cb || (this._cb = DGet('input[type="checkbox"]', this.obj) )}

get tags(){
  this._tags || this.parseLine()
  return this._tags
}

} // class TodoTask

class TodoTag {
static add(tag){
  if ( undefined == this.table ) this.table = {}
  this.table[tag.text] || Object.assign(this.table, {[tag.text]: []})
  this.table[tag.text].push(tag)
}
/** ---------------------------------------------------------------------
*
*   INSTANCE TodoTag
*
*** --------------------------------------------------------------------- */
constructor(task, text) {
  this.task = task
  this.text = text
  this.constructor.add(this)
}

/**
* Méthode appelée quand on clique sur le span du tag
***/
onClickOnTag(ev){
  this.task.list.sortTasks(this.text)
  return stopEvent(ev)
}


build(){
  const o = DCreate('SPAN', {class:'todolist-mark todolist-tag', text: this.text})
  this._span = o
  this.observe()
  return this._span
}
observe(){
  this.span.addEventListener('click', this.onClickOnTag.bind(this))
}

get span(){return this._span || this.build() }
}
