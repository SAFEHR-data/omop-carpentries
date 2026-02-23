get_concept_name <- function(id, omop_obj) {

  library(arrow)
  library(dplyr)

  omop_obj$public$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    collect()
}
