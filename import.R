
#  ------------------------------------------------------------------------
#
# Title : Import SAMU-TRAUMAS
#    By : PhM
#  Date : 29/04/2025
#
#  ------------------------------------------------------------------------

rm(list = ls())
#
library(tidyverse)
library(labelled)
library(janitor)
library(readODS)
library(baseph)
library(lubridate)
library(explore)
library(here)
#
impf <- function(noo){
  zz <- read_ods("datas/samutrauma.ods", sheet = noo, na = c("","NA","ND")) |>
                   janitor::clean_names() |>
                   mutate(across(where(is.character), as.factor))
                     }
#
regulation <- impf("regulation")
intervention <- impf("intervention")
destination <- impf("destination")
#
tt <- left_join(regulation,intervention)
tt <- left_join(tt,destination)
tt <- tt |>
  remove_constant() |>
  mutate(horaire = hms(horaire)) |>
  mutate(intox  = as.factor(ifelse((intox_oh == "Oui")|(intox_toxique == "Oui"), "Oui", "Non"))) |>
  relocate(intox, .after = demande_vsav) |>
  dplyr::select(-c(intox_oh, intox_toxique)) |>
  mutate(across(starts_with("niveau_"), ~ as.factor(.)))
#bn
bn  <- read_ods("datas/samutrauma.ods", sheet = "bnom")
var_label(tt) <- bn$nom
#
save(tt, bn,regulation,intervention,destination,  file = "datas/samutraumas.RData")



tt %>%
  report(output_file = "SAMU-TRAUMAS.html", output_dir = here::here())
