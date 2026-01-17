---
title: "Measurements and Observations"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- How to access measurements and observations ?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Know that measurements are mainly lab results and other records like pulse rate 

- Know observations are other facts obtained through questioning or direct observation

- Understand concept ids identify the measure or observation, values are stored in value_as_number or value_as_concept_id

- Be able to join to the concept table to find a particular measurement or observation concept by name
::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

This lesson covers the OMOP measurement and observation tables.

:::::::::::::::::::::::::::::::::::::::::::::::: callout

For the following episodes, we will be using a sample OMOP CDM database that is pre-loaded with data. This database is a simplified version of a real-world OMOP CDM database and is intended for educational purposes only.

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

The OMOP [measurement](https://ohdsi.github.io/CommonDataModel/cdm54.html#measurement) and [observation](https://ohdsi.github.io/CommonDataModel/cdm54.html#observation) tables contain information collected about a person.

The difference between them is that measurement contains numerical or categorical values collected by a standardised process, whereas observation contains less standardised clinical facts. 
Measurements are often lab results, vital signs or other clinical measurements such as height, weight, blood pressure, pulse rate, respiratory rate, oxygen saturations etc.
Observations are other facts obtained through questioning or direct observation, for example smoking status, alcohol intake, family history, symptoms reported by the patient etc.

A `person_id` column means that there can be multiple records per person.

Columns are similar between measurement and observation. 

## Concepts and values

Data are stored as questions and answers. A question (e.g. `Pulse rate`) is defined by a concept_id and the answer is stored in a value column.

The **measurement_concept_id** or **observation_concept_id** columns define what has been recorded. Here are some examples : 

Example Measurement concepts        | Example Observation concepts
----------------------------        | ----------------------------
Respiratory rate                    | Respiratory function
Pulse rate                          | Wound dressing observable
Hemoglobin saturation with oxygen   | Mandatory breath rate
Body temperature                    | Body position for blood pressure measurement
Diastolic blood pressure            | Alcohol intake - finding
Arterial oxygen saturation          | Tobacco smoking behavior - finding
Body weight                         | Vomit appearance
Leukocytes [#/volume] in Blood      | State of consciousness and awareness

::::::::::::::::::::::::::::::::::: challenge

Looking at their measurement and observation tables identify the various columns that might store a value.

:::::::::::::::::::::::: solution
The various **value** columns store values :

column name             | data type                  | example   | concept_name
----------------        | ------------               | --------- | -------
**value_as_number**     | numeric value              | 1.2       | -
**unit_concept_id**     | units of the numeric value | 9529      | kilogram
**value_as_concept_id** | categorical value          | 4328749   | High
**operator_concept_id** | optional operators         | 4172704   | >

Note where values are a concept_id, the name of that concept can be looked up in the concept table that is part of the OMOP vocabularies and included in most CDM instances.

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::


Look at the column values we have got in the tables associated with our database.


``` r
omop$public$measurement |> colnames() |> print()
```

``` output
[1] "measurement_id"         "person_id"              "measurement_concept_id"
[4] "measurement_date"       "measurement_datetime"   "value_as_number"       
[7] "unit_concept_id"        "visit_occurrence_id"   
```

``` r
omop$public$observation |> colnames() |> print()
```

``` output
[1] "observation_id"         "person_id"              "observation_concept_id"
[4] "observation_date"       "observation_datetime"   "value_as_string"       
[7] "value_as_concept_id"    "visit_occurrence_id"   
```
You can see that for observations the main value is a string or a concept, whereas for a measurement the main value is a number accompanied by the concept id of a unit.

## Looking at numeric measurement values

Let's focus on a single patient and look at what measurements and observations have been taken about them.

::::::::::::::::::::::::::::::::::: challenge

Create a mini measurement and observation table for person_id 1113

:::::::::::::::::::::::: solution


``` r
library(dplyr)
person_measurements <- omop$public$measurement |>
  filter(person_id == 1113) |>
  collect()
person_observations <- omop$public$observation |>
  filter(person_id == 1113) |>
  collect()
person_measurements
```

``` output
# A tibble: 7 × 8
  measurement_id person_id measurement_concept_id measurement_date
           <int>     <int>                  <int> <chr>           
1           8015      1113                3020891 2025-03-15      
2           8016      1113                3004249 2025-03-15      
3           8017      1113                3012888 2025-03-15      
4           8018      1113                3027018 2025-03-15      
5           8019      1113                3010813 2025-03-15      
6           8020      1113                3020891 2025-03-17      
7           8021      1113                3020891 2025-03-19      
# ℹ 4 more variables: measurement_datetime <chr>, value_as_number <dbl>,
#   unit_concept_id <int>, visit_occurrence_id <int>
```

``` r
person_observations
```

``` output
# A tibble: 4 × 8
  observation_id person_id observation_concept_id observation_date
           <int>     <int>                  <int> <chr>           
1           6008      1113                4024958 2025-03-15      
2           6009      1113                4232313 2025-03-15      
3           6010      1113                4160001 2025-03-15      
4           6011      1113                4203130 2025-03-19      
# ℹ 4 more variables: observation_datetime <chr>, value_as_string <chr>,
#   value_as_concept_id <int>, visit_occurrence_id <int>
```
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

Now we could go through each table and use our `get_concept_name` function to work out what all these measurements and observations are, but that could get a bit tedious!

Let's try and join to the concept table and produce a table that gives us the humanly readable names to start with.

:::::::::::::::::::::::: challenge

By joining to the concept table produce a version of the person_measurements and person_observations tables with concept names.

:::::::::::::::::::::::: solution


``` r
library(dplyr)
# Pre-load concept names and ids
concepts <- select(omop$public$concept |> collect(), concept_id, concept_name)

# Join to get names of the measurement concept id
# Rename the new column to measurement_concept_name
# Relocate the new column to be after measurement_concept_id
person_measurements_named <- person_measurements |>
  left_join(concepts, by=join_by(measurement_concept_id == concept_id)) |>
  rename(measurement_concept_name = concept_name) |>
  relocate(measurement_concept_name, .after = measurement_concept_id)

# Repeat the join to get names of the unit concept id
person_measurements_named <- person_measurements_named |>
  left_join(concepts, by = join_by(unit_concept_id == concept_id)) |>
  rename(unit_concept_name = concept_name) |>
  relocate(unit_concept_name, .after = unit_concept_id)

# Alternatively we could do it all in one go
person_observations_named <- person_observations |>
  left_join(select(omop$public$concept |> collect(), concept_id, concept_name), by=join_by(observation_concept_id==concept_id)) |> 
  rename(observation_concept_name=concept_name) |> 
  relocate(observation_concept_name, .after=observation_concept_id) |>
  left_join(select(omop$public$concept |> collect(), concept_id, concept_name), by=join_by(value_as_concept_id==concept_id)) |> 
  rename(value_as_concept_name=concept_name) |> 
  relocate(value_as_concept_name, .after=value_as_concept_id)
```

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

Now we can look at these named tables.

``` r
View(person_measurements_named)
```

``` error
Error in .External2(C_dataviewer, x, title): unable to start data viewer
```

``` r
View(person_observations_named)
```

``` error
Error in .External2(C_dataviewer, x, title): unable to start data viewer
```

::::::::::::::::::::::::::::::::::::: keypoints 

- know that measurements are mainly lab results and other records like pulse rate 
- know observations are other facts obtained through questioning or direct observation
- understand concept ids identify the measure or observation, values are stored in value_as_number or value_as_concept_id
- be able to join to the concept table to find a particular measurement or observation concept by name
- understand that different clinical questions can be answered by querying by patient and/or visit, or summing across all records 


::::::::::::::::::::::::::::::::::::::::::::::::


