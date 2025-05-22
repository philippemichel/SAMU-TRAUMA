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
impf <- function(noo) {
  zz <- read_ods("datas/samutrauma.ods", sheet = noo, na = c("", "NA", "ND")) |>
    janitor::clean_names() |>
    mutate(across(where(is.character), as.factor))
}
# Destination finale
destf <- function(d1, d2) {
  dd <- d1
  ww <- which(!is.na(d2))
  dd[ww] <- d2[ww]
  return(dd)
}

#
regulation <- impf("regulation")
intervention <- impf("intervention")
destination <- impf("destination")
#
tt <- left_join(regulation, intervention)
tt <- left_join(tt, destination)
tt <- tt |>
  remove_constant() |>
  dplyr::filter(id != 110) |>
  dplyr::filter(id != 404) |>
  dplyr::filter(id != 458) |>
  mutate(horaire = hms(horaire)) |>
  mutate(intox = as.factor(ifelse((intox_oh == "Oui") | (intox_toxique == "Oui"), "Oui", "Non"))) |>
  relocate(intox, .after = demande_vsav) |>
  dplyr::select(-c(intox_oh, intox_toxique)) |>
  mutate(across(starts_with("niveau_"), ~ as.factor(.))) |>
  mutate(shock = ifelse(shock_index > 0.899, "Positif", "Négatif")) |>
  relocate(shock, .after = shock_index) |>
  mutate(across(starts_with("niveau_"), ~ fct_recode(., "Niveau 1" = "1", "Niveau 3" = "3"))) |>
  mutate(mgap_cut = cut(mgap,
    include.lowest = TRUE,
    right = FALSE,
    dig.lab = 4,
    breaks = c(0, 23, 30),
    labels = c("MGAP < 23", "MGAP 23 et +")
  )) |>
  relocate(mgap_cut, .after = mgap) |>
  ## Recodage de tt$triage en tt$triage_rec
  mutate(triage = fct_recode(triage,
    "Normo-triage" = "NORMO",
    "Sous-triage" = "SOUS",
    "Sur-triage" = "SUR"
  ))

c <- destf(tt$niveau_tc_1, tt$niveau_tc_2)
tt$nivfin <- c |>
  fct_recode(
    "Niveau 1" = "1",
    "Niveau 3" = "3"
  )
# bn
bn <- read_ods("datas/samutrauma.ods", sheet = "bnom")
var_label(tt) <- bn$nom
#
save(tt, bn, regulation, intervention, destination, file = "datas/samutraumas.RData")



# tt %>%
# report(output_file = "SAMU-TRAUMAS.html", output_dir = here::here())
