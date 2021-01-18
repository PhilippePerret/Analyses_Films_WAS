# ANALYSES FILMS – Manuel utilisateur

[TOC]



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
* On peut commencer par définir le début et la fin « utiles » du film, c’est-à-dire le vrai temps zéro de l’analyse. Pour se faire, on se place aux endroits voulus, par exemple en cliquant sur la vidéo et  en ajustant avec les flèches, puis en créant les évènements « noeud-clé > Point Zéro » et le « Noeud-clé > Point Final ».
* Ensuite, jouer les touches `L`, `K` ou `J` pour lancer la lecture, l’arrêter ou revenir en arrière,
* Une fois à l’endroit voulu, on **crée un nouvel évènement d’analyse** : se placer dans le champ « contenu » de la liste des évènements d’analyse (par exemple en pressant ![][K_T]). Écrire le contenu de la scène par exemple, choisir le type « Scène » et cliquer sur le bouton « + »,
* Le nouvel évènement d’analyse est automatiquement créé et enregistré. Le nouvel évènement est ajouté à la liste. Il suffira de cliquer dessus pour revenir à cet endroit précis. Comme c’est une scène, l’évènement est aussi ajouté à la liste des scènes.
* Poursuivre ainsi jusqu’à obtenir tous les évènements d’analyse voulu, dans tous les types voulus.
* Si les points de début et de fin sont définis, on peut demander la visualisation des quarts et des tiers en cliquant sur ![][K_R].
* On peut utiliser la seconde vidéo pour visualiser des endroits sans bouger la vidéo principale. On peut s’en servir par exemple pour visualiser la scène courante. Si on ne se sert pas de cette seconde vidéo, on peut supprimer toutes les informations concernant `:video2` dans le fichier de configuration et recharger la page.
* Pour produire le PFA (c’est une image `pfa.jpg` qui sera construite dans le dossier du film), il faut définir les évènements minimaux. Pour savoir ceux qui manquent, il suffit de jouer la commande `pfa build` dans la console (taper ![][K_X] pour se placer dans la console) — tant que des points manquent ils sont indiqués.



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
		:name:  video.mp4		// nom de la vidéo dans ce dossier
		
	// === OPTIONS ===
	
	// Pour avoir une seconde vidéo de contrôle ou d’essai
	// Pour le moment, ce sera toujours la même
	:video2:
		:width: 200
		
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

<a id="grand-editor"></a><a id="grand-editeur"></a>

#### Grand éditeur (éditeur séparé)

Quand on doit éditer un évènement de façon « sérieuse », par exemple pour y ajouter des références à d’autres évènements, on utilise un « éditeur séparé » ou « grand éditeur ». Quand un évènement est édité dans cet éditeur séparé, on peut faire défiler la liste des évènements de façon normale, en restant dans cet éditeur. Cela permet d’ajouter facilement des références à d’autres évènements dans un évènement particulier.

Pour éditer un évènement d’analyse de cette manière, il suffit de le sélectionner dans la liste et de cliquer la touche ![][Return].



### Produire les livres

Pour produire les livres (ebook mobi, epub, pdf), il suffit de jouer la commande `build books` :

* Jouer ![][Escape] pour sortir d’un champ d’édition si l’on s’y trouve,
* jouer ![][K_X] pour se placer dans la console,
* taper la commande `build books`,
* presser la touche ![][Return] pour lancer la fabrication,
* attendre jusqu’à la fabrication complète des livres.

---

<a id="naviguer"></a>

## Naviguer dans le film

Pour naviguer dans le film, jouer la vidéo, etc. on utilise le contrôleur. Le contrôleur n’est pas ouvert par défaut (car il modifie la gestion des touches du clavier). On l’ouvre à l’aide `Cmd K`.

<a id="video-sensible-souris"></a>

#### Vidéo sensible à la souris

Avant toute chose, il faut noter les deux modes d'utilisation de la souris sur la vidéo (réglable avec la préférence « Vidéo sensible à la souris »). Dans le mode « sensible à la souris », l'image/le temps de la vidéo suit en direct la souris. Un clic permet de « figer » le temps.

### Choisir un endroit précis dans le film avec la souris

* Se déplacer sur la vidéo horizontalement pour choisir l’endroit approximatif (en se servant de la mini-horloge si [la vidéo n’est pas sensible à la souris](#video-sensible-souris))
* cliquer (pour « geler » la vidéo en mode sensible),
* on peut rectifier le point en déplaçant les flèches gauche/droite.

### Rejoindre un signet

Des signets — c’est-à-dire des points précis dans le film — peuvent être définis à l’aide du [contrôleur][]. Il suffit de les cliquer dans la liste, ou d’utiliser une touche de 1 à 9 s’ils font partie des 9 premiers, pour rejoindre le temps correspondant.

### Choisir un endroit précis dans le film avec la console

`+ <s>` permet de se déplacer de `<s>` secondes en avant.

`- <s>` permet de se déplacer de `<s>` secondes en arrière.

`goto h:m:s.fr` permet de rejoindre le temps désigné par cette horloge (les frames vont de 0 à 25, 25 correspondant à une seconde).

La commande `goto` permet également de rejoindre des points « absolu » du film (correspondant aux PFA absolu). Cf. [La commande `goto`](#commande-goto).



---



<a id="modes-clavier"></a>

## Les modes de clavier

Il existe deux modes de clavier selon qu’on se trouve ou non dans un champ de texte ou un menu select :

<a id="mode-commande"></a>

* Le « **mode de commande** ». C’est le mode par défaut, il permet de tout contrôler avec de simples touches le plus souvent, quelquefois un modifieur.<a id="mode-clavier-edition"></a>

  On peut trouver ci-dessous une [liste de tous les raccourcis clavier](#shortcuts-mode-commande).

  Noter que pour certaines touches (![][K_T], ![][K_S], etc.), le « focus » est important et il est déterminé par le cadre vert brillant autour de l’élément. Par exemple, lorsque l’on édite un évènement dans [l’éditeur séparé](#grand-editor), s’il a le focus (entouré en vert brillant) la touche ![][K_S] enregistre l’évènement édité, sinon elle enregistre l’évènement édité dans l’éditeur simple du listing.

* Le « **mode d'édition** ». C’est le mode lorsqu’on se trouve dans un champ de texte ou un menu. Il permet de jouer les touches normalement, notamment pour écrire un texte ou se déplacer dans le menu.

---

<a id="events"></a>

## Les évènements d'analyse

Les `évènements d'analyse` sont le résultat de la collecte et ce qui va permettre d'automatiser un peu le travail d'analyse du film.

### Les scènes

Les scènes sont un type très particulier d’évènement dans le sens où on peut définir, en plus des autres données, les propriétés :

* Le **Lieu**. Où se déroule la scène, en intérieur ou en extérieur.
* L'**Effet**. Le moment où elle se déroule, jour, nuit, etc.
* Le **Décor**. Le décor et sous-décor exact.

Par convention, la toute première ligne (i.e. premier paragraphe) est considéré comme le résumé de la scène. C’est lui qui est utilisé dans le listing et dans le séquencier produit (ainsi que dans toute référence qui est faite à la scène).

#### Édition des scènes

Noter que pour le moment, pour pouvoir éditer complètement une scène (i.e. définir son lieu, effet, décors, etc.) il faut l’éditer dans [l’éditeur séparé](#grand-editor). On peut l’éditer comme un autre évènement d’analyse seulement s’il faut juste changer son temps ou son texte.

#### Définition des décors

On définit les décors dans le fichier `config.yml` du film :

~~~yaml
...
decors:
	id_decor1:
		hname: Maison du héros
		items:
			id_sous_decor: Salon
      id_sdecor2: Chambre
  id_decor2:
  	hname: Usine du héros
  	items:
  		idsdec1: Bureau
  		idsdec2: Atelier
  		idscec3: Entrepôt
~~~

Pour ajouter un nouveau décor, il suffit de faire :

* ![][K_X] pour se placer dans la console,
* taper `open config `![][Return] pour ouvrir le fichier configuration
* ajouter les décors voulus
* taper `update`![][Return] dans la console pour actualiser l'affichage 



#### Influence sur l'analyse

Ces nouvelles propriétés permettent de définir des statistiques pour les livres d’analyse, dont :

* l’utilisation des décors,
* le temps passé en intérieur et en extérieur,
* le temps passé de jour et de nuit,
* la durée de présence des personnages (repérés dans les scènes).





---



## Le Contrôleur

Le contrôle permet de contrôler la vidéo et de mémoriser des points-clés, des signets, qui permettent de se déplacer avec plus d’aisance.

> Note : maintenant, il n’est plus dédié qu’aux signets.

On l’affiche grâce au raccourci  ![][Cmd]![][K_K].



---

<a id="videos"></a>

## Les vidéos

### Régler la vitesse

Pour régler la vitesse de la vidéo, il suffit de presser autant de fois que nécessaire la touche ![][K_L] qui permet de lancer la lecture. Avec la touche ![][Ctrl] appuyée, on ralentit la vitesse.

Plusieurs pressions sur la touche ![][K_L] (avec ou sans ![][Ctrl]) permettent de modifier la vitesse.

> Noter que dès qu’on arrête la lecture, la vitesse revient à son état initial, sauf si on l’a figée (cf. ci-dessous)

#### Figer la vitesse

Parfois il est intéressant de rester toujours à une même vitesse. Par exemple pour faire la relève des scène 2 fois plus vite en accélérant par 2. Dans ce cas, on coche la case « Figer la vitesse » qui permettra de ne pas faire varier la vitesse, quelles que soient les touches pressées.



<a id="use-two-videos"></a>

### Utiliser une seconde vidéo

On peut utiliser une seconde vidéo simplement en la définissant dans le fichier `config.yml` du film :

~~~yaml
---
	...
	:video2:
		:width: 200 # en général, assez petite
		# TODO Plus tard des options, comme le placement dans l'interface
		# pourront être déterminées.
~~~

---



### Naviguer dans la vidéo courante

Cf. [Naviguer dans le film](#naviguer) pour voir les multitudes de moyens de se déplacer dans la vidéo.



### Dessiner des repères sur la vidéo

Pour faciliter l’analyse, on peut placer des lignes repères qui indiquent les quarts et les tiers du film. 

En [mode commande][], il suffit de jouer la touche ![][K_R] pour afficher ou masquer les repères du paradigme de field, c’est-à-dire les quarts et les tiers. De la même manière, la section avant et après qui n’est pas utilisée est masquée (les génériques, en gros).

On peut aussi utiliser les commandes suivantes :

~~~
draw quarts			Pour afficher les quarts
draw tiers			Pour afficher les tiers
draw all				Pour afficher les quarts et les tiers
~~~

> ![][K_X] permet de se placer directement dans la console pour taper ces commandes et ![][Escape] permet d’en sortir aussitôt pour retrouver le mode de commande normal.



<a id="console"></id>

## La console

La console permet de lancer les commandes et notamment les commandes de construction de l’analyse qui produira les fichiers et les images du film analysé.

### Se placer dans/sortir de la console

Pour se placer rapidement dans la console, il suffit de jouer le raccourci ![][K_X] en mode de commande. On se retrouve alors en mode de texte. Pour quitter la console — et donc le mode de texte — et revenir en mode de commande, on suffit de sortir de la console avec ![][Tab] ou ![][Escape].



<a id="commandes-console"></a>

### Liste des commandes

| Action&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Commande&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options                                          |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Ouvrir quelque chose                                         | `open …`                                                     | Cf. [commande `open`](#commande-open)                        |
| Construire un élément                                        | `build …`                                                    | Cf. [commande `build`](#commande-build)                      |
| Se déplacer dans le film                                     | `goto …`                                                     | Cf. [commande `goto`](#commande-goto)                        |
| Actualiser les données du film                               | `update`                                                     | La commande est à utiliser, par exemple, lorsqu’on modifie la liste des personnages ou des décors. |

<a id="commande-open"></a>

| Objet ouvert                | Commande      | Description/options                                          |
| --------------------------- | ------------- | ------------------------------------------------------------ |
| Le dossier du film          | `open film`   | Ouvre le dossier du film dans le Finder                      |
| Le fichier de configuration | `open config` | Ouvre le fichier `config.yml` du film courant dans Atom (pour le moment). |
| L’image du PFA              | `open pfa`    | Il faut que l’image ait été construite avec succès par la commande `build pfa`. |

<a id="commande-build"></a>

#### Commande `build`

| Object construit | Commande           | Description/options                                          |
| ---------------- | ------------------ | ------------------------------------------------------------ |
| Tous les livres  | `build books`      | Construit tous les livres et les places dans le dossier `./finaux` du dossier du film. |
| PFA              | `build pfa`        | Construit une image (`pfa.jpg`) qu’il suffira de copier dans le livre |
| Séquencier       | `build sequencier` | Construit une page (format à voir) à introduire dans le livre. |
|                  |                    |                                                              |

<a id="commande-goto"></a>

#### Commande `goto`

| Lieu                   | Commande&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options                            |
| ---------------------- | ------------------------------------------------------------ | ---------------------------------------------- |
| Quart du film          | `goto quart`                                                 | Cf. la note ci-dessous.                        |
| Tiers du film          | `goto tiers`                                                 | Cf. la note ci-dessous.                        |
| Milieu                 | `goto milieu`                                                | Cf. la note ci-dessous                         |
| Deux tiers du film     | `goto deux-tiers`                                            | Cf. la note ci-dessous.                        |
| Trois-quart du film    | `goto trois-quarts`                                          |                                                |
| Une scène particulière | `goto scene x`                                               | Rejoint la scène de numéro `x` si elle existe. |

> On peut ajouter à toutes ces commandes un nombre (précédé d’un moins si avant) pour se placer à x secondes du point visé. Par exemple, la commande `goto milieu -10` placera la tête de lecture à 10 secondes avant le milieu du film. 
>
> Attention, ne pas mettre d’espace après le « moins ».


---

<a id="annexe"></a>

# Annexe

<a id="shortcuts"></a>

## Raccourcis clavier

> À tout moment, pour sortir d’un champ de texte ou d’un menu select — et donc retrouver l’usage des raccourcis clavier généraux — il suffit de jouer la touche ![][Escape].



<a id="shortcuts-mode-commande"></a>

### Commande du contrôleur

> Ces raccourcis sont utilisables dès le lancement de l’application. Ils ne se désactivent que lorsqu’on se trouve dans un champ d’édition.

| Action attendue | Raccourci&nbsp;&nbsp;&nbsp;&nbsp;| Description du raccourci / options       |
| ----------------------- | ------------------------ | ------------------------------------------------------------ |
| **Contrôle de la vidéo** | |  |
| Afficher/masquer les repères du PFA. | ![][K_R] |  |
| Jouer la vidéo active   | ![][K_L]          | En appuyant plusieurs fois sur la touche, on accélère la vidéo. La touche ![][Ctrl] permet de ralentir jusqu’à 50 % de la vitesse. |
| Stopper la vidéo active | ![][K_K]          | Une seconde pression permet de revenir au début du film. Une troisième pression permet de revenir au tout début de la vidéo. Ensuite, les pressions alternent entre le 0 et le début réel du film. |
| Jouer en arrière        | ![][K_J]          | Appuyer plusieurs fois pour changer la vitesse (accélérer)   |
| Avancer d’une image     | ![][ArrowRight]          |                                                              |
| Reculer d’une image     | ![][ArrowLeft]           |                                                              |
| Avancer d’1 seconde     | ![][Cmd]![][ArrowRight]  |                                                              |
| Reculer d’1 seconde     | ![][Cmd]![][ArrowLeft]   |                                                              |
| Avancer de 10 secs      | ![][Maj] ![][ArrowRight] |                                                              |
| Reculer de 10 secs      | ![][Maj]![][ArrowLeft]   |                                                              |
|  |  | |
| Aller au signet précédent | ![][Cmd]![][ArrowUp] | |
| **Édition d’un évènement** |  | |
| Focusser dans le champ de texte | ![][K_T] | Soit dans le texte de l’évènement édité séparément, soit celui du listing. Cette action désactive le mode clavier commande. |
| Enregistre l’event ou le crée | ![][K_S] | Soit l’évènement édité séparément (si focus), soit l’évènement du listing. |
| Actualiser le temps | ![][K_U] | Met le temps de la vidéo active dans l’event actuellement édité (soit séparément soit celui du listing). |
| Sélectionner l’évènement suivant | ![][ArrowDown] | Ou le premier si aucun n’est sélectionné. |
| Sélectionner l’évènement précédent | ![][ArrowUp] | Ou le dernier si aucun n’est sélectionné. |
| **Divers** |  |  |
| Copier le temps de la vidéo active dans le temps de l’autre vidéo | ![][K_C] | Il faut qu’une [seconde vidéo soit active](#use-two-videos) |
| Se placer dans la console | ![][K_X] |  |
| Ouvrir ce fichier d'aide | ![][Cmd]![][K_A] | Il s’ouvre en PDF dans une autre fenêtre  |
| Ouvrir ce fichier d’aide pour le modifier                    | ![][Alt]![][Cmd]![][K_A]                            | Il s’ouvre dans Typora, pour le moment. |
| Activer/désactiver l’aide transparent                        | ![][Maj]![][Cmd]![][K_A]                            | Ce sont les messages qui s’affichent régulièrement dans l’interface. |
<a id="shortcut-signets"></a>

### Commandes signets

| Action attendue&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Raccourci&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options |
| ------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------ |
| Aller au signet suivant | ![][Cmd]![][ArrowDown] |                                                              |
| Aller au signet précédent | ![][Cmd]![][ArrowUp] | |
| Aller au signet 1… 9 | ![][K_1]…![][K_9] | |




[K_1]: ./img/clavier/K_1.png
[K_9]: ./img/clavier/K_9.png
[K_A]: ./img/clavier/K_A.png
[K_C]: ./img/clavier/K_C.png
[K_J]: ./img/clavier/K_J.png
[K_K]: ./img/clavier/K_K.png
[K_L]: ./img/clavier/K_L.png
[K_R]: ./img/clavier/K_R.png
[K_S]: ./img/clavier/K_S.png
[K_T]: ./img/clavier/K_T.png
[K_U]: ./img/clavier/K_U.png
[K_X]: ./img/clavier/K_X.png
[Ctrl]: ./img/clavier/K_Control.png
[Cmd]: ./img/clavier/K_Command.png
[Alt]: ./img/clavier/K_Alt.png
[Maj]: ./img/clavier/K_Maj.png
[Tab]: ./img/clavier/K_Tab.png
[Escape]: ./img/clavier/K_Escape.png
[Enter]: ./img/clavier/K_Enter.png
[Return]: ./img/clavier/K_Entree.png
[ArrowRight]: ./img/clavier/K_FlecheD.png
[ArrowLeft]: ./img/clavier/K_FlecheG.png
[ArrowDown]: ./img/clavier/K_FlecheB.png
[ArrowUp]: ./img/clavier/K_FlecheH.png

[Mode commande]: #mode-commande
[contrôleur]: #controller

