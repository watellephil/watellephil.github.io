#importer la base de données
install.packages("readr")
library(readr)
library(haven)

# Remplacer par le chemin exact où se trouve 'ttgintt4.rds'
setwd("C:/Users/Utilisateur/OneDrive/Documents/bureau de PO/Université Laval/Maitrise 1e année/Outils numériques/travail_final/données/Talis 2024/TALIS2024_teachers_NoESE_Rds")

#importer
talis_data_tout <- readRDS("ttgintt4.rds")

#Netoyage de la base de données
library(tidyverse)
# 2. Définir les codes cibles (France, Pays-Bas)
codes_cibles_finales <- c("FRA", "NLD")

# 3. Nettoyage, Filtrage et Étiquetage
talis_data_preparee <- talis_data_tout %>%
  
  # Sélectionner et renommer les colonnes d'intérêt
  select(
    CNTRY, # Colonne pays
    Distraction_Num = TT4G34D, # VI
    Relation_Eleve_Num = TT4G65A # VD
  ) %>%
  
  # Filtrer uniquement la France et les Pays-Bas
  filter(CNTRY %in% codes_cibles_finales) %>%
  
  mutate(
    # Définir l'étiquette de l'entité
    Entite_Graphique = case_when(
      CNTRY == "FRA" ~ "France",
      CNTRY == "NLD" ~ "Pays-Bas",
      TRUE ~ CNTRY 
    ),
    
    # Préparer les variables Likert (s'assurer qu'elles sont numériques et gérer les NA)
    Distraction = ifelse(Distraction_Num %in% 1:4, Distraction_Num, NA),
    Relation_Eleve = ifelse(Relation_Eleve_Num %in% 1:4, Relation_Eleve_Num, NA)
  ) %>%
  
  # Créer le facteur pour l'axe X (Distraction)
  mutate(
    Niveau_Distraction = factor(Distraction, 
                                levels = 1:4,
                                labels = c("F. Désaccord (1)", "Désaccord (2)", "Accord (3)", "F. Accord (4)"),
                                ordered = TRUE)
  ) %>%
  
  # Supprimer les lignes avec des valeurs manquantes pour l'analyse
  drop_na(Distraction, Relation_Eleve)

# 4. Agrégation des Données (Calcul des Moyennes)
donnees_agregees <- talis_data_preparee %>%
  
  # Grouper par l'entité et le niveau de distraction
  group_by(Entite_Graphique, Niveau_Distraction) %>%
  
  summarise(
    Moyenne_Relation = mean(Relation_Eleve, na.rm = TRUE),
    Erreur_Std = sd(Relation_Eleve, na.rm = TRUE) / sqrt(n()),
    n = n()
  ) %>%
  ungroup()

head(donnees_agregees)

#création du graphique
graphique_talis <- donnees_agregees %>%
  ggplot(aes(x = Niveau_Distraction, y = Moyenne_Relation, color = Entite_Graphique, group = Entite_Graphique)) +
  
  # Lignes et points pour visualiser la tendance
  geom_line(linewidth = 1) + 
  geom_point(size = 3) +
  
  # Titres et étiquettes
  labs(
    title = "Relation entre Distraction Numérique et Climat Social (TALIS)",
    subtitle = "Comparaison : France et Pays-Bas",
    x = "Niveau d'accord : 'Les outils numériques distraient les élèves'",
    y = "Score moyen de Qualité de la Relation (Échelle 1-4)",
    color = "Pays"
  ) +
  
  # Thème et personnalisation
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, face = "bold")
  ) +
  
  # Ajuster l'échelle Y pour une meilleure visualisation (entre 1 et 4)
  ylim(1.0, 4.1) 

print(graphique_talis)

#graphique amélioré 
graphique_ameliore <- donnees_agregees %>%
  ggplot(aes(x = Niveau_Distraction, y = Moyenne_Relation, color = Entite_Graphique, group = Entite_Graphique)) +
  
  # 1. Ajouter la ligne de neutralité (2.5 sur une échelle de 1 à 4)
  geom_hline(yintercept = 2.5, linetype = "dashed", color = "grey50") +
  
  # 2. Lignes et points
  geom_line(linewidth = 1.2) + 
  geom_point(size = 4) +
  
  # 3. Ajouter les étiquettes de données
  geom_text(aes(label = round(Moyenne_Relation, 2)), 
            vjust = -1.5, # Position au-dessus du point
            size = 3.5) +
  
  # 4. Palettes de couleurs personnalisées
  scale_color_manual(values = c("France" = "#E1000F", "Pays-Bas" = "#FF9900")) +
  
  # 5. Titres mis à jour pour guider l'interprétation
  labs(
    title = "Impact de la perception de la distraction numérique sur la qualité de la relation (TALIS 2024)",
    subtitle = "Score moyen de la relation Enseignant-Élève selon l'accord sur la distraction (France vs Pays-Bas)",
    x = "Perception de la Distraction Numérique (Niveau d'Accord)",
    y = "Qualité perçue de la Relation Enseignant-Élève (1=Mauvaise, 4=Excellente)",
    color = "Pays"
  ) +
  
  # 6. Thème amélioré
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, margin = margin(b = 10)),
    axis.title.y = element_text(margin = margin(r = 10))
  ) +
  
  ylim(1.0, 4.2) # Ajuster la limite supérieure pour laisser de la place aux étiquettes

print(graphique_ameliore)


# nuage de point sera mieux 
# Assurez-vous d'avoir bien exécuté les étapes de nettoyage précédentes, 
# créant la base de données 'talis_data_preparee' avec les variables 'Distraction' (numérique)
# et 'Relation_Eleve' (numérique) pour FRA et NLD.

graphique_nuage_points <- talis_data_preparee %>%
  ggplot(aes(x = Distraction, y = Relation_Eleve, color = Entite_Graphique)) +
  
  # 1. Ajouter les points (jitter pour disperser les points superposés)
  geom_jitter(alpha = 0.2, # Rendre les points semi-transparents pour visualiser la densité
              width = 0.15, # Étendre légèrement les points sur l'axe X
              height = 0.15) + # Étendre légèrement les points sur l'axe Y
  
  # 2. Ajouter la ligne de tendance de régression linéaire (method="lm")
  geom_smooth(method = "lm", 
              se = TRUE, # Afficher l'intervalle de confiance (zone grisée)
              linewidth = 1.5) +
  
  # 3. Définir les échelles (Likert 1 à 4)
  scale_x_continuous(breaks = 1:4, labels = c("1", "2", "3", "4")) +
  scale_y_continuous(breaks = 1:4, labels = c("1", "2", "3", "4")) +
  
  # 4. Palettes de couleurs
  scale_color_manual(values = c("France" = "#E1000F", "Pays-Bas" = "#FF9900")) +
  
  # 5. Titres et étiquettes
  labs(
    title = "Relation entre Distraction Numérique et Qualité de la Relation (Données Individuelles)",
    subtitle = "Ligne de tendance par pays : Effet de l'Accord sur la Distraction sur la Qualité de la Relation",
    x = "Perception de la Distraction Numérique (1=F. Désaccord, 4=F. Accord)",
    y = "Qualité perçue de la Relation Enseignant-Élève (1=Mauvaise, 4=Excellente)",
    color = "Pays"
  ) +
  
  # 6. Thème
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

print(graphique_nuage_points)


#graphique version 4
# --- 1. CHARGEMENT DES LIBRAIRIES ET IMPORTATION ---
library(tidyverse)
library(plotly)
# Installez si nécessaire : install.packages(c("tidyverse", "plotly", "htmlwidgets"))

# A. Importation de la base de données
# Assurez-vous que le fichier 'ttgintt4.rds' est dans votre répertoire de travail.
talis_data_tout <- readRDS("ttgintt4.rds")

# --- 2. NETTOYAGE ET PRÉPARATION DES DONNÉES ---

# Codes cibles confirmés : France (FRA) et Pays-Bas (NLD)
codes_cibles_finales <- c("FRA", "NLD")

# Définition des étiquettes descriptives pour les axes
labels_distraction <- c("Très faible (1)", "Faible (2)", "Élevé (3)", "Très élevé (4)")
labels_relation <- c("Très mauvaise (1)", "Mauvaise (2)", "Bonne (3)", "Très bonne (4)")

# Nettoyage, Filtrage et Préparation des variables
talis_data_preparee <- talis_data_tout %>%
  
  # Sélectionner et renommer les colonnes d'intérêt
  select(
    CNTRY, # Colonne pays
    Distraction_Num = TT4G34D, # VI
    Relation_Eleve_Num = TT4G65A # VD
  ) %>%
  
  # Filtrer uniquement la France et les Pays-Bas
  filter(CNTRY %in% codes_cibles_finales) %>%
  
  mutate(
    # Définir l'étiquette de l'entité
    Entite_Graphique = case_when(
      CNTRY == "FRA" ~ "France",
      CNTRY == "NLD" ~ "Pays-Bas",
      TRUE ~ CNTRY 
    ),
    
    # Préparer les variables Likert (s'assurer qu'elles sont numériques 1:4)
    Distraction = ifelse(Distraction_Num %in% 1:4, Distraction_Num, NA),
    Relation_Eleve = ifelse(Relation_Eleve_Num %in% 1:4, Relation_Eleve_Num, NA)
  ) %>%
  
  # Supprimer les lignes avec des valeurs manquantes pour l'analyse
  drop_na(Distraction, Relation_Eleve)


# --- 3. CRÉATION DU GRAPHIQUE INTERACTIF (Plotly) ---

# Création du graphique statique ggplot2
graphique_ggplot <- talis_data_preparee %>%
  ggplot(aes(x = Distraction, y = Relation_Eleve, color = Entite_Graphique, 
             # Définir le texte à afficher au survol (tooltip)
             text = paste("Pays: ", Entite_Graphique, 
                          "<br>Distraction (Score): ", Distraction, 
                          "<br>Relation (Score): ", Relation_Eleve))) +
  
  # 1. Ajouter les points (jitter pour disperser les points Likert)
  geom_jitter(alpha = 0.2, 
              width = 0.15, 
              height = 0.15, 
              size = 1.5) +
  
  # 2. Ajouter la ligne de tendance de régression linéaire
  geom_smooth(method = "lm", 
              se = FALSE, # Pas d'intervalle de confiance pour l'interactivité
              linewidth = 1.5) +
  
  # 3. Définir les échelles avec les étiquettes descriptives
  scale_x_continuous(breaks = 1:4, labels = labels_distraction) +
  scale_y_continuous(breaks = 1:4, labels = labels_relation) +
  
  # 4. Palettes de couleurs
  scale_color_manual(values = c("France" = "#E1000F", "Pays-Bas" = "#FF9900")) +
  
  # 5. Titres et étiquettes
  labs(
    title = "Relation entre Distraction Numérique et Qualité de la Relation (TALIS 2024)",
    x = "Perception de la Distraction Numérique",
    y = "Qualité perçue de la Relation Enseignant-Élève",
    color = "Pays"
  ) +
  
  # 6. Thème
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Transformation en graphique Plotly interactif
graphique_interactif <- ggplotly(graphique_ggplot, 
                                 tooltip = "text")

print(graphique_interactif)

#graphique 5 
# --- 3. CRÉATION DU GRAPHIQUE INTERACTIF AVEC LIGNES DE TENDANCE ET PENTES ---

library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# 1. Calculer les pentes et créer un dataframe pour les lignes de régression
trend_lines <- talis_data_preparee %>%
  group_by(Entite_Graphique) %>%
  summarise(
    lm_model = list(lm(Relation_Eleve ~ Distraction)),
    .groups = "drop"
  ) %>%
  rowwise() %>%
  mutate(
    slope = coef(lm_model)[2],
    label = paste0(Entite_Graphique, " (pente = ", round(slope, 2), ")"),
    x = list(seq(1, 4, length.out = 100)),  # intervalle Distraction
    y = list(predict(lm_model, newdata = data.frame(Distraction = x)))
  ) %>%
  unnest(cols = c(x, y))

# 2. Graphique ggplot
graphique_ggplot <- ggplot() +
  # Points jitter
  geom_jitter(data = talis_data_preparee,
              aes(x = Distraction, y = Relation_Eleve, color = Entite_Graphique,
                  text = paste("Pays: ", Entite_Graphique,
                               "<br>Distraction: ", Distraction,
                               "<br>Relation: ", Relation_Eleve)),
              alpha = 0.2, width = 0.15, height = 0.15, size = 1.5) +
  
  # Lignes de régression avec label incluant la pente
  geom_line(data = trend_lines,
            aes(x = x, y = y, color = Entite_Graphique, linetype = label,
                text = paste0(label)),
            size = 1.5) +
  
  # Échelles Likert
  scale_x_continuous(breaks = 1:4, labels = labels_distraction) +
  scale_y_continuous(breaks = 1:4, labels = labels_relation) +
  
  # Couleurs
  scale_color_manual(values = c("France" = "blue", "Pays-Bas" = "orange")) +
  
  # Lignes de régression avec légende
  scale_linetype_manual(values = c("France (pente = 0)" = "solid",
                                   "Pays-Bas (pente = 0)" = "solid")) +
  
  # Titres
  labs(
    title = "Relation entre Distraction Numérique et Qualité de la Relation (TALIS 2024)",
    x = "Perception de la Distraction Numérique",
    y = "Qualité perçue de la Relation Enseignant-Élève",
    color = "Pays",
    linetype = "Régression"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# 3. Conversion en interactif Plotly
graphique_interactif <- ggplotly(graphique_ggplot, tooltip = "text")
graphique_interactif
