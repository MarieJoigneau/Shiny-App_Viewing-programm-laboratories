# Auteur : Marie JOIGNEAU (INRAE)

# TITRE : Visualisation des emplacements des unités de recherche (map1) et des 
# lieux où les projets de FairCarboN opèrent (map2) dans le monde entier


# Permet de se connecter au compte internet pour mettre la ShinyApp sur le net
rsconnect::setAccountInfo(name='us-pepr',
                          token='4ADBC431E88EDB6BE101F0ADCAB38AAA',
                          secret='pePuvHqrtPPPckRsEStKgExG8Ya04NCmf/NjMud9')



shinyServer(function(input, output, session) {
  
  # =============================================================================
  # ========== Unités des différents projets du PEPR AgroEcoNum ==========
  # =============================================================================
  
  output$carte1 <- renderLeaflet({
    
    # ============= 1) CARTE 1 : TOUS LES PROJETS ====================================================
    
    if (input$type_carte1 == "Tous les projets"){
      
      # ------------- LES CHOIX DE PROJETS ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      df_choice <- df[(df$Projet %in% input$projets_carte1),]
      
      # Liste des projets choisis
      projet_list_choisi <- unique(df_choice$Projet)
      projet_list_choisi <- projet_list_choisi[order(projet_list_choisi)]
      
      # Facteurs et couleurs associées à la carte
      info <- c("Algadvance","Amaretto","Applestorm","BioFUMAC","BioMCat",
                "Collimator","COPE","ElectroMIC","FillingGaps","FLAVOLASES",
                "Furfun","GalaxyBioProd","MALIGNE","Mamabio","Micro-Mass",
                "MuSiHC","Nanomachines","Optisfuel","PREMIERE LIGNE","PRODIGES",
                "PuLCO","ROSALIND","SmartCoupling","Tbox4BioProd","WAEster",
                "Wallmat")
      list_couleur <- c("red","gold","blue","green","cyan",
                        "black","darkorange","darksalmon","deeppink","darkgrey",
                        "purple", "darkgreen", "brown","orchid","palegreen",
                        "paleturquoise","palevioletred","plum","darkseagreen","chocolate",
                        "yellow","tan","coral","antiquewhite","chartreuse",
                        "lightpink")
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 5.5) %>% 
        addTiles()
      
      # ------------- CERCLES SUR LA CARTE -------------
      
      # On note les indices pour réduire la légende aux choix sélectionnés
      idx_selectionnes <- c()
      
      # Pour chaque projet
      for (i in 1:length(info)){
        
        # Si le projet est choisi par l'utilisateur :
        if (info[i] %in% projet_list_choisi){
          
          # On rajoute l'indice du projet pour la légende
          idx_selectionnes <- c(idx_selectionnes,i)
          
          # On réduit le dataframe au projet i choisi
          dfi <- df_choice[((df_choice$Projet==info[i]) &
                              (is.na(df_choice$Projet)==FALSE)),]
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 0.4,
                                     color = list_couleur[i],
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Projet</b></u> = ", dfi$Projet))
        }
      }
      
      
      # ------------- LEGENDES ET AFFICHAGE -------------
      
      # On prépare les indices selectionnés pour la légende
      idx_selectionnes <- sort(idx_selectionnes)
      
      # Ajout de la légende
      longline_map <- addLegend(longline_map, position = "bottomleft",
                                colors = list_couleur[idx_selectionnes],
                                labels = info[idx_selectionnes],
                                title = "Projets du PEPR B-BEST", opacity = 10) 
      
      # Affichage de la carte
      longline_map
      
    }
    
    # ============= 2) CARTE 2 : TOUS LES PROJETS ====================================================
    
    else if (input$type_carte1 == "1 projet"){
      
      
      # ------------- LES CHOIX DE PROJETS ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      df_choice <- df
      
      # Liste des projets choisis
      #projet_list_choisi <- unique(df_choice$Projet)
      #projet_list_choisi <- projet_list_choisi[order(projet_list_choisi)]
      
      # Facteurs et couleurs associées à la carte
      info <- c("Algadvance","Amaretto","Applestorm","BioFUMAC","BioMCat",
                "Collimator","COPE","ElectroMIC","FillingGaps","FLAVOLASES",
                "Furfun","GalaxyBioProd","MALIGNE","Mamabio","Micro-Mass",
                "MuSiHC","Nanomachines","Optisfuel","PREMIERE LIGNE","PRODIGES",
                "PuLCO","ROSALIND","SmartCoupling","Tbox4BioProd","WAEster",
                "Wallmat")
      list_couleur <- rep("lightgrey",26)
      idx_choisi <- which(info==input$projet_unique)
      list_couleur[idx_choisi] <- bleu2
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 5.5) %>% 
        addTiles()
      
      # ------------- CERCLES SUR LA CARTE -------------
      
      # On note les indices pour réduire la légende aux choix sélectionnés
      idx_selectionnes <- c()
      
      # Pour chaque projet
      for (i in 1:length(info)){
        
        # On réduit le dataframe au projet i choisi
        dfi <- df_choice[((df_choice$Projet==info[i]) &
                            (is.na(df_choice$Projet)==FALSE)),]
        
        
        # Si le projet n'est pas choisi par l'utilisateur :
        if (info[i] != input$projet_unique){
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 0.6,
                                     color = "lightgrey",
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Projet</b></u> = ", dfi$Projet))
        }
      }
      
      # Pour chaque projet
      for (i in 1:length(info)){
        
        # On réduit le dataframe au projet i choisi
        dfi <- df_choice[((df_choice$Projet==info[i]) &
                            (is.na(df_choice$Projet)==FALSE)),]
        
        # Si le projet est choisi par l'utilisateur :
        if (info[i] == input$projet_unique){
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 1,
                                     color = bleu2,
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Projet</b></u> = ", dfi$Projet))
        }
        
      }
      
      
      
      
      # ------------- LEGENDES ET AFFICHAGE -------------
      
      # On prépare les indices selectionnés pour la légende
      idx_selectionnes <- sort(idx_selectionnes)
      
      # Ajout de la légende
      longline_map <- addLegend(longline_map, position = "bottomleft",
                                colors = list_couleur,
                                labels = info,
                                title = "Projets du PEPR AgroEcoNum", opacity = 10) 
      
      # Affichage de la carte
      longline_map
      
    }
    
    
    
    # ============= 3) CARTE 3 : TOUTES LES TUTELLES ====================================================
    
    else if (input$type_carte1 == "Toutes les tutelles"){
      
      # ------------- LES CHOIX DE TUTELLES ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      idx <- c()
      print("---------- input$tutelles_carte1 ---------------")
      print(input$tutelles_carte1)
      for (i in 1:length(input$tutelles_carte1)){
        print(paste("======",i,"======"))
        print(input$tutelles_carte1[i])
        idx <- c(idx, which(str_detect(df$`Etablissement tutelle RNSR`,input$tutelles_carte1[i]) == TRUE))
        print(idx)
      }
      idx <- unique(sort(idx))
      print(idx)
      df_choice <- df[idx,]
      
      # Liste des projets choisis
      # tutelle_list_choisi <- unique(df_choice$`Etablissement tutelle RNSR`)
      # tutelle_list_choisi <- paste(as.vector(tutelle_list_choisi), collapse = " ; ")
      # tutelle_list_choisi <- strsplit(tutelle_list_choisi, " ; ")[[1]]
      # tutelle_list_choisi <- sort(unique(tutelle_list_choisi))
      tutelle_list_choisi <- input$tutelles_carte1
      print("tutelle_list_choisi")
      print(tutelle_list_choisi)
      
      # Facteurs et couleurs associées à la carte
      info <- c("AGROPARISTECH","AIX-MARSEILLE","AMIENS","BORDEAUX","Bordeaux INP",
                "CAEN","CEA","CENTRALESUPELEC","CIHEAM","CIRAD",
                "CNRS","CPE LYON","E.N.VET.TLSE","EC. CENTRALE MARSEILLE","EC. POLYTECHNIQUE",
                "ENPC PARIS","ENS CHIM. LILLE","ENS LYON","ENSI CAEN","ESPCI PARIS",
                "EVRY","GRENOBLE ALPES","GRENOBLE INP","IFPEN","IMT Atlantique",
                "IMT MINES ALES","INP TOULOUSE","INRAE","INRIA","INS.CURIE",
                "INSA Toulouse","INSERM","Institut Agro","IP PARIS","IRD",
                "JUNIA","LILLE","LORRAINE","LYON 1","MinesTélécom",
                "MONTPELLIER","Nantes Université","ONIRIS NANTES ATLANTIQUE","PSL","REIMS",
                "SORBONNE UNIV.","TOULON","TOULOUSE 3","U PARIS-SACLAY","U. STRASBOURG",
                "UniCA","Université de Toronto","UP","VETAGRO SUP")
      list_couleur <- c("red","gold","blue","green","cyan",
                        "black","darkorange","darksalmon","deeppink","darkgrey",
                        "purple", "darkgreen", "brown","orchid","palegreen",
                        "paleturquoise","palevioletred","plum","darkseagreen","chocolate",
                        "yellow","tan","coral","antiquewhite","chartreuse",
                        "darkolivegreen","aquamarine","darkmagenta","bisque","darkorchid",
                        "blueviolet","burlywood","cadetblue","cornflowerblue","cornsilk",
                        "darkblue", "darkcyan", "darkgoldenrod","darkkhaki","darkred",
                        "darkseagreen","darkslateblue","darkslategray","darkturquoise","darkviolet",
                        "deepskyblue","dimgray","dodgerblue","firebrick","forestgreen",
                        "goldenrod","greenyellow","khaki","turquoise")
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 5.5) %>% 
        addTiles()
      
      # ------------- CERCLES SUR LA CARTE -------------
      
      # On note les indices pour réduire la légende aux choix sélectionnés
      idx_selectionnes <- c()
      
      # Pour chaque projet
      for (i in 1:length(info)){
        
        print("info")
        print(info)
        
        # Si le projet est choisi par l'utilisateur :
        if (info[i] %in% tutelle_list_choisi){
          
          # On rajoute l'indice du projet pour la légende
          idx_selectionnes <- c(idx_selectionnes,i)
          
          # On réduit le dataframe au projet i choisi
          dfi <- df_choice[(str_detect(df_choice$`Etablissement tutelle RNSR`,info[i]) == TRUE),]
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 0.4,
                                     color = list_couleur[i],
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Tutelle</b></u> = ", dfi$`Etablissement tutelle RNSR`))
        }
      }
      
      
      # ------------- LEGENDES ET AFFICHAGE -------------
      
      # On prépare les indices selectionnés pour la légende
      idx_selectionnes <- sort(idx_selectionnes)
      
      # Ajout de la légende
      print("idx_selectionnes")
      print(idx_selectionnes)
      len <- length(idx_selectionnes)
      print(idx_selectionnes[1:(len/2)])
      print(idx_selectionnes[(len/2+1):len])
      longline_map <- addLegend(longline_map, position = "bottomleft",
                                colors = list_couleur[idx_selectionnes[1:(len/2)]],
                                labels = info[idx_selectionnes[1:(len/2)]],
                                title = "Tutelles du PEPR B-BEST", opacity = 10) 
      if (len > 1){
        longline_map <- addLegend(longline_map, position = "bottomright",
                                  colors = list_couleur[idx_selectionnes[(len/2+1):len]],
                                  labels = info[idx_selectionnes[(len/2+1):len]],
                                  title = "Tutelles du PEPR B-BEST", opacity = 10)
      }

      # Affichage de la carte
      longline_map
      
    }
    
    # ============= 4) CARTE 4 : 1 TUTELLE ====================================================
    
    else if (input$type_carte1 == "1 tutelle"){
      
      
      # ------------- LES CHOIX DE TUTELLES ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      df_choice <- df
      
      # Facteurs et couleurs associées à la carte
      info <- c("AGROPARISTECH","AIX-MARSEILLE","AMIENS","BORDEAUX","Bordeaux INP",
                "CAEN","CEA","CENTRALESUPELEC","CIHEAM","CIRAD",                   
                "CNRS","CPE LYON","E.N.VET.TLSE","EC. CENTRALE MARSEILLE","EC. POLYTECHNIQUE",       
                "ENPC PARIS","ENS CHIM. LILLE","ENS LYON","ENSI CAEN","ESPCI PARIS",             
                "EVRY","GRENOBLE ALPES","GRENOBLE INP","IFPEN","IMT Atlantique",          
                "IMT MINES ALES","INP TOULOUSE","INRAE","INRIA","INS.CURIE",               
                "INSA Toulouse","INSERM","Institut Agro","IP PARIS","IRD",                     
                "JUNIA","LILLE","LORRAINE","LYON 1","MinesTélécom",            
                "MONTPELLIER","Nantes Université","ONIRIS NANTES ATLANTIQUE","PSL","REIMS",                   
                "SORBONNE UNIV.","TOULON","TOULOUSE 3","U PARIS-SACLAY","U. STRASBOURG",           
                "UniCA","Université de Toronto","UP","VETAGRO SUP")
      list_couleur <- rep("lightgrey",54)
      idx_choisi <- which(info==input$tutelle_unique)
      list_couleur[idx_choisi] <- bleu2
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 5.5) %>%  
        addTiles()
      
      # ------------- CERCLES SUR LA CARTE -------------
      
      # On note les indices pour réduire la légende aux choix sélectionnés
      idx_selectionnes <- c()
      
      # Pour chaque tutelle
      for (i in 1:length(info)){
        
        # On réduit le dataframe à la tutelle i choisi
        dfi <- df_choice[(str_detect(df_choice$`Etablissement tutelle RNSR`,info[i]) == TRUE),]
        
        # Si la tutelle n'est pas choisi par l'utilisateur :
        if (info[i] != input$tutelle_unique){
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 0.6,
                                     color = "lightgrey",
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Tutelle</b></u> = ", dfi$`Etablissement tutelle RNSR`))
        }
      }
      
      # Pour chaque tutelle
      for (i in 1:length(info)){
        
        # On réduit le dataframe à la tutelle i choisi
        dfi <- df_choice[(str_detect(df_choice$`Etablissement tutelle RNSR`,info[i]) == TRUE),]
        
        # Si la tutelle est choisi par l'utilisateur :
        if (info[i] == input$tutelle_unique){
          
          # On ajoute les cercles 1 par 1
          longline_map <- addCircles(longline_map,
                                     # On prend les lignes du df avec ce projet
                                     lng = dfi$Longitude_jitter,
                                     lat = dfi$Latitude_jitter,
                                     weight = 15,
                                     radius = 1,
                                     fillOpacity = 1,
                                     color = bleu2,
                                     popup = paste("<b><u>Structure</b></u> = ",paste(dfi$Sigle,dfi$`Libellé structure`,sep=" - "),
                                                   "<br><b><u>Tutelle</b></u> = ", dfi$`Etablissement tutelle RNSR`))
        }
        
      }
      
      
      
      
      # ------------- LEGENDES ET AFFICHAGE -------------
      
      # On prépare les indices selectionnés pour la légende
      idx_selectionnes <- sort(idx_selectionnes)
      
      # Ajout de la légende
      longline_map <- addLegend(longline_map, position = "bottomleft",
                                colors = list_couleur[1:27],
                                labels = info[1:27],
                                title = "Tutelles du PEPR B-BEST", opacity = 10) 
      longline_map <- addLegend(longline_map, position = "bottomright",
                                colors = list_couleur[28:54],
                                labels = info[28:54],
                                title = "Tutelles du PEPR B-BEST", opacity = 10)
      
      # Affichage de la carte
      longline_map
      
    }
    
  
  })

  
})