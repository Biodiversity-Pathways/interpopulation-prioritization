#-----------------------------------------------------------------------------------------------------------------------

# Attach packages
library(shiny)
library(shinyWidgets)
library(shinyjs)
library(leaflet)
library(leaflet.extras)
library(DT)
library(sf)
library(ggplot2)
library(forcats)
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(readxl)
library(janitor)

#-----------------------------------------------------------------------------------------------------------------------

# Functions

# Normalize criteria values
normalize.fun <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Change effect direction from positive to negative (and vice versa)
effect.fun <- function(x) {
  return (1 - x)
}

#-----------------------------------------------------------------------------------------------------------------------

# Load data

# Criteria values for each herd:
criteria <- read_excel("data/priority_ranking_matrix_inputs.xlsx", sheet = "Criteria") %>%
  clean_names()

# Weights
weights <- read_excel("data/priority_ranking_matrix_inputs.xlsx", sheet = "Weights") %>%
  clean_names()

# Herd polygons
herds <- st_read("data/spatial/SouthernMountain_210430.shp") %>%
  st_transform(4326) %>%
  mutate(herd = str_remove_all(HERD_NAME, " |-"),
         herd = ifelse(herd == "PurcellCentral", "PurcellsCentral", herd)) %>%
  filter(!herd == "GeorgeMountain") %>%
  select(herd)

# Wells Gray Park
# wg <- st_read(here("data/spatial/TA_PARK_ECORES_PA_SVW/TA_PEP_SVW_polygon.shp")) %>%
#  filter(PROT_NAME == "WELLS GRAY PARK")

#-----------------------------------------------------------------------------------------------------------------------

# Prepare data:

# Option A
criteria_prep <- criteria

criteria_prep[,c(2,4:5)]<-apply(criteria[,c(2,4:5)],2, normalize.fun)
criteria_prep[,c(9:36)]<-apply(criteria_prep[,c(9:36)],2,effect.fun)

# Option B
criteria_prep_norm <- criteria

criteria_prep_norm[,c(2,4:36)]<-apply(criteria[,c(2,4:36)],2,normalize.fun)
criteria_prep_norm[,c(9:36)]<-apply(criteria_prep_norm[,c(9:36)],2,effect.fun)

#-----------------------------------------------------------------------------------------------------------------------

