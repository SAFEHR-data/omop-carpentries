get_concept_name <- function(id, cdm_obj) {
  cdm_obj$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    pull()
}
