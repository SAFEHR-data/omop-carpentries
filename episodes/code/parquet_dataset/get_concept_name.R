get_concept_name <- function(id) {

  library(arrow)
  library(dplyr)

  omop$public$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    collect()
}
