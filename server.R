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
    
    # ============= 1) CARTE 1 : TOUS LES PROJETS =============
    
    if (input$type_carte1 == "Tous les projets"){
      
      # ------------- LES CHOIX DE PROJETS ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      df_choice <- df[(df$Projet %in% input$projets_carte1),]
      
      # Liste des projets choisis
      projet_list_choisi <- unique(df_choice$Projet)
      projet_list_choisi <- projet_list_choisi[order(projet_list_choisi)]
      
      # Facteurs et couleurs associées à la carte
      info <- c("FORESTT-HUB","MONITOR","NUM-DATA","REGE-ADAPT","X-RISKS")
      list_couleur <- c("black","deeppink","blue","green","darkorange")
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 2) %>% 
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
                                title = "Projets du PEPR FORESTT", opacity = 10) 
      
      # Affichage de la carte
      longline_map
      
    }
    
    # ============= 2) CARTE 2 : 1 PROJET =============
    
    else if (input$type_carte1 == "1 projet"){
      
      
      # ------------- LES CHOIX DE PROJETS ET COULEURS -------------
      
      # On adapte la carte en fonction des projets selectionnés
      df_choice <- df
      
      # Liste des projets choisis
      #projet_list_choisi <- unique(df_choice$Projet)
      #projet_list_choisi <- projet_list_choisi[order(projet_list_choisi)]
      
      # Facteurs et couleurs associées à la carte
      info <- c("FORESTT-HUB","MONITOR","NUM-DATA","REGE-ADAPT","X-RISKS")
      list_couleur <- rep("lightgrey",5)
      idx_choisi <- which(info==input$projet_unique)
      list_couleur[idx_choisi] <- "black"
      
      # ------------- PREPARATION DE LA CARTE -------------
      
      # Initialisation de la carte
      longline_map <- leaflet(df_choice) %>% 
        setView(lng = mean(df_choice$Longitude), 
                lat = mean(df_choice$Latitude), 
                zoom = 2) %>% 
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
                                     color = "black",
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
    
    
  
  })

  
})