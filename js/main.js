'use strict';

$(document).ready(function(){
  UI.insert("video", "body")
  .then(UI.insert.bind(UI, "listing", "div#rigth-margin"))
  .then(UI.insert.bind(UI, "editor", "div#rigth-margin"))
  .then(App.init.bind())
  .then(Film.load.bind())
})
