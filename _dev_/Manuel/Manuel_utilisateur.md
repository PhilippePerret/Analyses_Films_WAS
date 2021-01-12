# Analyses films<br>Manuel utilisateur



## Introduction

L’application « Analyseur de Films » permet de procéder à l’analyse « simple » des films, aidés de la vidéo.

De façon résumée, l’analyse consiste à enregistrer des « évènements » qui sont autant de points-clé dans le film permettant d’écrire toutes les notes qu’on veut.



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



### Choisir un endroit précis dans le film avec la souris

* Se déplacer sur la vidéo horizontalement pour choisir l’endroit approximatif
* cliquer pour « geler » la vidéo
* rectifier le point en déplaçant les flèches gauche/droite.



### Choisir un endroit précis dans le film avec la console

`+ <s>` permet de se déplacer de `<s>` secondes en avant.

`- <s>` permet de se déplacer de `<s>` secondes en arrière.

`goto h:m:s.fr` permet de rejoindre le temps désigné par cette horloge (les frames vont de 0 à 25, 25 correspondant à une seconde).