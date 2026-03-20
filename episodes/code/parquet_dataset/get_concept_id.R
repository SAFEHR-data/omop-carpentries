get_concept_id <- function(omop_obj, name) {
  omop_obj$concept |>
    filter(concept_name == !!name) |>
    select(concept_id) |>
    collect()
}
