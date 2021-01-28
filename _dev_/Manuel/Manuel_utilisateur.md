# ANALYSES FILMS – Manuel utilisateur

[TOC]

## Introduction

L’application « Analyseur de Films » permet de procéder à l’analyse « simple » des films, aidés de la vidéo.

De façon résumée, l’analyse consiste à enregistrer des « évènements » qui sont autant de points-clé dans le film permettant d’écrire toutes les notes qu’on veut.

L’application permet :

* de définir les scènes ainsi que les points-clé du film afin de produire le paradigme de Field augmenté du film
* de définir les personnages, les décors afin de produire des fichiers de statistiques qui éclairent objectivement sur les éléments filmiques,
* de construire des livres ebook à diffuser, qui rassemblent tous les documents produits, manuels et automatisés,
* de produire des repères de temps qui permettent de faire des références à des portions de film.

---

## Première analyse (ou reprise après absence)

Voici la procédure pour une première analyse ou pour reprendre en main l’application après un long moment sans l’utiliser.

* Lancer l’application à l’aide de l’adresse : [`http://localhost/Analyses_Films_WAS`](http://localhost/Analyses_Films_WAS)

* Dans le dossier `_FILMS_` de l’application, mettre le dossier du film analysé (ou laisser tel quel pour lancer le dernier film analysé ou le film par défaut,
  
  > Pour voir le film par défaut, qui est aussi une aide vidéo, joue en console la commande `set current xDefault`.

* Ouvrir le panneau des options avec la touche ![][K_O] pou les définir (on peut utiliser aussi la commande `options` dans [la console][]).

* J’ouvre le panneau des personnages avec la touche ![][K_P] (si je suis dans un champ d’édition ou un menu, il faut au préalable que j’en sorte avec la touche ![][Escape]).

* On peut commencer par définir le début et la fin « utiles » du film, c’est-à-dire le vrai temps zéro de l’analyse. Pour se faire, on se place aux endroits voulus, par exemple en cliquant sur la vidéo et  en ajustant avec les flèches, puis en créant les évènements « **noeud-clé > Point Zéro** » et le « **Noeud-clé > Point Final** ».

* Ensuite, jouer les touches ![][K_L] (jouer), ![][K_K] (arrête), ![][K_J](retour en arrière) — appuyer plusieurs fois pour accélérer, arrêter pour revenir à la vitesse normale,

* Une fois à l’endroit voulu, on **crée un nouvel évènement d’analyse** : 
  
  * se placer dans le champ « contenu » de la liste des évènements d’analyse en pressant ![][K_T]
  * écrire le contenu textuel de l'évènement, 
  * choisir un type, par exemple « Scène »,
  * et cliquer sur le bouton « + » du listing,
  * Le nouvel évènement d’analyse est automatiquement créé et enregistré. Le nouvel évènement est ajouté à la liste. Il suffira de cliquer dessus pour revenir à cet endroit précis. Comme c’est une scène, l’évènement est aussi ajouté à la liste des scènes.

* On peut **créer une scène**  à l’endroit voulu en pressant ![][K_N],

* Dans les textes, on peut **ajouter des balises de temps**, des références à d’autres parties, des références à des films ou à des mots, avec [les raccourcis-clavier](#shortcuts) ou par [snippets](#snippets).

* Poursuivre ainsi jusqu’à obtenir tous les évènements d’analyse voulu, dans tous les types voulus.

* Si les points de début et de fin sont définis, on peut demander la visualisation des quarts et des tiers en cliquant sur ![][K_R].

* On peut utiliser la seconde vidéo pour visualiser des endroits sans bouger la vidéo principale. On peut s’en servir par exemple pour visualiser la scène courante. Si on ne se sert pas de cette seconde vidéo, on peut supprimer toutes les informations concernant `:video2` dans le fichier de configuration et recharger la page.

* Pour produire le PFA (c’est une image `pfa.jpg` qui sera construite dans le dossier du film), il faut définir les évènements minimaux. Pour savoir ceux qui manquent, il suffit de jouer la commande `pfa build` dans la console (taper ![][K_X] pour se placer dans la console) — tant que des points manquent ils sont indiqués.

---

## Film analysé

Le film analysé doit être un dossier unique portant le nom du film (ou un diminutif) se trouvant dans le dossier `_FILMS_` de l’application. Ce dossier doit au minimum contenir :

* la vidéo du film
* un fichier `config.yml` défini ci-dessous.

```
Analyses_Films_WAS/_FILMS_/<monFilm>/config.yml
                                                            /video.mp4
```

#### Créer un film de façon assistée

Pour créer un film de façon assistée, il suffit de jouer la commande `create film` ou `create analyse` :

* sortir de tout champ d’édition avec ![][Escape],
* se placer dans la console avec ![][K_X],
* taper `create film`,
* presser ![][Return] pour lancer la procédure,
* répondre aux questions,
* attendre que le film se créé (en profiter pour lire la suite, à propos de la configuration du film.

### Définir l’analyse courante

On peut bien sûr définir l'analyse courante de façon « manuelle », en éditant le fichier `./_FILMS_/CURRENT`, mais il peut être plus pratique de le faire à l'aide de la commande :

```
set current <nom_du_dossier>
```

Par exemple :

```
set current Arrival
```

<a id="todo-list"></a>

### Todo list

On peut maintenir une todo-list (liste de tâches) à l'aide de la commande `todo`. Seule, elle affiche la liste des tâches — si elle est définie. Avec un argument, cet argument est considéré comme la tâche à ajouter.

```
todo
    => Affiche la liste des tâches, pour les lires et les marquer

todo Une nouvelle tâche à faire

    => Ajouter cette tâche
```

On peut ajouter des tags pour classer les tâches et leur donner une priorité. 

La **priorité** se définit par `P:X`, avec `X` qui est un nombre de 0 à 9.

Les **tags** se définissent par `T:NomTag` (pas d'espace pour le nom du tag). Les tags seront rassemblés entre eux.

La priorité et les tags peuvent se mettre où l'on veut dans le texte. Par exemple :

```
todo Une tâche P:5 avec un tag T:interface et une autre tag T:bug
```

Note : plus tard, les tags pourront se définir mieux, au niveau des couleurs notamment, dans le fichier de configuration.

<a id="fichier-config"></a>

## Fichier configuration (`config.yml`) du film

C’est le fichier qui définit le film courant. On trouve les propriétés suivantes :

```yaml
---
    titre: Le titre du film
    documents:
        - document1.html
        - document2.md
        - etc.
    video:
        width:    400                 // taille de la vidéo à afficher
        name:  video.mp4        // nom de la vidéo dans ce dossier
        original_path: path/to/video.mp4 // chemin d’accès

    # Pour avoir une seconde vidéo de contrôle ou d’essai
    # Pour le moment, ce sera toujours la même
    video2:
        width: 200

    # Définition des personnages
    personnages:
        PR: <personnage>        # 2 lettres qui seules vont remplacer le personnage
                                                # dans les textes.
        SA:                                 # Définition complète d'un autre personnage
            full_name: Son nom complet
            short_name: Son diminutif
            nick_name: Pseudo

    # définition des décors
    decors:
        id_decor1:        # Un décor avec sous-décors
            hname: LE DÉCOR
            items:
                subdecor1: Chambre
                subdecor2: Salon
        id_decor2: hname        # Décor seul
        id_decor3: hname        # Décor seul 

    # Options
    # -------
    # Elles se règlent automatiquement en fonction des choix dans
    # l'interface.
```

### Rechargement du fichier de configuration

Pour actualiser le fichie configuration — par exemple après avoir ajouté un snippet, un personnage, un décor, il suffit de faire :

* ![][Escape] éventuellement pour sortir du champ d'édition,
* ![][K_X] pour se placer dans la console,
* taper `update` ou `reload`![][Return].

#### Définition des décors

Cf. [Définition des décors](#decors)

#### Définition des personnages

Cf. [Définition des personnages](#personnages)

#### Définition des snippets

Cf. [Définition des snippets](#snippets)

---

<a id="personnages"></a>

## Personnages du film

Les personnages du film, pour permettre les calculs de statistique, doivent être définis dans [le fichier `config.yml`][]. Pour chacun d’eux, on définir les propriétés `:full_name` (nom complet, patronyme), `:short_name` (le nom court, diminutif) et `:nick_name` (le pseudonyme, le plus employé.). Une définition de personnage ressemblera donc à :

```yaml
# Dans le fichier config.yml

# ...
personnages:
    MG: MacGregor        # personnage "simple" défini seulement
                                    # par un nom
    PR:
        full_name: Philippe Perret
        short_name: Philippe
        nick_name: Phil
    MR:
        full_name: Marion Michel
        short_name: Marion
        nick_name: Bébé
    TR:
        full_name: Élie Kakou
        short_name: Élie
        nick_name: Lili
    # etc.
```

Dans le texte, il suffira d’utiliser la clé d’un personnage pour l’introduire. Par exemple :

```
Quand PR et MR se sont rencontrés.
```

> Note : le remplacement se fait de telle sorte que le « PR » du mot « PREMIER » qui existerait dans le texte ne serait pas remplacé.

Les versions variées du personnage (patronyme, pseudo, etc.) permet d’afficher des noms différents dans les textes.

### Statistiques des personnages

C’est **la présence de la clé d’un personnage** (par exemple « PR » ou « MR » dans l’exemple précédent) qui permet de savoir si un personnage est présent dans une scène. Et donc, de calculer son temps de présence à l’écran dans le film (et autres statistiques).

C’est la raison pour laquelle, **si un personnage n’est pas présent dans une scène**, il convient de ne pas utiliser sa clé. Par exemple, si deux personnages parlent d’un troisième qui n’est pas là, il convient de ne pas le mention avec sa clé. Par exemple :

```
# MAUVAIS :
PR et MR parlent de TR qui ne vient pas.         <=== :-(

# BON :
PR et MR parlent de Lili qui ne vient pas.     <=== :-D
```

#### Ajout d’un commentaire aux statistiques de personnages

Comme pour tout [document automatique](#documents-automatiques) il est possible d’écrire un commentaire concernant les statistiques de personnages. Ce commentaire doit se trouver dans le dossier `./documents` du film et porter le nom 

---

## Analyse

<a id="composition-analyse"></a>

### Composition d’une analyse

Une analyse avec l'« Analyseur de Films », qui [produira les livres d'analyse](#produire-livre), est composée des éléments suivant :

* une [page de couverture](#cover),
* le [frontispice (premières pages)](#frontispice),
* des [pages d'informations sur la collection](#pages-informations),
* des [« documents rédigés »](#documents-rediges),
* des [« documents automatiques »](#documents-automatiques),
* une [page de composition](#page-composition),
* une [quatrième de couverture](#quatrieme-couverture).

<a id="description-pages"></a>

### Description des pages

#### La couverture

Cf.  [la page de couverture](#cover)

<a id="frontispice"></a>

#### Le Frontispice

J'appelle à tort par ce nom les 8 toutes premières pages du livre, reprenant titre, page de garde, information livre, copyright, etc.

Pour l'**insérer dans les livres**, il faut ajouter `frontispice.html` à la liste des `documents` du [fichier `config.yml`][].

Pour pouvoir fonctionner, le frontispice a besoin des informations suivante dans le [fichier `config.yml`][] :

```yaml
title:    Le titre du livre
# ...
isbn: 17-567... # Numéro ISBN du livre
# ...
book_infos:
    # ...
    author: 
        name: Auteur du livre
        address: xxxxx
        cv: ...
        books: liste des précédents livres
    # ...
    publisher:
        name: Éditeur # nom de l'éditeur
        address: # adresse de l'éditeur
    copyright: Tous droits de reproduction, d’adaptation et de traduction réservés
```

<a id="pages-informations"></a>

#### Les pages d'informations sur la collection

Ce sont les pages « de garde » en quelque sorte, qui renseignent sur la collection. Elles sont communes à tous les livres, à quelques distinctions près (par exemple, la liste des livres parus sera différente pour chaque nouveau livre).

Pour l'**insérer dans les livres**, il faut ajouter `premieres_pages.md` à la liste des `documents` du [fichier `config.yml`][].

<a id="documents-rediges"></a>

#### Les « documents rédigés »

Ce sont des documents qui sont conçus en dehors de l'application (par exemple dans Typora) mais qui sont « parsés » par l'application. Ils sont rédigés en markdown et peuvent profiter de tous les avantages de l'application à commencer par les personnages en balises ou les temps.

Ces documents doivent se trouver dans le dossier `./documents/` du livre auquel ils appartiennent.

**Pour les insérer dans les livres**, il faut impérativement ajouter leur nom avec extension à la liste des `documents` du [fichier `config.yml`][].

Pour leur rédaction, cf. la partie [Rédiger les documents](#redaction-documents).

<a id="documents-automatiques"></a>

#### Les documents « automatiques »

Ce sont des documents qui, conformément à leur type, sont fabriqués de façon automatique, c'est-à-dire *programmatique* par l'application, en se servant des informations des évènements.

Il s'agit :

* de la couverture — `cover.html`,
* du [PFA du film](#pfa) (Paradigme de Field Augmenté) — `pfa.jpg`, 
* du séquencier — `sequencier.html`,
* du synopsis — `synopsis.html`,
* du traitement — `traitement.html`,
* des documents de statistiques — `statistiques.html`,
* de la quatrième de couverture — `quatrieme.html`.

**Pour les insérer dans les livres**, il faut impérativement ajouter leur nom final — donc avec l'extension `.html` — à la liste des `documents` du [fichier `config.yml`][].

Pour chacun de ces documents automatiques — hormis les documents de couverture —, il est possible et même préconisé de **produire un commentaire** qui sera ajouté à la suite de la présentation des statistiques. 

Ce commentaire est un fichier markdown — sans titre — à placer dans le dossier `./documents/` qui portera le nom :

```
# Documents à placer dans le dossier ./documents/ du film

POUR LES STATISTIQUES (statistiques.html)

    commentaires_stats_personnages.md                Pour les stats sur personnages
    commentaires_stats_decors.md                        Pour les stats sur décors
    commentaires_stats_scenes.md                        Pour les stats sur les scènes

POUR LES AUTRES DOCUMENTS

    commentaires_<type document>.md

    commentaires_synopsis.md            Pour le synopsis
    commentaires_traitement.md        Pour le traitement
    commentaires_pfa.md                        Pour le paradigme de Field augmenté
    commentaires_sequencier.md        Pour le séquencier
```

Chacun de ces documents peut être construit à n'importe quel moment (pour vérifier son contenu par exemple) à l'aide de la commande `build` (mais ils seront construits et actualisés chaque fois à la [production des livres](#produire-livre)) :

```
build cover
build sequencier
build synopsis
build traitement
build statistiques
build pfa
build quatrieme

build documents
        Construit tous les documents ci-dessus, mais seulement s'ils
        sont définis dans la liste 'documents' de config.yml
```

<a id="page-composition"></a>

#### Page de composition

La « page de composition », à la fin du livre, présente les informations de composition du livre avec, notamment, le détenteur des droits, le graphiste de la couverture, la date de dépôt légal, l'adresse de l'auteur et de l'éditeur, etc.

Pour introduire cette page dans le livre, il faut ajouter le document `composition.html` à la liste des documents, en général avant `quatrieme.html` (quatrième de converture).

La page de composition a besoin de ces informations, dans le [fichier `config.yml`][] pour être construite :

```yaml
title: Le titre du livre
isbn:        Numéro ISBN
book_infos:
    depot_legal: janvier 2021 # date du dépot légal
    printer:    
        name: Calibre # imprimeur
        address: https://calibre-ebook.com/fr
    print_date:    janvier 2021 # date de la fin d'impression
    publisher:
        name: Nom de l’éditeur
        address: # adresse de l'éditeur
```

<a id="quatrieme-couverture"></a>

#### Quatrième de couverture

La quatrième de couverture présente une autre photo du film, un résumé du film et de l'analyse, ainsi qu'une présentation de l'auteur.

**Pour l’insérer dans le livre**, il faut ajouter le nom `quatrieme.html` dans la liste des documents du film.

Le [fichier `config.yml`][] doit également définir les données suivantes :

```yaml
# ...
isbn: # Numéro ISBN du livre
book_infos:
    author:
        cv: Une court bio de l’auteur de l’analyse.
    # ...
    cover4:
        img_path: chemin/vers/img-quatrieme.jpg
        img_width: Largeur (avec unité)
        img_height: Hauteur (avec unité)
        img_left: Décalage gauche (dans son conteneur)
        img_top:    Décalage haut (dans son conteneur)
```

<a id="documents-automatiques"></a>

### Les documents « automatiques »

Les « documents automatiques » sont des documents qui se construisent de façon automatisée grâce aux informations relevées. Il s’agit aussi bien des séquenciers que des synopsis, des statistiques des personnages ou du PFA.

#### Insérer les documents automatiques dans le livre

Pour insérer un document automatique dans le livre, il suffit de mettre son nom (le nom du document `html`) dans la liste des documents dans le [fichier `config.yml`][] du film. Voici ce que donnerait une liste de documents avec tous les documents automatiques ajoutés :

```yaml
# ...
documents:
    - statistiques.html
  - traitement.html
    - synopsis.html
    - pfa.html
    - sequencier.html
# ...
```

#### Commenter les documents automatiques

On peut rédiger un document de commentaire pour chacun de ces documents en appelant ce fichier par l’affixe du fichier précédé de `commentaires_`. On peut ainsi trouver dans le dossier `./documents/` :

```
# Dans ./documents/
commentaires_synopsis.md            Commentaires sur le synopsis
commentaires_sequencier.md        Commentaires sur le séquencier
commentaires_traitement.md        Commentaires sur le traitement
commentaires_pfa.md                        Commentaires sur le PFA du film
commentaires_stats_personnages.md    
                                                            Commentaires sur les statistiques
                                                            des personnages.
commentaires_stats_decors.md    Idem sur les décors
commentaires_stats_scenes.md    Idem sur les scènes
```

#### PFA du film

Le document automatique pour le PFA du film (Paradigme de Field Augmenté) est un document un peu spécial qui s’appuie sur la fabrication d’une image (avec `convert`) et tous les nœuds clés définis.

La commande `build pfa` permet de construire cette image (qui sera tournée sur le côté pour s’insérer de travers dans le livre, en tout cas dans sa version imprimée).

La commande `build pfa -html` produira le document final.

Comme tous les [documents automatiques](#documents-automatiques), le PFA sera actualisé à la construction d’un livre, SAUF l’image qui devra être actualisée à l’aide de la commande `build pfa` si des nœuds ont été modifié.

---

<a id="events"></a>

## Les évènements d'analyse

Les « évènements d'analyse » sont tous les points qu’on peut relever dans le film au cours de la phase appelée « collecte », qui consiste à noter tout ce qui peut être consigné pour le film, à commencer par :

* les scènes,
* les nœuds-clés (qui permettent d’établie le [PFA du film](#pfa)).

### Créer un évènement d'analyse

* sortir de l’éventuel champ d’édition où l’on se trouve (![][Escape]),
* positionner la vidéo à l’endroit concerné par l’évènement en [navigant dans le film](#naviguer),
* choisir une des trois opérations suivante :
  * initialiser le formulaire avec ![][K_I] (ce qui place automatiquement le pointeur dans le champ d’édition de l'évènement),
  * OU se placer dans le champ de texte avec ![][K_T],
  * OU créer une scène avec ![][K_N],
* rédiger le contenu de l’évènement,
* Choisir son type dans le menu (scène, nœud clé, etc.),
* cliquer sur le bouton « + » du listing d’éléments (ou sortir du champ ![][Escape] et taper ![][K_S].

### Modifier un évènement d'analyse

* Le choisir dans la liste,
* modifier ses valeurs,
* cliquer sur le bouton « save ».

<a id="grand-editor"></a><a id="grand-editeur"></a>

#### Grand éditeur (éditeur séparé)

Quand on doit éditer un évènement de façon « sérieuse », par exemple pour y ajouter des références à d’autres évènements, on utilise un « éditeur séparé » ou « grand éditeur ». Quand un évènement est édité dans cet éditeur séparé, on peut faire défiler la liste des évènements de façon normale, en restant dans cet éditeur. Cela permet d’ajouter facilement des références à d’autres évènements dans un évènement particulier.

Pour éditer un évènement d’analyse de cette manière, il suffit de le sélectionner dans la liste et de cliquer la touche ![][Return].

<a id="redaction-documents"></a>

### Rédiger les documents

L’application « Analyseur de fims » ne peut produire que des documents automatisable, comme les séquenciers, les statistiques, etc. Tous les autres documents « rédactionnels » doivent être, pour le moment en tout cas, produit avec d’autres applications, en markdown de préférence, avec Typora pour le moment.

Tous ces documents doivent se trouver dans le dossier `./documents/` du film.

**Pour qu’un document soit ajouté au livre final**, il doit impérativement être ajouté dans la définition de `documents` dans le fichier de configuration.

Si on veut que le livre introduisent les documents :

```
<dossier film>/documents/mon_document.md
                                                 introduction.md
```

On doit ajouter dans le fichier `config.yml` du film :

```yaml
# ...
documents: ['introduction.md', 'mon_document.md']
# ...

# ou
documents:
    - introduction.md
    - mon_document.md
```

On peut **créer un document** depuis [la console](#console) avec la commande `create document <nom_document.md>`.

On peut **ouvrir un document** depuis [la console](#console) avec la commande `open document <nom_document>`.

> Noter que pour l’ouverture, l’extension n’est pas requise s’il existe un seul document de ce type.

Procédure détaillée :

* sortir de tout champ d’édition en pressant la touche ![][Escape],
* se placer dans la console avec ![][K_X],
* taper `open document mon_document`,
* presser la touche ![][Return].

#### Insérer la référence à un évènement d'analyse

* Cliquer sur l’évènement dans le listing (sa référence est copiée dans le presse-papier),
* se placer à l’endroit où doit être placée la référence,
* coller la référence,
* définir optionnellement le texte alternatif de la référence. Sinon, c’est le résumé (première ligne) de l’évènement d’analyse qui sera utilisé.

#### Insérer une balise de temps (avec durée)

Une « balise de temps » est une marque dans le texte qui permet de faire référence à un temps précis. Elle permet de donner au temps un aspect particulier et, dans un développement ultérieur, de rejoindre la partie concernée dans une *timeline* par exemple. Elle ressemble à :

```
On peut voir au temps [time:0:12:13] une balise temporelle.
```

Cette balise sera transformé en :

```html
<p>On peut voir au temps <span class="horloge">0:10:11</span> une balise temporelle.</p>
```

> Lire la note concernant la [différence ici entre les temps](#note-temps) ci-dessus.

Comme toutes les balises, on peut utiliser un texte propre pour cette balise en ajoutant un second argument :

```
On peut trouver [time:0:12:13|un temps] ici.
```

… qui deviendra :

```html
<p>On peut trouver <span class="horloge" data-time="0:10:11">un temps</span></p>
```

Enfin, il est possible d’indiquer un temps de fin en augmentant la première donnée :

```
Il y aura de [time:0:12:13-0:14:13] une durée marquée.
```

… qui sera transformé en :

```html
<p>
  Il y aura de <span class="horloge" data-time="0:12:13-0:14:13">0:10:11 à 0:13:11 (2")</span> une durée marquée.
</p>
```

##### Méthode par snippet

Si on se trouve dans un champ de texte, on peut utiliser le snippet `t`

##### Méthode quand on se trouve dans le champ de texte

Il suffit de jouer ![][Control]![][K_T] pour placer une balise temps avec le temps courant de la vidéo active.

##### Méthode par raccourci-clavier

* Se placer à l’endroit voulu dans la vidéo,
* presser la touche ![][K_H] (=> une balise temps est placée dans le presse-papier),
* coller la balise temps créée à l’endroit voulu.

> Lire la [note à propos des temps](#note-temps)

#### Insérer un texte (propre, type ou template)

Pour insérer un texte quelconque dans un document markdown, on utilise la balise :

```markdown
[include:name.extension]                     <!-- Si à la racine -->
[include:dossier/path.extension]     <!-- si dans sous-dossier -->
```

Ce texte doit se trouver dans un de ces trois lieux par ordre de précédence :

```
1. Le dossier ./_TEMPLATES_/ commun à tout les films
2. Le dossier ./documents du film (fichier .md, en général)
3. Le dossier ./products du film (fichier html, en général)
```

Pour le faire de façon programmatique (en ruby), il suffit d’utiliser la méthode `template('relative/path')` pour obtenir **le chemin d'accès** au fichier voulu. Pour l’introduire tel quel dans un autre document ou pour l’envoyer à la méthode `kramdown` qui retournera un texte complètement formaté.

<a id="snippets"></a>

### Snippets

Pour faciliter la rédaction des documents (et notamment ne pas sortir du texte), on peut utiliser des snippets.

> Rappel : un « snippet » est un texte qu'on va obtenir en jouant une ou plusieurs lettes suivies de la touche ![][Tab]. Par exemple, dans l'application, si on écrit « t » et qu'on presse tout de suite la touche tabulation, ce « t » sera remplacé par une balise de temps correspondant au temps de la vidéo courante.

#### Liste des snippets système

| Action                          | Snippet | Description                                                                                                              |
| ------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------ |
| Insérer une balise de temps     | `t`     | Insère dans le texte une balise de la forme `[time:h:mm:ss]` qui sera remplacé par une horloge liée dans le texte final. |
| Insérer le nom de l'application | `app`   |                                                                                                                          |
|                                 |         |                                                                                                                          |

#### Définir ses propres snippets

On peut définir ses propres snippets dans [le fichier `config.yml`][] avec la propriété `snippets`. Un snippet doit définir en clé les lettres du snippet et en valeur la propriété `value`, avec la valeur à écrire, ou la propriété `method` avec le code javascript de la méthode à utiliser pour définir la valeur (valeur que la méthode doit retourner). Par exemple :

```yaml
# Dans le fichier config.yml

# ...
snippets:
    ph: Philippe Perret
    # ou :
    ph:
        value: Philippe Perret
    # Avec une méthode (sans 'return')
    date:
        method: new Date().getMonth() + 1
    # Avec une méthode qui définit explicitement le 'return'
    autredate:
        method: var d = new Date(); return d.getFullYear()
```

Noter que si la méthode ne contient pas de `return`, il sera ajouté au début du code.

---

### Mise en forme des documents rédigés

#### Référence à un autre évènement d’analyse (note, scène, etc.)

On peut utiliser de nombreux marques de formatage pour rédiger les documents « manuels ». En voici la liste complète :

```
[film:titre du film]
        Pour mettre en forme un titre de film

[ref:scene:id_event|Texte alternatif]
        Pour mettre en forme une référence à une scène dans le texte.
        Noter qu'il s'agit ici de l'ID de l'event qui définit cette scène
        et PAS du numéro de la scène (qui pourrait changer à tout moment).
        Si le texte alternatif n'est pas défini, c'est un texte type :
        "scène X. à m:ss : résumé"

[ref:note:id_event|Texte alternatif]
        Une référence à une note.
        Si aucun texte alternatif n'est défini, on écrira "(cf. note x)" avec
        un lien vers la note.

[ref:event:id_event|Texte alternatif]
        Une référence à n'importe quel évènement.
```

#### Référence à un autre document (une autre section)

Pour faire référence à un autre document se trouvant dans le dossier `documents` ou `products` (mais qui sera dans tous les cas, bien entendu, ajouté au code final), on utilise la balise :

```
[ref:document:<nom avec extension>|<texte alternatif>]

ou

[ref:doc:<nom.ext>|<texte alternatif>]
```

Sans texte alternatif, la marque liée au document (à sa section) sera : **Document « Nom sans extension title-isé »**.

---

<a id="books"></a>

## Les livres

<a id="produire-livre"></a>

### Produire les livres

Pour produire les livres (ebook mobi, epub, pdf), il suffit de jouer la commande `build books`.

| Actions                                                  | Raccourci   | Description/options                                                                            |
| -------------------------------------------------------- | ----------- | ---------------------------------------------------------------------------------------------- |
| Sortir du champ d’édition dans lequel on peut se trouver | ![][Escape] |                                                                                                |
| Se placer dans la console                                | ![][K_X]    | Ou cliquer simplement dedans avec la souris                                                    |
| Taper la commande `build books`                          |             | Pour produire tous les livres, c’est-à-dire les formats `html`, `pdf`, `mobi` ou `epub`.       |
| OU Taper la commande `build book <type>`                 |             | Pour produire un seul livre au format voulu (cf. ci-dessus)                                    |
| Jouer la commande                                        | ![][Return] | Puis attendre jusqu’à la fabrication complète des livres, ce qui peut prendre un peu de temps. |

<a id="cover"></a>

### La couverture

Chaque livre comporte sa propre couverture mais une charte commune est utilisée pour homogénéiser l'ensemble.

#### Image de couverture

Avant de pouvoir produire la couverture (avec **Inkscape**), il faut définir son image — une image tirée du film en plein écran — qu’on placera dans le fichier `./img/cover-film-img.jpg`.

Information sur cette image :

```
DIMENSIONS
    HAUTEUR
    LARGEUR
RÉSOLUTION            300ppi
```

#### Produire la couverture

Pour produire la couverture :

* dupliquer le fichier `./_TEMPLATES_/cover_template.svg`,
* le copier dans le dossier `./img/` du film analysé,
* ouvrir ce fichier dans **Inkscape**,
* importer l’image `./img/cover-film-img.jpg`,
* remplacer l’image du film par cette image,
* changer le titre,
* exporter l’image (en `PNG`),
* ouvrir l’image dans Aperçu pour la transformer en `JPEG`.

<a id="dedicace"></a>

### Dédicace

Pour ajouter une dédicace aux premières pages du livre il suffit de la rédiger dans le document `./documents/dedicace.md` en markdown.

Noter qu'elle sera automatiquement insérée dans les livres puisque les premières pages sont toujours créées. On peut la voir en demandant la construction du [frontispice](#frontispice) (commande `build frontispice`).

---

<a id="note-temps"></a>

### Note sur la divergences entre les temps

Concernant les temps, vous noterez certainement que les temps qui se retrouvent dans les livres ou les documents finaux ne sont pas ceux avec lesquels on travaille dans l’application. 

Cela s'explique par le fait que les temps dans l’application sont toujours ceux par rapport au **zéro de la vidéo** (`video.currentTime = 0`) tandis que les temps utilisés dans les productions de l’application sont ceux par rapport au **zéro du film** qui, normalement, ne correspondent que très rarement.

Il est donc normal de trouver cette différence.

> Rappel : le zéro du film se définit en créant un évènement de type « nœud-clé > Point Zéro »

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

### Édition du texte d’un évènement d'analyse

Après avoir cliqué sur un évènement dans le listing, il se met automatiquement en édition. Il suffit alors de taper la lettre ![][K_T] pour se placer dans le champ d'édition du texte pour le modifier.

### Contrôle de la vidéo en éditant un texte

Lorsque l'on se trouve dans le champ d'édition du texte d'un évènement d'analyse, il faut ajouter la touche ![][Ctrl] aux touches ![][K_J], ![][K_K] et ![][K_L] pour respectivement revenir en arrière, arrêter ou mettre en route la lecture de la vidéo courante.

### Titre de l’évènement/première ligne

Dans le listing, seule la première ligne de la description des évènements est affichée. C’est en fait que cette première ligne sert toujours de titre à l’évènement et sera toujours traitée de cette manière dans les livres produits.

### Obtenir la référence à un évènement

Il suffit de cliquer sur un évènement dans le listing pour que sa référence soient copiée dans le presse-papier. Il suffit donc ensuite de la coller (![][Cmd]![][K_V]) pour la coller à l’endroit voulue.

### Les scènes

Les scènes sont un type très particulier d’évènement dans le sens où on peut définir, en plus des autres données, les propriétés :

* Le **Lieu**. Où se déroule la scène, en intérieur ou en extérieur.
* L'**Effet**. Le moment où elle se déroule, jour, nuit, etc.
* Le **Décor**. Le décor et sous-décor exact.

Par convention, la toute première ligne (i.e. premier paragraphe) est considéré comme le résumé de la scène. C’est lui qui est utilisé dans le listing et dans le séquencier produit (ainsi que dans toute référence qui est faite à la scène).

#### Édition des scènes

Noter que pour le moment, pour pouvoir éditer complètement une scène (i.e. définir son lieu, effet, décors, etc.) il faut l’éditer dans [l’éditeur séparé](#grand-editor). On peut l’éditer comme un autre évènement d’analyse seulement s’il faut juste changer son temps ou son texte.

<a id="decors"></a>

#### Définition des décors

On définit les décors dans [le fichier `config.yml`][] du film :

```yaml
...
decors:
    id_decor_simple: Rue animée # décor simple, sans items
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
```

Pour ajouter un nouveau décor, il suffit de faire :

* ![][K_X] pour se placer dans la console,
* taper `open config `![][Return] pour ouvrir le fichier configuration
* ajouter les décors voulus
* taper `update` ou `reload`![][Return] dans la console pour actualiser l'affichage 

#### Influence sur l'analyse

Ces nouvelles propriétés permettent de définir des statistiques pour les livres d’analyse, dont :

* l’utilisation des décors,
* le temps passé en intérieur et en extérieur,
* le temps passé de jour et de nuit,
* la durée de présence des personnages (repérés dans les scènes).

### Filtrage des évènements

On peut utiliser le filtrage normal de la classe `Listing` en procédant de cette façon :

* sortir des champs d’édition avec ![][Escape]
* initialiser le formulaire en cliquant le bouton « Init » ou en pressant ![][K_I],
* régler le formulaire suivant la recherche,
* cliquer le bouton « Filtre ».

Mais dans le cadre de l’analyse, et notamment pour filtrer par type, il peut être plus judicieux d’utiliser la [console](#console) et la commande `filtre`.

* sortir des champs d’édition avec ![][Escape],
* se placer dans la console avec ![][K_X],
* définir le filtre `filtre … … …`,
* jouer ![][Return].

Pour ré-afficher tous les évènements, on peut sortir de la console et taper ![][K_A], ou cliquer sur le bouton « All », ou exécuter la commande `filtre` seule.

#### Détail de la commande `filtre`

**Évènements contenant un ou des textes**

```
filtre ce_texte
=> Events contenant le texte "ce texte" ou "ce_texte"

filtre texte pour voir
=> Events contenant obligatoirement les trois mots "texte", "pour" et "voir"
```

**Évènement d’un certain type**

```
filtre type:scene
=> Toutes les scènes

filtre type:note
=> Toutes les notes

filtre type:noeud
=> Tous les noeuds clé

filtre type:nc:zr
=> Le noeud clé Zéro
```

**Évènement après ou avant un certain temps**

```
filtre before:0:1:15
=> Tous les évènements avant 1 minute 15 secondes

filtre type:note before:30:00
=> Toutes les notes avant la trentième minute

filtre after:10:00 type:scene
=> Toutes les scènes après la 10e minute
```

**Évènements contenant un ou des personnages**

```
filtre personnage:PR personnage:AN
=> Events avec les personnages PR et AN (obligatoirement les deux)

filtre type:scene perso:PR
=> Scènes avec le personnage d'identifiant PR
```

---

## Le Contrôleur

Le contrôle permet de contrôler la vidéo et de mémoriser des points-clés, des signets, qui permettent de se déplacer avec plus d’aisance.

> Note : maintenant, il n’est plus dédié qu’aux signets.

On l’affiche grâce au raccourci  ![][Cmd]![][K_K].

---

<a id="videos"></a>

## Les vidéos

### Lancer la lecture

La touche ![][K_L] permet de lancer la lecture sur [la vidéo active][]. Utiliser ![][Ctrl]![][K_L] pour l’autre vidéo.

### Régler la vitesse

Appuyer plusieurs fois sur la touche ![][K_L] (avec ![][Ctrl] pour la vidéo non active)permet de modifier la vitesse (en boucle).

> Noter que dès qu’on arrête la lecture, la vitesse revient à son état initial, sauf si on l’a figée (cf. ci-dessous)

#### Figer la vitesse

Parfois il est intéressant de rester toujours à une même vitesse. Par exemple pour faire la relève des scène 2 fois plus vite en accélérant par 2. Dans ce cas, on coche la case « Figer la vitesse » qui permettra de ne pas faire varier la vitesse, quelles que soient les touches pressées.

<a id="video-active"></a>

### La vidéo active

En [mode avec deux vidéos](#use-two-videos), la vidéo active est la vidéo entourée d’un bord bleu. Pour changer la vidéo active, il suffit de cliquer sur la vidéo à activer.

Noter que la plupart des contrôles par touche s’appliquent à la vidéo non active simplement en ajoutant la touche ![][Ctrl]. Par exemple ![][Ctrl]![][K_L] permet de jouer la vidéo non active sans l’activer.

<a id="use-two-videos"></a>

### Utiliser une seconde vidéo

On peut utiliser une seconde vidéo simplement en la définissant dans le fichier `config.yml` du film :

```yaml
---
    ...
    :video2:
        :width: 200 # en général, assez petite
        # TODO Plus tard des options, comme le placement dans l'interface
        # pourront être déterminées.
```

---

### Naviguer dans la vidéo courante

Cf. [Naviguer dans le film](#naviguer) pour voir les multitudes de moyens de se déplacer dans la vidéo.

### Dessiner des repères sur la vidéo

Pour faciliter l’analyse, on peut placer des lignes repères qui indiquent les quarts et les tiers du film. 

En [mode commande][], il suffit de jouer la touche ![][K_R] — avec ![][Ctrl] pour la vidéo non active — pour afficher ou masquer les repères du paradigme de field, c’est-à-dire les quarts et les tiers. De la même manière, la section avant et après qui n’est pas utilisée est masquée (les génériques, en gros).

On peut aussi utiliser les commandes suivantes :

```
draw quarts            Pour afficher les quarts
draw tiers            Pour afficher les tiers
draw all                Pour afficher les quarts et les tiers
```

> ![][K_X] permet de se placer directement dans la console pour taper ces commandes et ![][Escape] permet d’en sortir aussitôt pour retrouver le mode de commande normal.

<a id="console"></a>

## La console

La console permet de lancer les commandes et notamment les commandes de construction de l’analyse qui produira les fichiers et les images du film analysé.

C’est la bande noir qui se trouve sous le listing des évènements.

### Se placer dans/sortir de la console

Pour se placer rapidement dans la console, il suffit de jouer le raccourci ![][K_X] en mode de commande. On se retrouve alors en mode de texte. Pour quitter la console — et donc le mode de texte — et revenir en mode de commande, on suffit de sortir de la console avec ![][Tab] ou ![][Escape].

<a id="commandes-console"></a>

### Liste des commandes

| Action&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Commande&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options                                                                                |
| ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Ouvrir l'aide                                                                                                | `aide` ou `manuel`                                                                           | Ouvre le fichier PDF du manuel dans un autre onglet/une autre fenêtre.                             |
| Affiche les options                                                                                          | `options`                                                                                    | Affiche le panneau contenant les options et permet de les gérer.                                   |
| Ouvrir quelque chose                                                                                         | `open …`                                                                                     | Cf. [commande `open`](#commande-open)                                                              |
| Construire un élément                                                                                        | `build …`                                                                                    | Cf. [commande `build`](#commande-build)                                                            |
| Créer quelque chose                                                                                          | `create …`                                                                                   | Cf. [commande `create`](#commande-create)                                                          |
| Se déplacer dans le film                                                                                     | `goto …`                                                                                     | Cf. [commande `goto`](#commande-goto)                                                              |
| Actualiser les données du film, recharger le fichier de configuration                                        | `update` ou `reload`                                                                         | La commande est à utiliser, par exemple, lorsqu’on modifie la liste des personnages ou des décors. |
| Définir l’analyse courante                                                                                   | `set current <nom_dossier>`                                                                 | Note : recharge la page pour prendre en compte le changement.                                      |

<a id="commande-open"></a>

#### Commande `open`

| Objet ouvert                | Commande                 | Description/options                                                                     |
| --------------------------- | ------------------------ | --------------------------------------------------------------------------------------- |
| L'aide                      | `open aide`              | Ouvre le fichier PDF dans un autre onglet ou une autre fenêtre suivant les préférences. |
| Le dossier du film          | `open film`              | Ouvre le dossier du film dans le Finder                                                 |
| Le fichier de configuration | `open config`            | Ouvre le fichier `config.yml` du film courant dans Atom (pour le moment).               |
| L’image du PFA              | `open pfa`               | Il faut que l’image ait été construite avec succès par la commande `build pfa`.         |
| Un document                 | `open doc[ument] <name>` | Si le `<name>` ne définit pas son extension, c’est l’extension `.md` qui est choisie.   |
| Un livre                    | `open book pdf           | epub                                                                                    |

<a id="commande-build"></a>

#### Commande `build`

| Objet construit        | Commande                       | Description/options                                                                                                                                                                                                                                          |
| ---------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Tous les livres        | `build books`                  | Construit tous les livres et les places dans le dossier `./finaux` du dossier du film. Attention cette commande ne reconstruit pas tous les fichiers à produire (synopsis, statistiques, etc.). Utiliser l’option `-update` pour ce faire.                   |
| Un livre               | `build book <type>[ options]`  | Construire le livre de type `<type>` qui peut être `html`, `pdf`,  `mobi` ou `epub`. Noter que cette méthode n’actualise pas les fichiers construits (comme le synopsis, les statistiques, etc.). Pour ce faire, ajouter l’option `-update`.                 |
| PFA                    | `build pfa`                    | Construit une image (`pfa.jpg`) qu’il suffira de copier dans le livre. cf. [PFA](#pfa).                                                                                                                                                                      |
| Séquencier             | `build sequencier`             | Construit une page (format à voir) à introduire dans le livre.                                                                                                                                                                                               |
| Synopsis               | `build synopsis`               | Construit le synopsis en se basant sur le contenu des évènements scènes.                                                                                                                                                                                     |
| Traitement             | `build traitement`             | Construit le traitement. Un traitement est comme un séquencier, mais il présente le contenant complet de la scène ainsi que **tous les évènements qu’elle contient** (sauf ceux qui sont marqués à retirer). C’est donc la version la plus complète du film. |
| Statistiques           | `build statistiques[ <type>]` | Construit toutes les statistiques du film, à savoir : le classement des scènes par durée, la plus longue et la plus courte, la durée moyenne des scènes, le temps de présence des personnages, le temps d’utilisation des décors, etc.                       |
| Un document quelconque | `build document <name.ext>`    | Construit en version finale le document de nom (et extension) « name.ext ». Si l’extension n’est pas fourni, la commande fournit `.md` par défaut.                                                                                                           |

<a id="commande-create"></a>

#### Commande `create`

| Objet créé                 | Commande                       | Description/options                                                                                                                                         |
| -------------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Un document quelconque     | `create doc[ument] <name.ext>` | Le document sera créé dans le dossier `./documents/` du film. Il sera ajouté à la propriété `documents` du fichier de configuration mais toujours à la fin. |
| Un nouveau film à analyser | `create film`                  | Cela déclenche une procédure de demande qui va permettre de créer un nouveau film.                                                                          |

<a id="commande-goto"></a>

#### Commande `goto`

| Lieu                   | Commande&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options                            |
| ---------------------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Quart du film          | `goto quart`                                                                                       | Cf. la note ci-dessous.                        |
| Tiers du film          | `goto tiers`                                                                                       | Cf. la note ci-dessous.                        |
| Milieu                 | `goto milieu`                                                                                      | Cf. la note ci-dessous                         |
| Deux tiers du film     | `goto deux-tiers`                                                                                  | Cf. la note ci-dessous.                        |
| Trois-quart du film    | `goto trois-quarts`                                                                                |                                                |
| Une scène particulière | `goto scene x`                                                                                     | Rejoint la scène de numéro `x` si elle existe. |

> On peut ajouter à toutes ces commandes un nombre (précédé d’un moins si avant) pour se placer à x secondes du point visé. Par exemple, la commande `goto milieu -10` placera la tête de lecture à 10 secondes avant le milieu du film. 
> 
> Attention, ne pas mettre d’espace après le « moins ».

---

<a id="annexe"></a>

# Annexe

<a id="shortcuts"></a>

## Raccourcis clavier

> À tout moment, pour sortir d’un champ de texte ou d’un menu select — et donc retrouver l’usage des raccourcis clavier généraux — il suffit de jouer la touche ![][Escape].
> 
> À tout moment également, pour rentrer dans le champ d’édition le plus naturel, presser la touche ![][K_T].

> Note : ces raccourcis sont utilisables dès le lancement de l’application. Ils ne se désactivent que lorsqu’on se trouve dans un champ d’édition.

| Action attendue                                                   | Raccourci&nbsp;&nbsp;&nbsp;&nbsp; | Description du raccourci / options                                                                                                                                                                 |
| ----------------------------------------------------------------- | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Contrôle de la vidéo**                                          |                                   | <a id="shortcuts-mode-commande"></a>                                                                                                                                                               |
| Afficher/masquer les repères du PFA.                              | ![][K_R]                          |                                                                                                                                                                                                    |
| Jouer la vidéo active                                             | ![][K_L]                          | En appuyant plusieurs fois sur la touche, on accélère la vidéo. La touche ![][Ctrl] permet commander l’autre vidéo.                                                                                |
| Jouer la vidéo active (dans un champ)                             | ![][Ctrl]![][K_L]                 | Active la lecture de la vidéo lorsque l’on se trouve dans un champ d’édition.                                                                                                                      |
| Stopper la vidéo active                                           | ![][K_K]                          | Une seconde pression permet de revenir au début du film. Une troisième pression permet de revenir au tout début de la vidéo. Ensuite, les pressions alternent entre le 0 et le début réel du film. |
| Stopper la vidéo (dans champ)                                     | ![][Ctrl]![][K_K]                 | Dans un champ d’édition. Noter que si on n’est pas dans un champ d’édition, cette commande stoppera l’autre vidéo.                                                                                 |
| Jouer en arrière                                                  | ![][K_J]                          | Appuyer plusieurs fois pour changer la vitesse (accélérer)                                                                                                                                         |
| Jouer en arrière (dans un champ)                                  | ![][Ctrl]![][K_J]                 | Dans un champ d’édition. Noter que hors d’un champ d’édition ce raccourci clavier jouera en arrière l’autre vidéo.                                                                                 |
| Avancer d’une image                                               | ![][ArrowRight]                   |                                                                                                                                                                                                    |
| Reculer d’une image                                               | ![][ArrowLeft]                    |                                                                                                                                                                                                    |
| Avancer d’1 seconde                                               | ![][Cmd]![][ArrowRight]           |                                                                                                                                                                                                    |
| Reculer d’1 seconde                                               | ![][Cmd]![][ArrowLeft]            |                                                                                                                                                                                                    |
| Avancer de 10 secs                                                | ![][Maj] ![][ArrowRight]          |                                                                                                                                                                                                    |
| Reculer de 10 secs                                                | ![][Maj]![][ArrowLeft]            |                                                                                                                                                                                                    |
|                                                                   |                                   |                                                                                                                                                                                                    |
| Aller au signet précédent                                         | ![][Cmd]![][ArrowUp]              |                                                                                                                                                                                                    |
| **Édition d’un évènement**                                        |                                   |                                                                                                                                                                                                    |
| Focusser dans le champ de texte                                   | ![][K_T]                          | Soit dans le texte de l’évènement édité séparément, soit celui du listing. Cette action désactive le mode clavier commande.                                                                        |
| Balise temps (dans un champ)                                      | ![][Control]![][K_T]              | Quand on est dans un champ de saisie de texte, ce raccourci colle une balise temporelle du temps courant.                                                                                          |
| Enregistre l’event ou le crée                                     | ![][K_S]                          | Soit l’évènement édité séparément (si focus), soit l’évènement du listing.                                                                                                                         |
| Enregistre l’event ou le crée (dans un champ)                     | ![][Control]![][K_S]              | Seulement dans un champ d’édition. Permet de ne pas en sortir pour l’enregistrement.                                                                                                               |
| Actualiser le temps                                               | ![][K_U]                          | Met le temps de la vidéo active dans l’event actuellement édité (soit séparément soit celui du listing).                                                                                           |
| Sélectionner l’évènement suivant                                  | ![][ArrowDown]                    | Ou le premier si aucun n’est sélectionné.                                                                                                                                                          |
| Sélectionner l’évènement précédent                                | ![][ArrowUp]                      | Ou le dernier si aucun n’est sélectionné.                                                                                                                                                          |
| **Divers**                                                        |                                   |                                                                                                                                                                                                    |
| Afficher les options                                              | ![][K_O]                          |                                                                                                                                                                                                    |
| Afficher/masquer la liste des personnages                         | ![][K_P]                          | En choisir un permet de mettre son ID dans le presse-papier, pour l’introduire où l’on veut.                                                                                                       |
| Temps de vidéo courante dans presse-papier                        | ![][K_H]                          | Cela copie dans le presse-papier une balise de forme `[temps:h:mm:ss]` qui sera correctement formatée.                                                                                             |
| Copier le temps de la vidéo active dans le temps de l’autre vidéo | ![][K_C]                          | Il faut qu’une [seconde vidéo soit active](#use-two-videos)                                                                                                                                        |
| Se placer dans la console                                         | ![][K_X]                          | On peut alors jouer [une des nombreuses commandes](#commandes-console) qui permettent de gérer un grand nombre de choses                                                                           |
| Ouvrir ce fichier d'aide                                          | ![][Cmd]![][K_A]                  | Il s’ouvre en PDF dans une autre fenêtre                                                                                                                                                           |
| Ouvrir ce fichier d’aide pour le modifier                         | ![][Alt]![][Cmd]![][K_A]          | Il s’ouvre dans Typora, pour le moment.                                                                                                                                                            |
| Activer/désactiver l’aide transparent                             | ![][Maj]![][Cmd]![][K_A]          | Ce sont les messages qui s’affichent régulièrement dans l’interface.                                                                                                                               |
| <a id="shortcut-signets"></a>                                     |                                   |                                                                                                                                                                                                    |

### Commandes signets

| Action attendue&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Raccourci&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description/options |
| --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------- |
| Aller au signet suivant                                                                                               | ![][Cmd]![][ArrowDown]                                                                  |                     |
| Aller au signet précédent                                                                                             | ![][Cmd]![][ArrowUp]                                                                    |                     |
| Aller au signet 1… 9                                                                                                  | ![][K_1]…![][K_9]                                                                       |                     |

---

## Conversion des vidéos pour l'analyse

Si le fichier du film n’est pas en `mp4` ou `ogg`, il convient de le transposer. Cela se fait grâce à la commande Terminal : 

CETTE COMMANDE NE FONCTIONNE PAS (pour le moment, regarder les recherches entreprises dans le fichier README du dossier des vidéos sur le disque dur externe)

```
ffmpeg -i fichier/original.<ext> -vf subtitles=fichier/original.<ext> fichier/original.mp4
```

>  Si on se place dans le dossier contenant la vidéo, on a juste à mettre le nom du fichier.

---

#### Extraire le son

Noter tout d'abord qu'il n'est pas nécessaire, normalement, de faire cette opération soi-même, elle est automatique.

Pour extraire le son (*), utiliser la commande :

```
ffmpeg -i input-video.avi -vn output-audio.aac
```

(* Pour essayer de gérer le son même dans une version accélérée de la vidéo)

### Backups quotidien

Chaque jour de travail sur l’application, un backup est fait et placé, avec la date inversée du jour, dans le dossier `xbackups` du jour. Pour le moment, la récupération doit se faire à la main.

Noter que les fichiers `aevents.yaml` et `locators.yaml` ne sont pas à proprement parler des fichiers `YAML`. Ils rassemblent simplement tous les fichiers des dossiers `events` et `locators` du film.

On peut détruire régulièrement les dossiers les plus vieux, si tout est OK.

---

[K_1]: ./img/clavier/K_1.png
[K_9]: ./img/clavier/K_9.png
[K_A]: ./img/clavier/K_A.png
[K_C]: ./img/clavier/K_C.png
[K_H]: ./img/clavier/K_H.png
[K_I]: ./img/clavier/K_I.png
[K_J]: ./img/clavier/K_J.png
[K_K]: ./img/clavier/K_K.png
[K_L]: ./img/clavier/K_L.png
[K_N]: ./img/clavier/K_N.png
[K_O]: ./img/clavier/K_O.png
[K_P]: ./img/clavier/K_P.png
[K_R]: ./img/clavier/K_R.png
[K_S]: ./img/clavier/K_S.png
[K_T]: ./img/clavier/K_T.png
[K_U]: ./img/clavier/K_U.png
[K_V]: ./img/clavier/K_V.png
[K_X]: ./img/clavier/K_X.png
[Ctrl]: ./img/clavier/K_Control.png
[Control]: ./img/clavier/K_Control.png
[Cmd]: ./img/clavier/K_Command.png
[Command]: ./img/clavier/K_Command.png
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

[la vidéo active]: #video-active
[le fichier `config.yml`]: #fichier-config
[fichier `config.yml`]: #fichier-config
[la console]: #console
