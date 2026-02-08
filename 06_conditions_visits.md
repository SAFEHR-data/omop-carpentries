---
title: "Conditions and Visits"
teaching: 0
exercises: 0
---

#```{r setup, include = FALSE}
#source("setup.R")
#knitr::opts_chunk$set(fig.height = 6)
#```

:::::::::::::::::::::::::::::::::::::: questions 

- What are conditions in the OMOP CDM?

- When do we need to consider visits in our analysis?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the structure and purpose of the conditions table in the OMOP CDM.

- Know their visits are recorded in the visit_occurrence table.

- Learn when and how to consider visits in data analysis.

- Know that a visit is a period of time and patients can have multiple visits

- Understand that multiple measurements, conditions etc. can occur within a visit.

- Understand that other tables link to visits

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

This episode covers the OMOP conditions and visits table.

:::::::::::::::::::::::::::::::::::::::::::::::: callout

For this episode we will be using a sample OMOP CDM database that is pre-loaded with data. This database is a simplified version of a real-world OMOP CDM database and is intended for educational purposes only.

(UCLH only) This will come in the same form as you would get data if you asked for a data extract via the SAFEHR platform (i.e. a set of parquet files).

As part of the setup prior to this course you were asked to download and install the sample database. If you have not done this yet, please refer to the setup instructions provided earlier in the course. For now, we will assume that you have the sample OMOP CDM database available on your local machine at the following path: `workshop/data/public/` and the functions in a folder `workshop/code`.

You will then need to load the database as shown in the previous episode.


``` r
open_omop_dataset <- function(dir) {
  open_omop_schema <- function(path) {
    # iterate table level folders
    list.dirs(path, recursive = FALSE) |>
      # exclude folder name from path
      # and use it as index for named list
      purrr::set_names(~ basename(.)) |>
      # "lazy-open" list of parquet files
      # from specified folder
      purrr::map(arrow::open_dataset)
  }
  # iterate top-level folders
  list.dirs(dir, recursive = FALSE) |>
    # exclude folder name from path
    # and use it as index for named list
    purrr::set_names(~ basename(.)) |>
    purrr::map(open_omop_schema)
}
```


``` r
omop <- open_omop_dataset("./data/")
```

and the useful functions we created in the previous episode to look up concept names/ids.


``` r
library(arrow)
library(dplyr)
get_concept_name <- function(id) {
  omop$public$concept |>
    filter(concept_id == !!id) |>
    select(concept_name) |>
    collect()
}
```


``` r
get_concept_id <- function(name) {
  omop$public$concept |>
    filter(concept_name == !!name) |>
    select(concept_id) |>
    collect()
}
```

::::::::::::::::::::::::::::::::::::::::::::::::


## Conditions


[Conditions](https://ohdsi.github.io/CommonDataModel/cdm54.html#conditions) are a key part of the OMOP CDM. They represent diagnoses that have been made for patients. Conditions are stored in the `condition_occurrence` table. Each record in this table represents a single occurrence of a condition for a patient. The table contains records of diseases, medical conditions, diagnoses, signs, or symptoms observed by providers or reported by patients. Conditions are mapped from diagnostic codes and represented using standardized concepts in a hierarchical structure. 

::::::::::::::::::::::::::::::::::::: challenge

1. How many records are there in the `condition_occurrence` table?

2. List any of the conditions that occur more than once in the table along with their humanly readable names.

3. Choose one patient and list all the conditions they have? 

::::::::::::::::::::::::::::::::::::: solution
1. How many records are there in the `condition_occurrence` table?

``` r
omop$public$condition_occurrence |>
  collect() |>
  count()
```

``` output
# A tibble: 1 × 1
      n
  <int>
1    35
```

2. List any of the conditions that occur more than once in the table along with their humanly readable names.

``` r
omop$public$condition_occurrence |>
  group_by(condition_concept_id) |>
  summarise(occurrences = n()) |>
  filter(occurrences > 1) |>
  left_join(
    omop$public$concept,
    by = c("condition_concept_id" = "concept_id")
  ) |>
  select(concept_name, occurrences) |>
  collect()
```

``` output
# A tibble: 4 × 2
  concept_name                             occurrences
  <chr>                                          <int>
1 Injury of head                                     2
2 Inflammatory disorder of digestive tract           2
3 Gastritis                                          2
4 Hemorrhoids                                        2
```
3. Choose one patient and list all the conditions they have?

``` r
patient_id <- 1111  # Replace with the desired person_id 
omop$public$condition_occurrence |>
  filter(person_id == !!patient_id) |>
  left_join(
    omop$public$concept,
    by = c("condition_concept_id" = "concept_id")
  ) |>
  select(condition_concept_id, concept_name, condition_start_date) |>
  collect()
```

``` output
# A tibble: 1 × 3
  condition_concept_id concept_name                         condition_start_date
                 <int> <chr>                                <chr>               
1              4230399 Closed fracture of lateral malleolus 22/07/2025          
```
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

Question three can be repeated for different patients by changing the `patient_id` variable. Interestingly if you choose patient **31** you will see that the entry for their condition and start date is repeated. Investigate the table further to see why this might be the case. (Hint: look at the `condition_type_concept_id`, `conditions_status_concept_id` and `condition_source_value` columns).

::::::::::::::::::::::::::::::::::::: challenge

Investigate why patient 31 has repeated entries for their condition and start date in the `condition_occurrence` table. Look at the `condition_type_concept_id`, `conditions_status_concept_id`, and `condition_source_value` columns to understand the differences between these entries.

::::::::::::::::::::::::::::::::::::: solution

``` r
patient_id <- 31  # Replace with the desired person_id
omop$public$condition_occurrence |>
  filter(person_id == !!patient_id) |>
  left_join(
    omop$public$concept,
    by = c("condition_concept_id" = "concept_id")
  ) |>
  rename(condition_concept_name = concept_name) |>
  relocate(condition_concept_name, .after = condition_concept_id) |>
  left_join(
    omop$public$concept,
    by = c("condition_type_concept_id" = "concept_id")
  ) |>
  rename(condition_type_concept_name = concept_name) |>
  relocate(condition_type_concept_name, .after = condition_type_concept_id) |>
  left_join(
    omop$public$concept,
    by = c("condition_status_concept_id" = "concept_id")
  ) |>
  rename(condition_status_concept_name = concept_name) |>  
  relocate(condition_status_concept_name, .after = condition_status_concept_id) |>
  select(condition_concept_id, condition_concept_name, condition_start_date, condition_type_concept_id, condition_type_concept_name, condition_status_concept_id, condition_status_concept_name , condition_source_value) |>
  collect()
```

``` output
# A tibble: 2 × 8
  condition_concept_id condition_concept_name condition_start_date
                 <int> <chr>                  <chr>               
1               375415 Injury of head         10/05/2019          
2               375415 Injury of head         10/05/2019          
# ℹ 5 more variables: condition_type_concept_id <int>,
#   condition_type_concept_name <chr>, condition_status_concept_id <int>,
#   condition_status_concept_name <chr>, condition_source_value <chr>
```

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

As you can see from the output, although the `condition_concept_id` and `condition_start_date` are the same for patient **31**, the `condition_type_concept_id` and `condition_status_concept_id` differ between the entries. This indicates that the same condition was recorded in different contexts or with different statuses, which explains the repeated entries in the `condition_occurrence` table. This is commonly found in hospital records!

## Visits

The `visit_occurrence` table contains [events where Persons engage with the healthcare system for a duration of time](https://ohdsi.github.io/CommonDataModel/cdm54.html#visit_occurrence).


The main clinical tables `condition_occurrence`, `measurement`, `observation` and `drug_exposure` contain a `visit_occurrence_id` that links to this table.


`visit_concept_id` specifies the kind of visit that took place using standardised OMOP concepts. These include `Inpatient visit`, `Emergency Room Visit` and `Outpatient Visit`. Inpatient visits can last for longer than one day.    

As we have seen we don't need to consider visits to answer all questions. For example if we can count the number of patients with a particular condition without considering visits. However, in some cases visits are important. For example, if we want to know how many emergency room visits resulted in a hospital admission we need to consider visits.

::::::::::::::::::::::::::::::::::::: challenge

1. Find out how many different types of visits are recorded in the `visit_occurrence` table and link these to get their name.

2. Find patients who had more than one visit.

3. How many patients had both an emergency room visit and an inpatient visit?

::::::::::::::::::::::::::::::::::::: solution
1. Find out how many different types of visits are recorded in the `visit_occurrence` table and link these to get their name.

``` r
omop$public$visit_occurrence |>
  count(visit_concept_id) |>
  left_join(
    omop$public$concept,
    by = c("visit_concept_id" = "concept_id")
  ) |>
  select(visit_concept_id, concept_name, n) |>
  collect() |>
  arrange(desc(n))
```

``` output
# A tibble: 4 × 3
  visit_concept_id concept_name                           n
             <int> <chr>                              <int>
1             9203 Emergency Room Visit                   8
2             9201 Inpatient Visit                        7
3             9202 Outpatient Visit                       4
4              262 Emergency Room and Inpatient Visit     1
```
2. Find patients who had more than one visit.

``` r
omop$public$visit_occurrence |>
  group_by(person_id) |>
  summarise(visit_count = n()) |>
  filter(visit_count > 1) |>
  collect()
```

``` output
# A tibble: 4 × 2
  person_id visit_count
      <int>       <int>
1      1112           2
2        31           2
3         2           2
4        58          10
```
3. How many patients had both an emergency room visit and an inpatient visit?

``` r
patients_with_both_visits <- omop$public$visit_occurrence |>
  filter(visit_concept_id %in% c(9203, 9201, 262)) |>
  group_by(person_id) |>
  summarise(visit_types = n_distinct(visit_concept_id)) |>
  collect()
nrow(patients_with_both_visits)
```

``` output
[1] 8
```
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::: keypoints 

- Conditions are stored in the `condition_occurrence` table in the OMOP CDM.

- Visits are stored in the `visit_occurrence` table and linked to other clinical tables via `visit_occurrence_id`.

- A visit represents a period of time during which a patient interacts with the healthcare system and there can be multiple types of visits.

- Visits may be important to consider in analyses depending on the research question.

::::::::::::::::::::::::::::::::::::::::::::::::
