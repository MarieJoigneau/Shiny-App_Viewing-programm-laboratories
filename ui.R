# Auteur : Marie JOIGNEAU (INRAE)

# TITRE : Visualisation des emplacements des unités de recherche (map1) et des 
# lieux où les projets de FairCarboN opèrent (map2) dans le monde entier



fluidPage(
  # shinythemes::themeSelector(),
  # navbarPage
  
  
  ############ ---- AJUSTEMENT DES CARTES  --------------------
  
  # Scrit JavaScript pour ajuster la taille des 2 cartes en fonction de la fenêtre de l'utilisateur
  # - $(document).ready() assure que le script JavaScript est exécuté une fois que le document HTML est complètement chargé.
  # - $(window).resize() déclenche la fonction adjustMapHeight() chaque fois que la fenêtre est redimensionnée.
  # - adjustMapHeight() calcule la hauteur de la carte en fonction de la hauteur de la fenêtre du navigateur et ajuste la hauteur de l'élément ayant l'ID "carte1" en conséquence.
  tags$head(
    tags$script('
      $(document).ready(function(){
        function adjustMapHeight() {
          var windowHeight = $(window).height();
          $("#carte1").height(windowHeight * 0.8);
          $("#carte2").height(windowHeight * 0.8);
        }
        adjustMapHeight();
        $(window).resize(adjustMapHeight);
      });
    ')
  ),
  
  navbarPage("PEPR FORESTT - Cartes", 
             theme = shinytheme("flatly"),
             
             ############ ---- ONGLET 1 : Lieux d’étude des différents projets du PEPR FairCarboN --------------------
             
             tabPanel("Localisation des unités",
                      
                      verticalLayout(fluid=TRUE,
                                     fluidRow(
                                       
                                       column(width = 3,
                                              wellPanel(
                                                radioButtons(
                                                  "type_carte1",
                                                  "Selectionnez le type de carte",
                                                  choices = list("Tous les projets" = "Tous les projets",
                                                                 "1 projet" = "1 projet"
                                                  ),
                                                  selected = "Tous les projets"
                                                )),
                                              wellPanel(
                                                conditionalPanel(
                                                  condition = "input.type_carte1 == 'Tous les projets'",
                                                  checkboxGroupInput(
                                                    "projets_carte1",
                                                    "Selectionnez les projets",
                                                    choices = list("FORESTT-HUB" = projet_list[1],
                                                                   "MONITOR" = projet_list[2],
                                                                   "NUM-DATA" = projet_list[3], 
                                                                   "REGE-ADAPT" = projet_list[4],
                                                                   "X-RISKS" = projet_list[5]
                                                    ),
                                                    selected = projet_list[1:5]
                                                  )
                                                ),
                                                conditionalPanel(
                                                  condition = "input.type_carte1 == '1 projet'",
                                                selectInput("projet_unique",
                                                               "Selectionnez un projet", 
                                                               choices = projet_list
                                                )
                                              )
                                       )),
                                       column(width = 9,
                                              leafletOutput("carte1")
                                              )
                                       )

                      )),

      
             ############ ---- SIGNATURE US PEPR  --------------------
             
             # On met la signature ainsi que la mention de SK8
             
             tags$footer(
               style = "
               position: fixed;
               left: 0;
               bottom: 0;
               width: 100%;
               z-index: 1000;
               height: 30px; /* Height of the footer */
               color: black;
               padding: 10px;
               font-weight: bold;
               background-color: white;
               display: flex; /* Utilisation de flexbox */
               justify-content: space-between; /* Espace égal entre les éléments */
               align-items: center; /* Centrage vertical */
               ",
               column(
                 width = 5, 
                 HTML('
                 <div class="footer" style="text-align:left;">
                   <span style="font-size:12px;">PEPR FORESTT - </span>
                     <img style="vertical-align:middle;height:25px;" src="images/FR2030_Résilience des forets_Couleur_petit.png"/>
                 </div>'
                 )
                 # style = "text-align: left;", # Alignement du texte à gauche
                 # "US 1502 - Cellule d’appui pour les PEPR"
               ),
               column(
                 width = 7,
                 HTML('
                 <div class="footer" style="text-align:right;">
                   <span style="font-size:12px;">Propulsé par <a href="https://sk8.inrae.fr" target="_blank">SK8</a> depuis 2021 - </span>
                   <a href="https://sk8.inrae.fr" target="_blank">
                     <img style="vertical-align:middle;height:25px;" src="images/SK8.png"/>
                   </a>
                 </div>'
                 )
               )
             )

             
  )
)