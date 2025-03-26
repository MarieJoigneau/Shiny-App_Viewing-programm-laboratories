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

# =============================================================================
# =============================================================================
# =========================== MAIN ============================================
# =============================================================================
# =============================================================================

# =============================================================================
# ============== CARTE 1 : Lieux des différents projets =======================
# =============================================================================

# ============== INTRODUCTION =================================================

df <- read_excel("./www/data/2025_03_26_Listing_Unités_FORESTT.xlsx",  
                sheet = "Liste")

df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)


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
df$Latitude_jitter[idx] = jitter(df$Latitude, factor = 0.0001)
df$Longitude_jitter[idx] = jitter(df$Longitude, factor = 0.0001)


