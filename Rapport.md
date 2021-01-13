# Projet L-Système

## Membres

| Nom     | Prénom | identifiant | n° étudiant |
|---------|--------|-------------|-------------|
| SOUFFAN | Nathan | @souffan    | 71802563    |
| BOUARAH | Romain | @bouarah    | 71801189    |

## Fonctionnalités

Voici les fonctionnalités implémentées
	
### Parser
Notre projet permet de lire des L-système depuis des fichiers `.sys` au format
décrit dans le sujet. Le parser gère aussi les listes de commandes.

### Dessin à l'échelle
Le dessin du L-système se fait automatiquement à l'échelle, c'est à dire que le
L-système occupera le maximum d'espace à l'écran. De plus, le L-système sera 
centré.

### Exportation en SVG
Il est possible d'exporter une itération d'un L-système au format *SVG*. La
couleur de la tortue et l'épaisseur des traits sont aussi pris en compte durant
l'exportation.

### Couleur
Nous avons étendu le langage de la tortue pour permettre le changement de
couleur. Le changement de couleur est statique, c'est à dire que le code *RGB* 
de la couleur est connu à l'avance et ne dépend pas de l'état courant de la
tortue.

### Largeur du trait
La largeur du trait laissé par le passage de la tortue peut être
modifié. L'élargissement et le rétrécissement du trait se fait uniquement par
pas de 1. Nous avons fait ce choix car :
1. Le livre de référence utilisait cette convention
2. Nous voulions une différence avec le changement de couleur
3. On obtenait des meilleurs résultats sur les L-systèmes arborescent

### GUI
Nous proposons une interface certes rudimentaire mais efficace pour manipuler
les L-systèmes. L'utilisateur manipule les L-systèmes au clavier. Les commandes
sont décrites dans la section suivante.

## Mis en route

### Dépendance
Nous utilisons la librairie
[Graphics](https://ocaml.github.io/graphics/graphics/Graphics/index.html) pour
toute la partie affichage.

### Compilation
Taper `make` pour lancer la compilation.

### Utilisation
`./run [CHEMIN VERS FICHIER .sys]`

Commandes possibles au clavier :
```
<space>: Dessine le L-Systeme courant
<+>: Calcule l'itération suivante du L-Système courant
<->: Calcule l'itération précédente du L-Système courant
<0> à <9>: Calcule la i-ième itération du L-Systeme chargé initialement
<s>: Sauvegarde le L-système courant en image vectoriel dans lsystem.svg
<q>: Quitter
```

Il n'est pas possible de lancer le projet sans donner un fichier `.sys`.
Enfin, on ne peut pas changer de L-Système sans relancer le programme.

## Description des modules

### Command
Les entrées clavier de l'utilisateur sont gérées par ce module. Ce module est
destiné à être uniquement appelé par *Main*.

### Main
Le module *Main* est resté assez intact : les messages sont juste plus étoffés

### Parser
Le module *Parser* permet de créer un type `char system` à partir d'un chemin
vers un fichier `.sys`.

#### Format des fichiers .sys
Le parser lit les fichiers `.sys` respectant le format de l'énoncé, plus ce qui
suit :

* Pour la couleur, il faut utiliser la commande *CR,G,B* où R, G et B sont des
  entiers compris entre 0 et 255. Ces entiers doivent être écrits sur 3
  caractères. __Exemple :__ `C000,200,000`

* Pour le changement d'épaisseur de la ligne : *I* pour élargir le trait et *D*
  pour le rétrécir. Si l'épaisseur de la tortue doit être négative alors tous 
  les traits sont élargis pour rester supérieur strict à 1.

* Pour exécuter plusieurs commandes pour un même symbole, il faut séparer les
  commandes par des espaces. Les commandes sont lancées de gauche à droite.
  __Exemple :__ `Y C139,069,019 L15`, il y aura d'abord un changement de 
  couleur puis une ligne.
  
### Systems
Un module principal pour manipuler les L-Systèmes. Le module nous fournit des
fonctions pour afficher à l'échelle les L-Systèmes et calculer les prochaines
itérations des L-Systèmes (en utilisant l'astuce de l'énoncé).

### To_svg
Ce module a pour rôle l'exportation des L-Systèmes au format *SVG*. Le résultat
est écrit dans le fichier *lsystem.svg* dans le répertoire courant.

### Turtle
L'autre module principal du projet, il s'agit des opérations sur la tortue. La
tortue ne se manipule qu'en style fonctionnel et qu'à travers la fonction
`exec`.


Nous avons eu des difficultés sur les conversions entre *int* et *float*.
D'une part, la position de la tortue est en *float*.
D'autre part, les commandes de déplacement de la tortue prennent des *int* en
paramètre et la librairie *Graphics* travaille exclusivement avec des *int*.  

Ces conversions nous ont posé des problèmes dans l'affichage des L-Systèmes avec
de grandes itérations. Pour palier à ce problème, `exec` prend un argument un
*float* agissant comme un scalaire sur les distances.
La fonction `exec` est censée être utilisé comme une clôture où l'on a fournit
ce scalaire.

## Organisation du travail

### Partage des tâches
On a essayé de se partager les tâches en fonction de leur difficulté et,
généralement, nous travaillions chacun sur une fonctionnalité différente, à part
pour le Parser où nous avons travaillé tous les deux dessus.

### Chronologie du projet
Avant le confinement (30 Octobre 2020) nous avons seulement lu le sujet sans
coder.


Voici une chronologie de notre travail :

* Novembre 2020 (du 8 jusqu'au 20)
  1. Tortue (en impératif, par contre)
  2. Fonction de dessin des L-Systèmes (sans l'échelle)
  3. Fonction de calcul des prochaines itérations
  4. Parser implémenté au 3/4
  
* Décembre 2020 (à partir du 16)
  1. Parser implémenté entièrement
  2. Tortue en style fonctionnel
  3. Le dessin des L-Systèmes se fait à l'échelle
  4. Le projet est utilisable pour l'utilisateur final
  
* Janvier 2021 (du 2 jusqu'au 14)
  1. Refactorisation de la fonction de calcul de l'échelle et de la fonction de
	 dessin en utilisant des fonctions d'ordres supérieurs
  2. Exportation en SVG
  3. Couleur pour la tortue
  4. Épaisseur du trait pour la tortue

