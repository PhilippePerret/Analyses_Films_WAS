'use strict';

$(document).ready(function(){
  UI.insert("video", "body")
  .then(UI.insert.bind(UI, "editor", "div#rigth-margin"))
  .then(App.init.bind(App))
  .then(Film.load.bind(Film))
})
