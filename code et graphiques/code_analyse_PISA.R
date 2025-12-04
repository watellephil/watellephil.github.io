#1. Chargment des données

# --- Installation des packages ---
library(haven)
library(intsvy)
library(dplyr)

# --- Configuration ---
# Définir les chemins d'accès aux fichiers
chemin_eleve_sas <- "C:/Users/Utilisateur/OneDrive/Documents/bureau de PO/Université Laval/Maitrise 1e année/Outils numériques/travail_final/données/PISA 2022/STU_QQQ_SAS/CY08MSP_STU_QQQ.SAS7BDAT"

# importer la base de donnée
pisa_data <- read_sas(chemin_eleve_sas)

#(Facultatif mais recommandé) Vérifier les dimensions et les premières lignes
dim(pisa_data)
head(pisa_data)

#Début du filtrage de la base de donnée pour avoir juste les pays qu'on veut
# Assurez-vous que dplyr est chargé
library(dplyr)

# --- Codes Confirmés et Variables à Utiliser ---
# Codes provinciaux confirmés par la variable REGION
CODE_QUEBEC  <- 12405
CODE_ONTARIO <- 12406

# Codes des pays nationaux
PAYS_NATIONAUX <- c("FRA", "NLD") 

# --- Création de la Base de Données data_clean ---

# 'pisa_data' est votre base de données SAS chargée
data_clean <- pisa_data %>%
  # Nous n'avons plus besoin de muter la variable REGION car elle est déjà numérique (<dbl>)
  filter(
    # Condition 1 : Est un pays national (France ou Pays-Bas)
    CNT %in% PAYS_NATIONAUX |
      
      # Condition 2 : Est le Canada ET la région est spécifiquement le Québec ou l'Ontario
      (CNT == "CAN" & REGION %in% c(CODE_QUEBEC, CODE_ONTARIO))
  )

# --- Vérification Finale du Filtrage ---

cat("\n✅ Succès : Répartition des élèves dans data_clean (4 lignes attendues) : \n")
data_clean %>%
  # Regroupement par CNT et REGION pour confirmer les 4 groupes
  group_by(CNT, REGION) %>%
  summarise(N_Eleves = n(), .groups = 'drop') %>%
  print()

#création de variable pour les régions
# 1. Créer la variable Region_ID
data_clean <- data_clean %>%
  mutate(
    Region_ID = case_when(
      # Provinces canadiennes
      CNT == "CAN" & REGION == CODE_QUEBEC ~ "Quebec",
      CNT == "CAN" & REGION == CODE_ONTARIO ~ "Ontario",
      # Pays nationaux
      CNT == "FRA" ~ "France",
      CNT == "NLD" ~ "Pays_Bas",
      TRUE ~ "Autre" # Pour les cas imprévus (devrait être 0 ici)
    )
  )

# 2. Vérification rapide
data_clean %>% group_by(Region_ID) %>% summarise(N=n())



# Préparation de la variable de distraction
data_clean <- data_clean %>%
  mutate(
    # 1. Convertir la variable brute en facteur ordonné
    Distraction_Factor = as.factor(as.numeric(ST273Q06JA)),
    
    # 2. Renommer les niveaux pour une interprétation facile des résultats
    Distraction_Factor = recode_factor(
      Distraction_Factor,
      "1" = "Jamais/Presque",
      "2" = "Quelques_Cours",
      "3" = "La_Plupart_Cours",
      "4" = "Chaque_Cours",
      .default = "Manquant/Invalide" # Gérer les valeurs non définies
    )
  )

# --- Vérification de l'existence ---
cat("\nVérification rapide de la nouvelle variable (doit afficher 4 lignes) : \n")
data_clean %>%
  group_by(Distraction_Factor) %>%
  summarise(N = n(), .groups = 'drop') %>%
  print()

# Vérification des noms de colonnes (doit inclure Distraction_Factor)
names(data_clean)



#Créeun des variables pour les résultats en mathématique
# Assurez-vous que le package intsvy est chargé
library(intsvy)

# 1. Créer la liste des noms des 10 PVs
#    Ceci crée une liste de chaînes de caractères : "PV1MATH", "PV2MATH", ...
pv_math_noms <- paste0("PV", 1:10, "MATH")

# Assurez-vous d'avoir bien chargé le package dplyr
library(dplyr)

# --- 1. Définir le Poids Final de l'Élève (Final Student Weight) ---
# Variable unique pour la pondération générale
# Le nom dans la base de données PISA est 'W_FSTUWT'
poids_final <- "W_FSTUWT"

# --- 2. Définir les 80 Poids de Réplication (Replicate Weights) ---
# Ces poids sont nommés W_FSTR1, W_FSTR2, ..., jusqu'à W_FSTR80
# La fonction 'paste0' permet de générer rapidement cette liste de 80 noms.
poids_replication <- paste0("W_FSTR", 1:80)

# --- Vérification (Optionnel) ---
cat("Poids final défini : ", poids_final, "\n")
cat("Nombre de poids de réplication générés : ", length(poids_replication), "\n")
cat("Premiers poids de réplication : ", head(poids_replication, 3), "...\n")


# --- La Régression Finale (Réutilisant pisa.reg.pv) ---

cat("\n🚀 Exécution de la Régression Comparative Finale avec pisa.reg.pv : \n")

# NOTE: La fonction pisa.reg.pv lit les colonnes PV*MATH, W_FSTUWT et W_FSTR*
#       automatiquement si elles existent dans la base de données. 

regression_comparative_finale <- pisa.reg.pv(
  pvlabel = pv_math_noms,              
  x = "Distraction_Factor",      
  by = "Region_ID",              # Analyse séparée par Québec, Ontario, France, Pays-Bas
  data = data_clean
)

# Afficher les résultats
print(regression_comparative_finale)



# Faire un beau tableau 
# Les packages
library(dplyr)
library(modelsummary) 
library(purrr)        
library(gt)
library(ggplot2)
library(dplyr)
library(patchwork) # Ce package est essentiel pour combiner les deux graphiques côte à côte

# 🚨 IMPORTANT : Assurez-vous que la variable 'table_finale' est déjà créée !

### 1. PRÉPARATION DES DONNÉES

# 1A. Données pour l'Intercept (Score prédit du groupe de référence)
df_intercept <- table_finale %>%
  filter(Variable == "(Intercept)") %>%
  mutate(
    # Calcul des bornes de l'Intervalle de Confiance à 95%
    IC_min = Estimate - 1.96 * `Std. Error`,
    IC_max = Estimate + 1.96 * `Std. Error`,
    Variable_label = "Score de Référence" # Étiquette claire pour l'Intercept
  )

# 1B. Données pour les Coefficients d'impact (Changement de score)
df_impact <- table_finale %>%
  filter(
    !Variable %in% c("(Intercept)", "R-squared")
  ) %>%
  mutate(
    # Calcul des bornes de l'Intervalle de Confiance à 95%
    IC_min = Estimate - 1.96 * `Std. Error`,
    IC_max = Estimate + 1.96 * `Std. Error`,
    # Simplification des étiquettes des variables pour l'axe Y
    Variable_label = case_when(
      Variable == "Distraction_FactorQuelques_Cours" ~ "Quelques cours",
      Variable == "Distraction_FactorLa_Plupart_Cours" ~ "La plupart des cours",
      Variable == "Distraction_FactorChaque_Cours" ~ "Chaque cours",
      TRUE ~ Variable
    )
  )


### 2. CRÉATION DES DEUX GRAPHIQUES (Forest Plots)

# Graphique A : Intercept (Valeur absolue du score en math)
plot_intercept <- ggplot(df_intercept, aes(x = Estimate, y = Variable_label, color = Pays)) +
  
  # Barres et Points pour l'Intercept
  geom_errorbarh(aes(xmin = IC_min, xmax = IC_max), height = 0.2) +
  geom_point(size = 3) +
  
  # Configuration visuelle
  facet_wrap(~ Pays, scales = "free_x") +
  labs(
    title = "A. Score Prédit du Groupe de Référence",
    subtitle = "Groupe : Aucune/Très faible distraction",
    x = "Score Prédit en Mathématiques",
    y = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "none", plot.title = element_text(face = "bold"))

# Graphique B : Coefficients d'impact (Changement de score)
plot_impact <- ggplot(df_impact, aes(x = Estimate, y = Variable_label, color = Pays)) +
  
  # Ligne de référence "pas d'effet" à 0
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  
  # Barres et Points pour les Coefficients
  geom_errorbarh(
    aes(xmin = IC_min, xmax = IC_max),
    height = 0.2,
    position = position_dodge(width = 0.8)
  ) +
  geom_point(position = position_dodge(width = 0.8), size = 3) +
  
  # Configuration visuelle
  facet_wrap(~ Pays, scales = "free_x") +
  labs(
    title = "B. Impact des Niveaux de Distraction (Coefficients)",
    subtitle = "Changement de score relatif au groupe de référence",
    x = "Coefficient de Régression (Points de Score en Math)",
    y = "Fréquence de Distraction perçue"
  ) +
  theme_minimal() +
  theme(legend.position = "none", plot.title = element_text(face = "bold"))


### 3. AFFICHAGE COMBINÉ

# Combinez les deux graphiques côte à côte et ajoutez un titre global
combined_plot <- plot_intercept + plot_impact + 
  plot_layout(widths = c(1, 1)) +
  plot_annotation(
    title = 'Analyse de la Distraction et des Résultats en Mathématiques par Région'
  )

# Affichez l'objet graphique dans R pour forcer l'affichage
combined_plot
