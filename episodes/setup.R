# data needed for carpentries

library(tidyverse)
library(omopcept)

#make some reduced omop tables

#note that all concept_ids need to be specified as integers to enable name joining

person <- tribble(
  ~person_id, ~year_of_birth, ~gender_concept_id, ~race_concept_id,
  1,          1980,           8532L,               46285833L,
  2,          1971,           8532L,               46286810L,
  3,          2000,           8507L,               46285836L,
  4,          2010,           8507L,               37394011L,
)

condition_occurrence <- tribble(
  ~person_id, ~condition_concept_id, ~condition_start_date, ~condition_occurrence_id,
  1,          45582716L,              2025-07-02,            1,
  1,          45539317L,              2025-01-21,            2,
  2,          45582716L,              2025-07-02,            3,
  2,          45548946L,              2025-01-21,            4,
  3,          45582716L,              2025-07-02,            5,
  4,          45539317L,              2025-07-02,            6,  
)


drug_exposure <- tribble(
  ~person_id, ~drug_concept_id, ~drug_exposure_start_date, ~drug_exposure_id,
  1,          44097290L,         2025-07-02,                1,
  1,          36408959L,         2025-07-02,                2,
  1,          36889718L,         2025-01-21,                3,
  2,          44097290L,         2025-07-02,                4,
  2,          36408959L,         2025-01-21,                5, 
  3,          44097290L,         2025-07-02,                6,  
)

# putting tables into a list
cdm_simple <- list(person = person,
                  condition_occurrence = condition_occurrence,
                  drug_exposure = drug_exposure)
