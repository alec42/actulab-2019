

<!-- PROJECT SHIELDS -->
[![LinkedIn][linkedin-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/alec42/actulab-2019">
    <img src="actulab logo.png" alt="Logo" height="80">
  </a>

  <h3 align="center">Actulab 2019: Problématique Cooperators</h3>

  <p align="center">
    Un algorithme qui détecte les coopératives!
    <br />
    <a href="https://github.com/alec42/actulab-2019"><strong>Explorer les documents »</strong></a>
    <br />
    <br />
    <a href="https://alec42.shinyapps.io/ActulabCooperators/">Voir application</a>
  </p>
</p>



<!-- TABLE DES MATIÈRES -->
## Table des matières

* [À propos du projet](#À-propos-du-projet)
  * [Approche](#Approche)
* [Explication des étapes](#Explication)
  * [URL](#Obtention-d’URL)
  * [Compte](#Compte)
  * [Statistiques](#Statistiques)
  * [Application Shiny](#Application-Shiny)
* [Développeurs](#Développeurs)



<!-- ABOUT THE PROJECT -->
## À propos du projet

[La problématique](https://github.com/alec42/actulab-2019/blob/master/Documents%20de%20r%C3%A9f%C3%A9rence/Probl%C3%A9matique%20Cooperators%202019.pdf) est de construire un algorithme pour prédire si une compagnie est une coopérative.

Pour ce faire:
* Un fichier de données contenant une liste de noms de compagnies est disponible pour tester l'algorithme
* Une présentation sur le web scraping en R incluant des ressources pour l'apprendre mise à notre disposition suite à sa présentation
* 2 semaines sont allouées pour résoudre la problématique

### Approche

Notre approche consiste à: 

1. Obtenir des URL pour les compagnies
1. Compter le nombre de pages que contiennent les sites au total pour comparer avec le nombre de pages contenant des groupes de mots clés
1. Établir un modèle linéaire généralisé pour prédire si une compagnie est une coopérative basé sur des données obtenues manuellement
1. Construire et mettre en place une application shiny avec 2 onglets; un pour l'entrée individuelle de noms et un pour une liste de noms

<!-- GETTING STARTED -->
## Explication

Voici une explication de notre approche plus en détail

### Obtention d’URL

Afin d'obtenir les URL pour les sites des compagnies, l'API de Google Maps est utilisé pour trouver les URL des compagnies dans leur description. 
Cette méthode est très efficace, car Google Maps est très précis, s'il retourne un résultat il est presque toujours le bon; sinon il n'en retourne pas.

Si l'algorithme ne peut retrouver la compagnie sur Google Maps, il utilise en suite une fonction qui retourne le premier résultat d'une recherche Google du lien.

Pour voir des statistiques sur l'efficacité de cette méthode, voir la présentation PowerPoint.

### Compte

Suite à l'obtention de l’URL menant au site, l'algorithme compte le nombre total de pages que contient le site en effectuant une recherche Google du style: "site:<URL>".
Ceci recherche uniquement le site.
Par la suite, on effectue une recherche en rajoutant des groupes de mots clés ce qui retourne le nombre de pages les contenant.

### Statistiques

Ayant obtenu ces deux comptes, nous utilisons un modèle linéaire généralisé (GLM) pour prédire la probabilité qu'une compagnie soit une coopérative. 
Le GLM est basé sur 119 données obtenues manuellement; à noter que ceci n'est évidemment pas assez de données pour un modèle conclusif, mais assez pour les buts de la présentation et problématique.

### Application Shiny

Tout ceci est mis ensemble dans une [application shiny](https://alec42.shinyapps.io/ActulabCooperators/).

Il y a 2 onglets. Le premier contient une option de saisie de texte pour chercher des compagnies une à la fois. Le deuxième contient une option d'entrer un fichier CSV contenant une liste de noms.

<a href="https://github.com/alec42/actulab-2019">
  <img src="onglet manuel.png" alt="screenshot">
</a>

<a href="https://github.com/alec42/actulab-2019">
  <img src="onglet fichier.png" alt="screenshot">
</a>

## Développeurs

Application développée par: 

- Alec James van Rassel
- Ian Shaink
- Nicolas Gagnon

étudiants en actuariat à l'Université Laval


<!-- MARKDOWN LINKS & IMAGES -->
[build-shield]: https://img.shields.io/badge/build-passing-brightgreen.svg?style=flat-square
[contributors-shield]: https://img.shields.io/badge/contributors-1-orange.svg?style=flat-square
[license-shield]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square
[license-url]: https://linkedin.com/in/alec-james-van-rassel/
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
