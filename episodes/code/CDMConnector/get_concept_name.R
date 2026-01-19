get_concept_name <- function(id) {
  cdm$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    pull()
}
