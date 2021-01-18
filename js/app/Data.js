'use strict'

const LIEUX_SCENES = {
    i: {id:'i',   hname:'Int.'}
  , e: {id:'e',   hname:'Ext.'}
  , ie:{id:'ie',  hname:'I./E.'}
  , x: {id:'x',   hname:'Noir'}
}

const EFFETS_SCENES = {
    j: {id:'j',   hname:'Jour'}
  , n: {id:'n',   hname:'Nuit'}
  , m: {id:'m',   hname:'Matin'}
  , s: {id:'s',   hname:'Soir'}
  , jn:{id:'jn',  hname:'Jr/Nt'}
  , x: {id:'x',   hname:'Aucun'}
}

const TYPES_EVENT = {
    sc: {id:'sc', hname: "Scène",     letter:'s'}
  , nc: {id:'nc', hname: "Nœud clé",  letter:''}
  , no: {id:'no', hname: "Note",      letter:'n'}
  , if: {id:'if', hname: 'Info',      letter:'i'}
}

const TYPES_NOEUDS_CLES = {
  zr: {id:'zr', hname:'Point Zéro'}
, ex: {id:'ex', hname:'Début Exposition'}
, ip: {id:'ip', hname:'Incident perturbateur'}
, id: {id:'id', hname:'Incident déclencheur'}
, p1: {id:'p1', hname:'Premier pivot'}
, dv: {id:'dv', hname:'Début Développement'}
, t1: {id:'t1', hname:'Scène de 1er tiers'}
, cv: {id:'cv', hname:'Clé de voûte'}
, d2: {id:'d2', hname:'Développement part II'}
, t2: {id:'t2', hname:'Scène de 2nd tiers'}
, cr: {id:'cr', hname:'Crise (développement)'}
, p2: {id:'p2', hname:'Pivot 2'}
, dn: {id:'dn', hname:'Début Dénouement'}
, cd: {id:'cd', hname:'Crise (dénouement)'}
, cx: {id:'cx', hname:'Climax'}
, de: {id:'de', hname:'Désinence'}
, pf: {id:'pf', hname:'Point Final'}
}
