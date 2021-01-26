# encoding: UTF-8
# frozen_string_literal: true

# Table des documents qui sont créés de façon automatique
AUTO_DOCUMENTS = {
  'cover.html'        => {hname:'Couverture'},
  'pfa.jpg'           => {hname:'Paradigme de Field Augmentée du film'},
  'synopsis.html'     => {hname:'Synopsis'},
  'sequencier.html'   => {hname:'Séquencier'},
  'traitement.html'   => {hname:'Traitement'},
  'statistiques.html' => {hname:'Statistiques'},
  'composition.html'  => {hname:'Page d’information sur la composition du livre'},
  'quatrieme.html'    => {hname:'Quatrième de couverture'}
}

TYPES_EVENTS = {
  'sc' => {hname:"scène"},
  'no' => {hname:"note"},
  'nc' => {hname:"nœud-clé"}
}

LIEUX = {
  i: {hname: 'Int.'},
  e: {hname: 'Ext.'},
  ie: {hname: 'Int./Ext.'},
  x: {hname: 'Noir'}
}

EFFETS = {
  j: {hname: "JOUR"},
  n: {hname: "NUIT"},
  m: {hname: "MATIN"},
  s: {hname: "SOIR"},
  jn: {hname: "JOUR/NUIT"},
  x: {hname: ''}
}
