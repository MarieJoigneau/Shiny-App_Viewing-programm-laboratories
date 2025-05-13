# Auteur : Marie JOIGNEAU (INRAE)

# TITRE : Visualisation des emplacements des unités de recherche (map1) et des 
# lieux où les projets de FairCarboN opèrent (map2) dans le monde entier


# =============================================================================
# =============================================================================
# ======================== LIBRARY ============================================
# =============================================================================
# =============================================================================

library(leaflet)
library(readxl)
library(openxlsx)
library(pals)
library(ggthemes)
library(shiny)
library(shinythemes)
library(rAmCharts)
library(shinyWidgets)
library(dplyr)
library(stringr)

# =============================================================================
# =============================================================================
# =========================== MAIN ============================================
# =============================================================================
# =============================================================================

# =============================================================================
# ============== CARTE 1 : Lieux des différents projets =======================
# =============================================================================

# ============== INTRODUCTION =================================================

df <- read_excel("./www/data/2025 04 24 Liste unités par projet RNSR_propre.xlsx")


df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)


### Couleurs B-BEST
vert <- rgb(39, 207, 163, maxColorValue = 255)
bleu1 <- rgb(0, 159, 227, maxColorValue = 255)
jaune <- rgb(255, 206, 50, maxColorValue = 255)
violet <- rgb(227, 41, 161, maxColorValue = 255)
bleu2 <- rgb(44, 81, 162, maxColorValue = 255)

# ============== LES PROJETS ==================================================

# Liste des projets mis dans l'ordre alphabétique
projet_list <- unique(df$Projet)
projet_list <- projet_list[order(projet_list)]


# ============== DECALER LES LAT LONG DES PROJETS AU MÊME EMPLACEMENT =========


# On trouve les lignes avec latitude longitude en double
idx = which(duplicated(df$Latitude, fromLast = TRUE)==TRUE)

### Ajouter un "jitter" pour décaler légèrement les coordonnées de ceux en double
# Création colonne
df$Latitude_jitter = df$Latitude
df$Longitude_jitter = df$Longitude
# Modification légère latitude longitude pour ceux au même emplacement
df$Latitude_jitter[idx] = jitter(df$Latitude[idx], factor = 0.5)
df$Longitude_jitter[idx] = jitter(df$Longitude[idx], factor = 0.5)


# ============== TUTELLES =====================================================

df$`Etablissement tutelle RNSR` <- 0

for (h in 1:nrow(df)) {
  
  #print("===== h = ",h," ======")
  
  ## Lien établissement de la ligne h
  etab <- df$`Lien établissement`[h]
  
  ## On trouve les emplacements de \r\n et de -tutelle
  # gregexpr renvoie une liste (même s’il n’y a qu’un seul élément)
  tutelle <- as.integer(gregexpr("-tutelle", etab)[[1]])
  rn <- as.integer(gregexpr("\r\n", etab)[[1]]) + 2
  rn <- c(1,rn)
  print(tutelle)
  print(rn)
  
  if (is.na(tutelle[1]) == TRUE) {
    
    df$`Etablissement tutelle RNSR`[h] <- df$`Établissement de tutelle Mélanie`[h]
    
  }else{
    
    ## On enlève les emplacements de \r\n correspondant à autre chose qu'à des tutelles
    rn_propre <- c()
    for (j in 1:length(tutelle)){
      # idx n juste en dessous de l'idx tutelle
      rn_propre <- c(rn_propre, rn[max(which(rn < tutelle[j]))])
    }
    print(rn_propre)
    
    ## Et on obtient les établissements au propre
    mot <- c()
    for (i in 1:length(tutelle)){
      
      print(i)
      mot <- c(mot,substr(etab,rn_propre[i],tutelle[i]-1))
      print(mot)
      
    }
    print(mot)
    
    ## On corrige
    mot[mot == "INSA TOULOUSE"] <- "INSA Toulouse" 
    
    ## On rassemble le tout pour le remettre dans le dataframe
    mot <- paste(mot, collapse =" ; ")
    df$`Etablissement tutelle RNSR`[h] <- mot
    
  }
  
  
}



# ============== LISTE DES TUTELLES ===========================================

tutelle_list <- paste(as.vector(df$`Etablissement tutelle RNSR`), collapse = " ; ")
tutelle_list <- strsplit(tutelle_list, " ; ")[[1]]
tutelle_list <- sort(unique(tutelle_list))
print(tutelle_list)




