library(here)
library(arrow)
library(dplyr)
library(lubridate)

original_files <- list.files(path=here("episodes/data/omop"), pattern = "*", full.names=TRUE)

#' Parse date and datetime columns to the correct data types and write as dataset
#' In case the data has been written as a parquet file, which converts these to strings
convert_dataset_column_types <- function(filepath) {
  print(glue::glue("Processing {filepath}"))
  open_dataset(filepath) |>
    mutate(
      across(ends_with("_date"), ~ lubridate::dmy(.x)),
      across(ends_with("_datetime"), ~ lubridate::dmy_hm(.x))
      ) |>
    write_dataset(path = filepath, format = "parquet", create_directory = FALSE)
}

purrr::walk(original_files, convert_dataset_column_types)
