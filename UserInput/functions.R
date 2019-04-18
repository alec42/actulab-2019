## Alec James van Rassel, Ian Shaink, Nicolas Gagnon
## Actulab 2019: Problématique Cooperators
### Mise en oeuvre d'algorithme de web scrapping pour déterminer des probabilités sur si des compagnies sont des coopéartives
### importation des packages
library(tidyverse)
library(rvest)
library(XML)
library(RCurl)
library(googleway)

# importer les données obtenues manuellement et utilisées pour le GLM
donnees_manuel <- read.csv("data_final_glm.csv")

# clé pour le API de Google Maps
# apikey <- "REMOVED"

## La fonction "scrape" effectue une recherche Google pour les URLs correspondant au texte entré en argument
## 
## Argument
## NAME: argument de type character entré par l'utilisateur; devrait être le nom de la compagnie
##
## Le resultat est une liste des 10 URLs sur la première page de Google trouvés
## Nous selectons uniquement le premier résultat plus tard dans la fonction runall
## 

scrape <- function(NAME){
    
    # chercher les liens
    links <- read_html(URLencode(paste0("https://www.google.com/search?q=", NAME))) %>% 
        html_nodes(".r a") %>% 
        html_attr("href") 
    
    # nettoyer les liens
    links = gsub('/url\\?q=','',sapply(strsplit(links[as.vector(grep('url',links))],split='&'),'[',1))
}

## La fonction "site_gmaps" effectue une recherche sur l'API de Google Maps pour trouver l'URL du site web d'une compagnie rentrée en argument
## 
## Argument
## NOM: argument de type character entré par l'utilisateur; devrait être le nom de la compagnie
##
## Packages
## Googleway: package pour utiliser l'API de Google Maps
##
## Le resultat est soit l'URL de la compagnie s'il est trouvé ou rien sinon
## 
site_gmaps <- function(NOM)
{
    require(googleway)
    myPlace <- google_places(search_string = NOM, key = apikey)
    if(length(myPlace$results) != 0){
        myPlaceId <- myPlace$results[1, ]$place_id
        google_place_details(place_id = myPlaceId, key = apikey)$result$website
    }
}

## La fonction "GoogleHits" effectue une recherche Google pour compter le nombre de résultats pour une recherche google raffiné à un site "input" et optionellement avec des mots clés "twoput" 
## 
## Argument
## input: URL pour le site de la compagnie à chercher
## twoput: mots clés, vide par défaut
##
## Packages
## XLM et Rcurl: pour interpreter les URLs et les résultats google
##
## Le resultat est le nombre de pages de la recherche
## 

GoogleHits <- function(input, twoput = ""){
    require(XML)
    require(RCurl)
    url <- paste("https://www.google.com/search?q=site:",
                 gsub(pattern = " ", replacement = "", x = input), 
                 paste("%20", twoput, sep = ""), sep = "") # on colle ensemble la recherche google nécessaire, ainsi que les mots clés s'il y a lieu
    CAINFO = paste(system.file(package="RCurl"), "/CurlSSL/ca-bundle.crt", sep = "")
    script <- getURL(url, followlocation = TRUE, cainfo = CAINFO, ssl.verifypeer = F)
    doc <- htmlParse(script)
    res <- xpathSApply(doc, '//*/div[@id="resultStats"]', xmlValue)
    return(as.integer(gsub("[^0-9]", "", res))) # on retourne uniquement le nombre
}

##
## La fonction "totalhits" utilise la fonction "GoogleHits" pour récursivement compter le nombre de résultats pour le site en entier et pour des mots clés en plus du ratio du nombre de pages avec un groupe de mots clés pour COOP
## 
## Argument
## URL: lien au site web de la compagnie
## noms: nom de la compagnie, URL par défaut
##
## Le resultat est une matrice avec le nombre de pages totale, le nombre avec le groupe de mots de COOP, et le ratio qui contiennent COOP
## 

totalhits <- function(URL, noms = URL){
    table_results <- matrix(nrow = length(URL), ncol = 3)
    colnames(table_results) <- c("Nb. total", "Nb. coop", "ratio")
    no.hits.total <- list()
    no.hits.coop <- list()
    ratio <- list()
    for(i in seq_along(URL)){
        no.hits.total[[i]] <- GoogleHits(URL[i])
        no.hits.coop[[i]] <- GoogleHits(URL[i], "cooperative+OR+OR+OR+coop+OR+OR+OR+co-operative")
        ratio[[i]] <- no.hits.coop[[i]]/no.hits.total[[i]]
        if(is.na(no.hits.total[[i]]))
            no.hits.total[[i]] <- 0
        
        if(is.na(no.hits.coop[[i]]))
        {
            no.hits.coop[[i]] <- 0
            ratio[[i]] <- 0 
        }
        table_results[i, 1:3] <- c(no.hits.total[[i]], no.hits.coop[[i]], ratio[[i]])
    }
    table_results
}

##
## GLM
## 
## Nous établissons un GLM en utilisant le ratio des pages contenant le groupe de mots pour COOP ainsi que le nombre d'occurences total
## 

glm.fit <- glm(iscoop ~ ratio1 + coop, data = donnees_manuel, family = binomial)

##
## La fonction "runall" mets le tout ensemble et effectue la recherche du URL avec les fonctions "site_gmaps" et "scrape" à partir du nom, ensuite calcule les statistique sur le nombre de résultats avec "totalhits" en plus de calculer les probabilités
## 
## Argument
## Compagnie: nom de la compagnie à chercher
##
## Le resultat est une matrice avec le nom de la compagnie, sa probabilité d'être une COOP, et le URL utilisé
## 

runall <- function(Compagnie)
{
    site <- site_gmaps(Compagnie)
    if(is.null(site)){
        site <- scrape(Compagnie)[1]
    }
    stats <- totalhits(site)
    
    # On trouve les probs pour toutes les données obtenues par l'algorithme
    # Grâce au glm construit avec les données manuelles
    
    # condition que s'il y a qu'un seul résultat
    if(stats[, 3] == 1 && stats[, 2] == 1 && grepl("coop|co-operative|cooperative|co-op", Compagnie, ignore.case = T) != T)
        Prob <- "Données insuffisantes, vérification manuelle requise"
    else
        Prob <- predict(glm.fit, newdata=data.frame(ratio1 = stats[, 3], coop = stats[, 2]), type="response") 
    
    data.frame(Compagnie, Prob, "URL" = site)
}

##
## La fonction "runallvec" est similaire à "runall" mais récursivement elle applique la fonction lorsqu'il y a plus d'un élément
## 
## Argument
## Compagnie: nom de la compagnie à chercher
##
## Le resultat est une matrice avec le nom de la compagnie, sa probabilité d'être une COOP, et le URL utilisé
## 

runallvec <- function(Compagnie){
    if(length(Compagnie) != 1)
    {
      data_noms <- do.call("rbind", lapply(1:length(Compagnie), function(i) runall(Compagnie[i])))
        data_noms[order(data_noms$Prob, decreasing = T), ]
    }
    else
        runall(Compagnie)
}
