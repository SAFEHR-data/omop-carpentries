---
title: "More on concepts"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- Where to find other concept_ids in OMOP

- How to link OMOP tables

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand that there are many other concept_ids in OMOP tables and that these are usually named with a _concept_id suffix.

- Learn how to link OMOP tables using common identifiers such as person_id and visit_occurrence_id.

- Be able to use the concept table to look up humanly readable names for various concept_ids.

- Use joins to combine data from multiple OMOP tables based on common identifiers.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In this episode, we will explore more concepts related to the OMOP Common Data Model (CDM). We will focus on understanding how different tables in the OMOP CDM are linked together through common identifiers. This knowledge is crucial for effectively querying and analysing healthcare data stored in the OMOP format.

:::::::::::::::::::::::::::::::::::::::::::::::: callout

For this episode we will be using a sample OMOP CDM database that is pre-loaded with data. This database is a simplified version of a real-world OMOP CDM database and is intended for educational purposes only.

(UCLH only) This will come in the same form as you would get data if you asked for a data extract via the SAFEHR platform (i.e. a set of parquet files).

As part of the setup prior to this course you were asked to download and install the sample database. If you have not done this yet, please refer to the setup instructions provided earlier in the course. For now, we will assume that you have the sample OMOP CDM database available on your local machine at the following path: `workshop/data/public/` and the functions in a folder `workshop/code/parquet_dataset`.

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

and the useful function we created in the previous episode to look up concept names.


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

::::::::::::::::::::::::::::::::::::::::::::::::

## Other concept_ids in OMOP

In addition to the `concept_id` column in various OMOP tables, there are several other columns that use *_concept_id to provide information.

### The `person` table contains the following columns (among others not listed here):
| Column Names          | Description of content |
|-----------------------|---------------------------------------|
| **person_id** | Unique identifier for each person |
| **gender_concept_id** | Concept identifier for the gender of the person |
| **year_of_birth** | Year of birth of the person |
| **month_of_birth** | Month of birth of the person |
| **day_of_birth** | Day of birth of the person |
| **race_concept_id** | Concept identifier for the race of the person |
| **gender_source_value** | Source value for the gender of the person |
| **race_source_value** | Source value for the race of the person |


Look at the column names of the `person` table.

``` r
omop$public$person
```

``` output
FileSystemDataset with 1 Parquet file
8 columns
person_id: int32
gender_concept_id: int32
year_of_birth: int32
month_of_birth: int32
day_of_birth: int32
race_concept_id: int32
gender_source_value: string
race_source_value: string

See $metadata for additional Schema metadata
```

Several of these columns end with `_concept_id`, such as `gender_concept_id` and `race_concept_id`. These columns link to the `concept` table to provide humanly readable names for the concepts represented by these IDs.

For example, to get the gender name for a person, you can use the `gender_concept_id` column in the `person` table and look it up in the `concept` table.
 

``` r
# First read in the person table
library(dplyr)
person <- omop$public$person |> collect()
```

From this we can see that the `gender_concept_id` can have values **8507** or **8532**. We can look these up in the `concept` table using the previously defined function `get_concept_name()`.


``` r
get_concept_name(8507)
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Male        
```


``` r
get_concept_name(8532)
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Female      
```

It might also be useful to look up id values from the names. We can create a function `get_concept_id()` that takes a concept_name as input and returns the concept_id.

::::::::::::::::::::::::::::::::::: challenge

Create the function `get_concept_id()` that takes a `concept_name` as input and returns the `concept_id`.

::::::::::::::::::::::::::::::::::: solution


``` r
get_concept_id <- function(name) {
  omop$public$concept |>
    filter(concept_name == !!name) |>
    select(concept_id) |>
    collect()
}
```

**CODING_NOTE**: The `!!` operator is used to unquote the variable `name` so that it can be evaluated within the `filter` function and the `collect()` function is used to retrieve the results from the remote database.

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

Check that this works by looking up the concept_id for "Female".


``` r
get_concept_id("Female")
```

``` output
# A tibble: 1 × 1
  concept_id
       <int>
1       8532
```

***Answer:*** The concept_id for "Female" is **8532**.

::::::::::::::::::::::::::::::::::: challenge

Using the `person` table and the functions `get_concept_name()` and `get_concept_id()` that we have defined, answer the following questions:

1. What is the gender of the `White` patient in the `person` table?

2. What is the gender of the `White British` patient in the `person` table?

3. How many men and women are in the person table?

::::::::::::::::::::::::::::::::::: solution

1. First we need to know the `concept_id` of the concept `White`

``` r
get_concept_id("White")
```

``` output
# A tibble: 1 × 1
  concept_id
       <int>
1       8527
```

Then we need to know which patient has this race_concept_id and what the corresponding gender_concept_id is for this patient.


``` r
white <- person |> 
  filter(race_concept_id == 8527)
get_concept_name(white$gender_concept_id)
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Female      
```

***Answer:*** The White patient is female. (Note the code above assumes there is only one `White` patient.)

2. Similarly, we first need to know the `concept_id` of the concept `White British`

``` r
get_concept_id("White British")
```

``` output
# A tibble: 1 × 1
  concept_id
       <int>
1   46286810
```

Then we need to know which patient has this race_concept_id and what the corresponding gender_concept_id is for this patient.   

``` r
white_british <- person |> 
  filter(race_concept_id == 46286810)
get_concept_name(white_british$gender_concept_id) 
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Female      
```

***Answer:*** The White British patient is female. (Note the code above assumes there is only one `White British` patient.)

3. The table is small enough to actually count by hand but also we can use the R package `dplyr` to count the number of men and women.


``` r
# Let's create a mini version of the concept table that contains only the concepts(the gender concepts) and the columns(concept_id, concept_name)  we want

gender_concept <- omop$public$concept |> 
  filter(concept_id %in% c(8507, 8532)) |>
  select(concept_id, concept_name) |> 
  collect()

# Now we can join to get the number of people of each gender
person |> 
  left_join(gender_concept, by = c("gender_concept_id" = "concept_id")) |>
  group_by(concept_name) |>
  summarise(count = n())
```

``` output
# A tibble: 2 × 2
  concept_name count
  <chr>        <int>
1 Female           5
2 Male             3
```

**CODING_NOTE**: The `left_join` function is used to combine the person table with the gender_concept table we created, based on the gender_concept_id. This allows us to get the humanly readable gender names. 

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

## Linking OMOP tables

In the previous episode, we saw how to look up concept names using concept_ids. In this episode, we will explore how different OMOP tables are linked together using common identifiers.

For example, the `visit_occurrence` table contains a `person_id` column that links to the `person` table. This allows us to retrieve information about the person associated with a particular visit.


``` r
omop$public$visit_occurrence
```

``` output
FileSystemDataset with 1 Parquet file
10 columns
visit_occurrence_id: int32
person_id: int32
visit_concept_id: int32
visit_start_date: string
visit_start_datetime: string
visit_end_date: string
visit_end_datetime: string
visit_type_concept_id: int32
discharged_to_concept_id: int32
preceding_visit_occurrence_id: int32

See $metadata for additional Schema metadata
```


``` r
omop$public$person
```

``` output
FileSystemDataset with 1 Parquet file
8 columns
person_id: int32
gender_concept_id: int32
year_of_birth: int32
month_of_birth: int32
day_of_birth: int32
race_concept_id: int32
gender_source_value: string
race_source_value: string

See $metadata for additional Schema metadata
```

::::::::::::::::::::::::::::::::::: challenge

Using the `person` and `visit_occurrence` tables, answer the following questions:

1. How many visits are recorded for each person in the `visit_occurrence` table

::::::::::::::::::::::::::::::::::: solution

1. We can count the number of visits for each person by grouping the `visit_occurrence` table by `person_id` and counting the number of occurrences.

``` r
visit_counts <- omop$public$visit_occurrence |>
  group_by(person_id) |>
  summarise(visit_count = n()) |>
  collect()
visit_counts
```

``` output
# A tibble: 8 × 2
  person_id visit_count
      <int>       <int>
1      1111           1
2      1112           2
3      1113           1
4     78901           1
5     34567           1
6        31           2
7         2           2
8        58          10
```

**CODING_NOTE**: The `group_by` function is used to group the data by `person_id`, and the `summarise` function is used to count the number of visits for each person. The `collect()` function is used to retrieve the results from the remote database.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- OMOP tables contain many concept_ids, usually named with a _concept_id suffix.

- The concept table can be used to look up humanly readable names for various concept_ids.

- OMOP tables can be linked using common identifier.

::::::::::::::::::::::::::::::::::::::::::::::::
