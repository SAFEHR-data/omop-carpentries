# Coerce OMOP *_date / *_datetime columns so collect() yields Date and POSIXct.
# Parquet may store these as UTF-8 strings (e.g. DD/MM/YYYY) or native Arrow
# date/timestamp types; open_dataset() alone does not parse string dates.
coerce_omop_arrow_temporal <- function(table_path) {
  ds <- arrow::open_dataset(table_path)
  sch <- ds$schema
  date_cols <- sch$names[endsWith(sch$names, "_date")]
  dt_cols <- sch$names[endsWith(sch$names, "_datetime")]
  dots <- list()
  for (nm in date_cols) {
    typ <- sch$GetFieldByName(nm)$type
    if (inherits(typ, "Utf8")) {
      dots[[nm]] <- bquote(cast(strptime(.(as.name(nm)), format = "%d/%m/%Y", unit = "s"), .(arrow::date32())))
    } else {
      dots[[nm]] <- bquote(cast(.(as.name(nm)), .(arrow::date32())))
    }
  }
  for (nm in dt_cols) {
    typ <- sch$GetFieldByName(nm)$type
    if (inherits(typ, "Utf8")) {
      dots[[nm]] <- bquote(cast(strptime(.(as.name(nm)), format = "%d/%m/%Y %H:%M", unit = "s"), .(arrow::timestamp(unit = "s", timezone = "UTC"))))
    } else {
      dots[[nm]] <- bquote(cast(.(as.name(nm)), .(arrow::timestamp(unit = "s", timezone = "UTC"))))
    }
  }
  if (length(dots)) {
    ds <- do.call(function(...) dplyr::mutate(...), c(list(.data = ds), dots))
  }
  ds
}

open_omop_dataset <- function(path) {
  # iterate over table level directories
  list.dirs(path, recursive = FALSE) |>
    # exclude folder name from path and use it as index for named list
    purrr::set_names(~ basename(.)) |>
    # lazy Datasets: temporal columns typed for correct R classes on collect()
    purrr::map(coerce_omop_arrow_temporal)
}
