open_database_connection <- function() {
  # Libraries
  library(CDMConnector)
  library(DBI)
  library(duckdb)
  library(dplyr)
  library(dbplyr)

  # Connect to GiBleed if not already connected
  if (!exists("cdm") || !inherits(cdm, "cdm_reference")) {
    db_name <- "GiBleed"
    CDMConnector::requireEunomia(datasetName = db_name)
    con <- DBI::dbConnect(duckdb::duckdb(),
                          dbdir = CDMConnector::eunomiaDir(datasetName = db_name))
    cdm <- CDMConnector::cdmFromCon(con, cdmSchema = "main", writeSchema = "main")
  }
}
