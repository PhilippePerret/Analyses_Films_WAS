'use strict';

// DGet("video").src = '_FILMS_/Drive/extrait.mp4'

$(document).ready(function(){
  UI.insert("brique", "div#div-inserted")
  .then(UI.insert.bind(UI, "video", "div#div-video"))
  .then(Film.load.bind())
})
