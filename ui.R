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
  
  navbarPage("PEPR B-BEST - Cartes", 
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
                                                                 "1 projet" = "1 projet",
                                                                 "Toutes les tutelles" = "Toutes les tutelles",
                                                                 "1 tutelle" = "1 tutelle"
                                                  ),
                                                  selected = "Tous les projets"
                                                )),
                                              wellPanel(
                                                conditionalPanel(
                                                  condition = "input.type_carte1 == 'Tous les projets'",
                                                  checkboxGroupInput(
                                                    "projets_carte1",
                                                    "Selectionnez les projets",
                                                    choices = list("Algadvance" = projet_list[1],
                                                                   "Amaretto" = projet_list[2],
                                                                   "Applestorm" = projet_list[3], 
                                                                   "BioFUMAC" = projet_list[4],
                                                                   "BioMCat" = projet_list[5],
                                                                   "Collimator" = projet_list[6],
                                                                   "COPE" = projet_list[7],
                                                                   "ElectroMIC" = projet_list[8],
                                                                   "FillingGaps" = projet_list[9],
                                                                   "FLAVOLASES" = projet_list[10],
                                                                   "Furfun" = projet_list[11],
                                                                   "GalaxyBioProd" = projet_list[12],
                                                                   "MALIGNE" = projet_list[13],
                                                                   "Mamabio" = projet_list[14],
                                                                   "Micro-Mass" = projet_list[15],
                                                                   "MuSiHC" = projet_list[16],
                                                                   "Nanomachines" = projet_list[17],
                                                                   "Optisfuel" = projet_list[18],
                                                                   "PREMIERE LIGNE" = projet_list[19],
                                                                   "PRODIGES" = projet_list[20],
                                                                   "PuLCO" = projet_list[21],
                                                                   "ROSALIND" = projet_list[22],
                                                                   "SmartCoupling" = projet_list[23],
                                                                   "Tbox4BioProd" = projet_list[24],
                                                                   "WAEster" = projet_list[25],
                                                                   "Wallmat"= projet_list[26]
                                                    ),
                                                    selected = projet_list[1:26]
                                                  )
                                                ),
                                                conditionalPanel(
                                                  condition = "input.type_carte1 == '1 projet'",
                                                selectInput("projet_unique",
                                                               "Selectionnez un projet", 
                                                               choices = projet_list
                                                )
                                              ),
                                              conditionalPanel(
                                                condition = "input.type_carte1 == 'Toutes les tutelles'",
                                                checkboxGroupInput(
                                                  "tutelles_carte1",
                                                  "Selectionnez les tutelles",
                                                  choices = list(
                                                                 "AGROPARISTECH" = tutelle_list[1],
                                                                 "AIX-MARSEILLE" = tutelle_list[2],
                                                                 "AMIENS" = tutelle_list[3],
                                                                 "BORDEAUX" = tutelle_list[4],
                                                                 "Bordeaux INP" = tutelle_list[5],
                                                                 "CAEN" = tutelle_list[6],
                                                                 "CEA" = tutelle_list[7],
                                                                 "CENTRALESUPELEC" = tutelle_list[8],
                                                                 "CIHEAM" = tutelle_list[9],
                                                                 "CIRAD" = tutelle_list[10],
                                                                 "CNRS" = tutelle_list[11],
                                                                 "CPE LYON" = tutelle_list[12],
                                                                 "E.N.VET.TLSE" = tutelle_list[13],
                                                                 "EC. CENTRALE MARSEILLE" = tutelle_list[14],
                                                                 "EC. POLYTECHNIQUE" = tutelle_list[15],
                                                                 "ENPC PARIS" = tutelle_list[16],
                                                                 "ENS CHIM. LILLE" = tutelle_list[17],
                                                                 "ENS LYON" = tutelle_list[18],
                                                                 "ENSI CAEN" = tutelle_list[19],
                                                                 "ESPCI PARIS" = tutelle_list[20],
                                                                 "EVRY" = tutelle_list[21],
                                                                 "GRENOBLE ALPES" = tutelle_list[22],
                                                                 "GRENOBLE INP" = tutelle_list[23],
                                                                 "IFPEN" = tutelle_list[24],
                                                                 "IMT Atlantique" = tutelle_list[25],
                                                                 "IMT MINES ALES"= tutelle_list[26],
                                                                 "INP TOULOUSE" = tutelle_list[27],
                                                                 "INRAE" = tutelle_list[28],
                                                                 "INRIA" = tutelle_list[29], 
                                                                 "INS.CURIE" = tutelle_list[30],
                                                                 "INSA Toulouse" = tutelle_list[31],
                                                                 "INSERM" = tutelle_list[32],
                                                                 "Institut Agro" = tutelle_list[33],
                                                                 "IP PARIS" = tutelle_list[34],
                                                                 "IRD" = tutelle_list[35],
                                                                 "JUNIA" = tutelle_list[36],
                                                                 "LILLE" = tutelle_list[37],
                                                                 "LORRAINE" = tutelle_list[38],
                                                                 "LYON 1" = tutelle_list[39],
                                                                 "MinesTélécom" = tutelle_list[40],
                                                                 "MONTPELLIER" = tutelle_list[41],
                                                                 "Nantes Université" = tutelle_list[42],
                                                                 "ONIRIS NANTES ATLANTIQUE" = tutelle_list[43],
                                                                 "PSL" = tutelle_list[44],
                                                                 "REIMS" = tutelle_list[45],
                                                                 "SORBONNE UNIV." = tutelle_list[46],
                                                                 "TOULON" = tutelle_list[47],
                                                                 "TOULOUSE 3" = tutelle_list[48],
                                                                 "U PARIS-SACLAY" = tutelle_list[49],
                                                                 "U. STRASBOURG" = tutelle_list[50],
                                                                 "UniCA" = tutelle_list[51],
                                                                 "Université de Toronto" = tutelle_list[52],
                                                                 "UP" = tutelle_list[53],
                                                                 "VETAGRO SUP" = tutelle_list[54]
                                                  ),
                                                  selected = tutelle_list[1:54]
                                                )
                                              ),
                                              conditionalPanel(
                                                condition = "input.type_carte1 == '1 tutelle'",
                                                selectInput("tutelle_unique",
                                                            "Selectionnez une tutelle", 
                                                            choices = tutelle_list
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
                   <span style="font-size:12px;">PEPR Bioproductions - </span>
                     <img style="vertical-align:middle;height:25px;" src="images/FR2030 - Carburants durables_FR2030_Carburants durables_Couleur.png"/>
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