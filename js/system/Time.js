'use strict'
/** ---------------------------------------------------------------------
*   Méthodes de gestion du temps
*

100 = 16
100 * 16 / 100 = 16
*** --------------------------------------------------------------------- */

// Transforme un temps en secondes et frames en horloge
function s2h(s){
  const fs = Math.floor((s % 1) * 25) // 25 frames/seconds
  s = parseInt(s, 10)

  const h = Math.floor(s / 3600)
  s = s % 3600
  const m = Math.floor(s / 60)
  s = s % 60
  return `${h}:${m<10?'0':''}${m}:${s<10?'0':''}${s}.${fs<10?'0':''}${fs}`
}
function t2h(v){return s2h(v)} // alias

// Reçoit une horloge et retourne un temps en seconds (+ décimales)
function h2t(hr){
  var fr = 0, sc = 0
  if ( hr.indexOf('.') > -1 ) {
    [hr, fr] = hr.split('.')
    fr = (parseInt(fr, 10) / 25)
  }
  const l = hr.split(':').reverse()
  sc = parseInt(l[0],10)
  if ( l[1] ) sc += parseInt(l[1]*60,10)
  if ( l[2] ) sc += parseInt(l[2]*3600,10)
  return  sc + fr
}