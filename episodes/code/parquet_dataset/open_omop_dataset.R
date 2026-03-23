open_omop_dataset <- function(path) {
  # iterate over table level directories
  list.dirs(path, recursive = FALSE) |>
    # exclude folder name from path and use it as index for named list
    purrr::set_names(~ basename(.)) |>
    # "lazy-load" list of parquet files from specified folder
    purrr::map(arrow::open_dataset)
}
