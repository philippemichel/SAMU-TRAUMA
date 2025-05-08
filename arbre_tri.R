tt %>%
  # suppression de la variable heart_severity qui explique à elle seule la pathologie dans ce jeud e données
  select(-c(id, horaire, smur, destination_1,destination_2, niveau_tc_2, niveau_tc_1)) %>%
  explain_tree(target = triage)
0
