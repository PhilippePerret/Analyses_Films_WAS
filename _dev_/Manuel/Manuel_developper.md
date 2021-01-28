# Analyses films<br>Manuel développeur

Les modules javascript sont pensés « en composant ». Pour commencer, à chaque élément de l’interface (console, vidéo, horloge, etc.) correspond un module de même nom.

## Composants

Les « composants » de l’application sont des classes qui permettent de gérer chacun un élément particulier du programme. On trouve :

| Composant                 | Description                                                                                                                   |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| [Film](#film)             | Gère les films et notamment le film courant, édité.                                                                           |
| [Video](#video)           | Gère la vidéo au plus bas niveau. Note : c’est le Controller qui permet de la contrôler au niveau plus haut de l’utilisateur. |
| [Controller](#controller) | Contrôle la vidéo au plus haut niveau (interface utilisateur)                                                                 |
| [Locators](#locators)     | Gère les points-clés du film qui permettent de se déplacer avec plus de souplesse.                                            |
| [AEvent](#aevents)        | Gère les évènements d’analyse, c’est-à-dire tous les textes situés sur la timeline du film.                                   |
| [AEventEditor](#editor)   | Utilisé pour l’édition séparé d’un évènement (permettant de naviguer dans les autres évènements)                              |
| [Horloge](#horloge)       | Gère l’horloge qui permet de savoir où on se trouve dans le film.                                                             |
| [Console](#console)       | Gère la console qui permet de commande l’application en ligne de commande.                                                    |
|                           |                                                                                                                               |
|                           |                                                                                                                               |

## Détail des composants

<a id="film"></a>

### Composant « Film »

<a id="video"></a>

### Composant « Video »

<a id="controller"></a>

### Composant « Controller »

<a id="locators"></a>

### Composant « Locators »

Les locateurs s’affichent dans le [controller](#controller). C’est une classe listing, c’est-à-dire utilisant le module `listing.js` pour gérer automatiquement les listes.

Chaque locateur n’est composé que de deux attributs, `time` et `name`. 

TODO : On pourrait, à l’avenir, imaginer une 3e propriété `category` qui permettrait de classer les locateurs par catégorie.

<a id="aevents"></a>

### Composant « AEvents »

<a id="editor"></a>

### Composant « Editor »

<a id="horloge"></a>

### Composant « Horloge »

<a id="console"></a>

### Composant « Console »

---

## Annexe

### Notes

#### [N001]

La durée du film depuis le point-zéro jusqu’au point-final peut varier de la durée totale des scènes. Cela se produit dès que le point-zéro n’est pas défini comme début de la première scène. Pour le calcul des pourcentages et en général des statistiques concernant les scènes, on doit se servir de la durée totale d’après les scènes.