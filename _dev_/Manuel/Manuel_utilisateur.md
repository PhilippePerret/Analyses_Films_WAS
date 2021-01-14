# Analyses films<br>Manuel utilisateur



## Introduction

L’application « Analyseur de Films » permet de procéder à l’analyse « simple » des films, aidés de la vidéo.

De façon résumée, l’analyse consiste à enregistrer des « évènements » qui sont autant de points-clé dans le film permettant d’écrire toutes les notes qu’on veut.

---

## Première analyse (ou reprise après absence)

Voici la procédure pour une première analyse ou pour reprendre en main l’application après un long moment sans l’utiliser.

* Dans le dossier `_FILMS_` de l’application, mettre le dossier du film analysé (regarder sur un disque dur) ou le créer,
* Si c’est une création, il faut créer un fichier `config.yml` en s’inspirant du dossier `_FILMS_/Essai` et il faut mettre la vidéo dans le dossier,
* Dans le fichier `_FILMS_/CURRENT`, mettre le nom de ce dossier du film,
* Lancer l’application à l’aide de l’adresse : [`http://localhost/Analyses_Films_WAS`](http://localhost/Analyses_Films_WAS)
* Jouer le raccourci `Cmd K` pour afficher le contrôleur,
* Jouer les touches `L`, `K` ou `J` pour lancer la lecture, l’arrêter ou revenir en arrière,
* Une fois à l’endroit voulu, se placer dans le champ « contenu » de la liste des évènements d’analyse (note : cela ferme le contrôleur)
* Écrire le contenu de la scène par exemple, choisir le type « Scène » et cliquer sur le bouton « + »,
* Le nouvel évènement d’analyse est automatiquement créé et enregistré. Le nouvel évènement est ajouté à la liste. Il suffira de cliquer dessus pour revenir à cet endroit précis. Comme c’est une scène, l’évènement est aussi ajouté à la liste des scènes.
* Poursuivre ainsi jusqu’à obtenir tous les évènements d’analyse voulu, dans tous les types voulus.
* On peut utiliser la seconde vidéo pour visualiser des endroits sans bouger la vidéo principale. On peut s’en servir par exemple pour visualiser la scène courante. Si on ne se sert pas de cette seconde vidéo, on peut supprimer toutes les informations concernant `:video2` dans le fichier de configuration et recharger la page.



---



## Film analysé

Le film analysé doit être un dossier unique portant le nom du film (ou un diminutif) se trouvant dans le dossier `_FILM_` de l’application. Ce dossier doit au minimum contenir :

* la vidéo du film
* un fichier `config.yml` défini ci-dessous.

~~~
Analyses_Films_WAS/_FILMS_/<monFilm>/config.yml
												            /video.mp4

~~~



### Fichier `config.yml` du film

C’est le fichier qui définit le film courant. On trouve les propriétés suivantes :

~~~yaml
---
	:titre: Le titre du film
	:video:
		:width:	400 				// taille de la vidéo à afficher
		:name:  video.mp4		// nom dans ce dossier
		
	// optionnellement
	:personnages:
		:PR: <personnage>		// 2 lettres qui seules vont remplacer le personnage
												// dans les textes.
		:SA: <autre>				// Autre personnage
~~~



---



## Analyse

### Créer un évènement d'analyse

* Choisir son type dans le menu (scène, nœud clé, etc.),
* choisir le temps sur la vidéo en [navigant dans le film](#naviguer),
* rédiger le contenu de l'évènement
* cliquer sur le bouton « + » du listing d'éléments.

### Modifier un évènement d'analyse

* Le choisir dans la liste,
* modifier ses valeurs,
* cliquer sur le bouton « save ».

<a id="naviguer"></a>

## Naviguer dans le film

Pour naviguer dans le film, jouer la vidéo, etc. on utilise le contrôleur. Le contrôleur n’est pas ouvert par défaut (car il modifie la gestion des touches du clavier). On l’ouvre à l’aide `Cmd K`.

### Choisir un endroit précis dans le film avec la souris

* Se déplacer sur la vidéo horizontalement pour choisir l’endroit approximatif
* cliquer pour « geler » la vidéo
* si le contrôleur est ouvert, on peut rectifier le point en déplaçant les flèches gauche/droite.

### Rejoindre un signet

Des signets — c’est-à-dire des points précis dans le film — peuvent être définis à l’aide du [contrôleur][]. Il suffit de les cliquer dans la liste, ou d’utiliser une touche de 1 à 9 s’ils font partie des 9 premiers, pour rejoindre le temps correspondant.

### Choisir un endroit précis dans le film avec la console

`+ <s>` permet de se déplacer de `<s>` secondes en avant.

`- <s>` permet de se déplacer de `<s>` secondes en arrière.

`goto h:m:s.fr` permet de rejoindre le temps désigné par cette horloge (les frames vont de 0 à 25, 25 correspondant à une seconde).



## Le Contrôleur

Le contrôle permet de contrôler la vidéo et de mémoriser des points-clés, des signets, qui permettent de se déplacer avec plus d’aisance.



---

# Annexe

<a id="shortcuts"></a>

## Raccourcis clavier

### Commande du contrôleur

| Action attendue | Raccourci     | Description du raccourci / options       |
| ----------------------- | ------------------------ | ------------------------------------------------------------ |
| Jouer la vidéo active   | ![K_L](K_L.png)          | En appuyant plusieurs fois sur la touche, on accélère la vidéo. |
| Stopper la vidéo active | ![K_K](K_K.png)          |                                                              |
| Jouer en arrière        | ![K_J](K_J.png)          | Appuyer plusieurs fois pour changer la vitesse (accélérer)   |
| Avancer d’une image     | ![][ArrowRight]          |                                                              |
| Reculer d’une image     | ![][ArrowLeft]           |                                                              |
| Avancer d’1 seconde     | ![][Cmd]![][ArrowRight]  |                                                              |
| Reculer d’1 seconde     | ![][Cmd]![][ArrowLeft]   |                                                              |
| Avancer de 10 secs      | ![][Maj] ![][ArrowRight] |                                                              |
| Reculer de 10 secs      | ![][Maj]![][ArrowLeft]   |                                                              |
| Aller au signet suivant | ![][Cmd]![][ArrowDown] | |
| Aller au signet précédent | ![][Cmd]![][ArrowUp] | |

<a id="shortcuts-event-editor"></a>

### Commande de l’éditeur d'évènement

| Action attendue                    | Raccourci      | Description du raccourci/options         |
| ---------------------------------- | -------------- | ---------------------------------------- |
| Enregistrer l'event                | ![][K_S]       |                                          |
| Focusser dans le champ de texte    | ![][K_T]       |                                          |
| Actualiser le temps                | ![][K_U]       | En prenant celui de la vidéo active.     |
| Sélectionner l’évènement suivant   | ![][ArrowDown] | Ou le premier si aucun n’est sélectionné |
| Sélectionner l’évènement précédent | ![][ArrowUp]   | Ou le dernier si aucun n’est sélectionné |
|                                    |                |                                          |
|                                    |                |                                          |





[K_S]: ./img/clavier/K_S.png
[K_T]: ./img/clavier/K_T.png
[K_U]: ./img/clavier/K_U.png
[Cmd]: ./img/clavier/K_Command.png
[Maj]: ./img/clavier/K_Maj.png
[ArrowRight]: ./img/clavier/K_FlecheD.png
[ArrowLeft]: ./img/clavier/K_FlecheG.png
[ArrowDown]: ./img/clavier/K_FlecheB.png
[ArrowUp]: ./img/clavier/K_FlecheH.png

[contrôleur]: #controller

