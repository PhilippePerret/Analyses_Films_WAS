'use strict';

$(document).ready(function(){
  UI.insert("video", "div#video-container")
  .then(UI.insert.bind(UI, "editor", "div#rigth-margin"))
  .then(UI.insert.bind(UI, "controller", "div#controller-container"))
  .then(App.init.bind(App))
  .then(Film.load.bind(Film))
})
