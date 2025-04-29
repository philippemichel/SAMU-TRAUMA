
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
library(readODS)
library(baseph)
#
impf <- function(noo){
  zz <- read_ods(read_ods("datas/samutraumas.ods", sheet = noo) |>
                   janitor::clean_names() |>
                   mutate(across(where(is.character), as.factor))
                     }
#
regulation <- impf("regulation")
intervention <- impf("intervention")
destination <- impf("destination")
#
tt <- left_join(regulation,intervention)
tt <- left_join(tt,destination) |>
#
