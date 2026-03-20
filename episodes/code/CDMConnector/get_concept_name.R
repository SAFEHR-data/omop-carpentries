get_concept_name <- function(cdm_obj, id) {
  cdm_obj$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    pull()
}
