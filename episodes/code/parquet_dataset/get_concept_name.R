get_concept_name <- function(omop_obj, id) {
  omop_obj$public$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    collect()
}
