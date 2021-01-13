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
décrit dans le sujet. 

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
couleur. Dans les fichiers `.sys` cela se traduit par la commande *CR,G,B* où R,
G et B sont des entiers compris entre 0 et 255. Ces entiers doivent être écrits
sur 3 caractères.

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

### Turtle.ml
La tortue est implémentée dans ce fichier. Une fenêtre *Graphics* doit déjà être
ouverte avant de pouvoir utiliser la tortue.  
La tortue se contrôle au moyen de la fonction `exec` et peut : Avancer en
traçant une ligne 

## Organisation du travail

### Partage des tâches
On a essayé de se partager les tâches en fonction de leur difficulté et,
généralement, nous travaillions chacun sur une fonctionnalité différente, à part
pour le Parser où nous avons travaillé tous les deux dessus.

### Chronologie du projet
Avant le confinement (30 Octobre 2020) nous avons seulement lu le sujet sans
coder. Toutefois

