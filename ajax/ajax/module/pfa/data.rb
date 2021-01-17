# encoding: UTF-8
# frozen_string_literal: true

# Données pour le dessins du PFA
# Les points sont pensés sur une distance totale de 120
DATA_PFA = {
  zr:  {id:'zr', hname: 'Point Zéro', type: :system},
  # = EXPOSITION =
  ex:  {id:'ex', hname: 'EXPOSITION', dim:'EXPO', start:0, end: 30, type: :part, inner: [:pre, :ip, :id, :rf, :p1]},
  pre: {id:'pre', hname: 'Prélude', mark:'PR', start:0,        end:12, type: :seq, no_horloge:true},
  ip:  {id:'ip',  hname: 'I.P.',        start:12,       end:(12+2), type: :noeud},
  id:  {id:'id',  hname: 'I.D.',        start:20 ,      end:(20+2), type: :noeud},
  rf:  {id:'rf',  hname: 'Refus', mark:'RF', start:(30 - 7), end:(30 - 2), type: :seq},
  p1:  {id:'p1',  hname: 'Pvt1', mark:'P1', start:(30 - 2), end:30, type: :noeud},
  # = DÉVELOPPEMENT =
  dv:  {id:'dv', hname: 'DEVELOPPEMENT (PART I)', dim:'DEV.P1', start:30, end:60, type: :part, inner: [:t1, :cv]},
  t1:  {id:'t1',  hname: '1/3',         start:(40 - 2), end:(40 + 2), type: :noeud},
  cv:  {id:'cv',  hname: 'CdV', mark:'CV', start:(60 - 2), end:(60 + 2), type: :noeud},
  d2:  {id:'d2', hname: 'DEVELOPPEMENT (PART II)', dim:'DEV.P2', start:60, end:90, type: :part, inner:[:t2,:cr,:p2]},
  t2:  {id:'t2',  hname: '2/3',         start:(80 - 2), end:(80 + 2), type: :noeud},
  cr:  {id:'cr',  hname:'Crise', mark:'CR', start:(90 - 6), end:(90 - 2), type: :noeud},
  p2:  {id:'p2',  hname:'Pvt2', mark:'P2', start:(90 - 2), end:90, type: :noeud},
  # = DÉNOUEMENT =
  dn:  {id:'dn', hname: 'DENOUEMENT', dim:'DEN.', start:90, end: 120, type: :part, inner:[:cx, :de]},
  cx:  {id:'cx',  hname:'Climax', mark:'CX', start:(120 - 12), end:(120 - 2), type: :noeud},
  de:  {id:'de',  hname:'Dés.', mark:'DS', start:(120 - 2),  end:120, type: :seq},
  pf:  {id:'pf', hname:'Point Final', type: :system}
}
