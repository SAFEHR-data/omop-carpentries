get_concept_id <- function(name, omop_obj) {

  library(arrow)
  library(dplyr)

  omop_obj$public$concept |>
    filter(concept_name == !!name) |>
    select(concept_id) |>
    collect()
}
