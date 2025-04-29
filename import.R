
#  ------------------------------------------------------------------------
#
# Title : Import SAMU-TRAUMAS
#    By : PhM
#  Date : 29/04/2025
#
#  ------------------------------------------------------------------------

rm(list = ls())
œ#
library(tidyverse)
library(labelled)
library(readODS)
library(baseph)
#
regulation <- read_ods("datas/samutraumas.ods", sheet = "regulation")
intervention <- read_ods("datas/samutraumas.ods", sheet = "intervention")
destination <- read_ods("datas/samutraumas.ods", sheet = "destination")
tt <- left_join(regulation,intervention)
tt <- left_join(tt,destination) |>
#
  janitor::clean_names() |>
  mutate(across(where(is.character), as.factor))
