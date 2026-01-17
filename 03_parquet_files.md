---
title: "Parquet files"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is a parquet file?

- How to explore and open parquet files in R?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the structure of parquet files.

- Learn how to read parquet files in R.


::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In this episode, we will explore parquet files, a popular file format for storing large datasets efficiently. We will learn how to read parquet files in R and understand their structure.

::::::::::::::::::::::::::::::::::::::::::::::::callout

For the following episodes, we will be using a sample OMOP CDM database that is pre-loaded with data. This database is a simplified version of a real-world OMOP CDM database and is intended for educational purposes only.

(UCLH only) This will come in the same form as you would get data if you asked for a data extract via the SAFEHR platform (i.e. a set of parquet files).

As part of the setup prior to this course you were asked to download and install the sample database. If you have not done this yet, please refer to the setup instructions provided earlier in the course. For now, we will assume that you have the sample OMOP CDM database available on your local machine at the following path: `workshop/data/public/` and the functions in a folder `workshop/code`.


::::::::::::::::::::::::::::::::::::::::::::::::

## Parquet files

Parquet is a columnar storage file format that is optimized for use with big data processing frameworks. It is designed to be efficient in terms of both storage space and read/write performance. Parquet files are often used in data warehousing and big data analytics applications.

## Exploring Parquet files

We have provided a function that will allow you to browse the structure of the data in the same way as we did with the database in the previous episode. This code is available in the `workshop/code/open_omop_dataset.R` file. You can source this file to load the function into your R environment.


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

Now we can use this function to open the sample OMOP CDM dataset located in the `workshop/data/public/` directory and explore it in the same way as we did with the database in the previous episode.

``` r
omop <- open_omop_dataset("./data/")
```

::::::::::::::::::::::::::::::::::::: instructor

Note that the path to the data directory may be different depending on where you have stored the sample OMOP CDM dataset on your local machine.

Check the people have used the right path.Their environment should now have an entry under Data reading 'omop List of 1'

::::::::::::::::::::::::::::::::::::::::::::::::

Explore the data using the following:

``` r
omop$public
```

``` output
$concept
FileSystemDataset with 1 Parquet file
5 columns
concept_id: int32
concept_name: string
domain_id: string
vocabulary_id: string
standard_concept: string

See $metadata for additional Schema metadata

$condition_occurrence
FileSystemDataset with 1 Parquet file
8 columns
condition_occurrence_id: int32
person_id: int32
condition_concept_id: int32
condition_start_date: string
condition_start_datetime: string
condition_end_date: string
condition_type_concept_id: int32
visit_occurrence_id: int32

See $metadata for additional Schema metadata

$drug_exposure
FileSystemDataset with 1 Parquet file
9 columns
drug_exposure_id: int32
person_id: int32
drug_concept_id: int32
drug_exposure_start_date: string
drug_exposure_start_datetime: string
drug_exposure_end_date: string
drug_exposure_end_datetime: string
drug_type_concept_id: int32
visit_occurrence_id: int32

See $metadata for additional Schema metadata

$measurement
FileSystemDataset with 1 Parquet file
8 columns
measurement_id: int32
person_id: int32
measurement_concept_id: int32
measurement_date: string
measurement_datetime: string
value_as_number: double
unit_concept_id: int32
visit_occurrence_id: int32

See $metadata for additional Schema metadata

$observation
FileSystemDataset with 1 Parquet file
8 columns
observation_id: int32
person_id: int32
observation_concept_id: int32
observation_date: string
observation_datetime: string
value_as_string: string
value_as_concept_id: int32
visit_occurrence_id: int32

See $metadata for additional Schema metadata

$person
FileSystemDataset with 1 Parquet file
7 columns
person_id: int32
gender_concept_id: int32
year_of_birth: int32
month_of_birth: int32
day_of_birth: int32
race_concept_id: int32
ethnicity_concept_id: int32

See $metadata for additional Schema metadata

$procedure_occurrence
FileSystemDataset with 1 Parquet file
8 columns
procedure_occurrence_id: int32
person_id: int32
procedure_concept_id: int32
procedure_date: string
procedure_datetime: string
procedure_type_concept_id: int32
visit_occurrence_id: int32
procedure_end_datetime: string

See $metadata for additional Schema metadata

$visit_occurrence
FileSystemDataset with 1 Parquet file
9 columns
visit_occurrence_id: int32
person_id: int32
visit_concept_id: int32
visit_start_date: string
visit_start_datetime: string
visit_end_date: string
visit_end_datetime: string
visit_type_concept_id: int32
preceding_visit_occurrence_id: int32

See $metadata for additional Schema metadata
```

You will see that this gives you a list of all the tables in this dataset and what columns they contain. It is obviously a much smaller dataset! You can explore individual tables which will also give you the column names.


``` r
omop$public$person
```

``` output
FileSystemDataset with 1 Parquet file
7 columns
person_id: int32
gender_concept_id: int32
year_of_birth: int32
month_of_birth: int32
day_of_birth: int32
race_concept_id: int32
ethnicity_concept_id: int32

See $metadata for additional Schema metadata
```
To actually open each table we can use

``` r
library(dplyr)
person <- omop$public$person |> collect()
person
```

``` output
# A tibble: 5 × 7
  person_id gender_concept_id year_of_birth month_of_birth day_of_birth
      <int>             <int>         <int>          <int>        <int>
1      1111              8507          1993              8           15
2      1112              8532          1970              8           15
3      1113              8507          1983              8           15
4     34567              8532          2015              7           27
5     78901              8532          1989              5           29
# ℹ 2 more variables: race_concept_id <int>, ethnicity_concept_id <int>
```
 
or we can use the specific functions from the `arrow` package to read in the parquet files directly.


``` r
library(arrow)
person <- read_parquet("./data/public/person/person.parquet")
person
```

``` output
# A tibble: 5 × 7
  person_id gender_concept_id year_of_birth month_of_birth day_of_birth
      <int>             <int>         <int>          <int>        <int>
1      1111              8507          1993              8           15
2      1112              8532          1970              8           15
3      1113              8507          1983              8           15
4     34567              8532          2015              7           27
5     78901              8532          1989              5           29
# ℹ 2 more variables: race_concept_id <int>, ethnicity_concept_id <int>
```

::::::::::::::::::::::::::::::::::::: challenge

Adapt the code we had developed for the get_concept_name function in the previous episode to work with this parquet file dataset.

::::::::::::::::::::::::::::::::::::: solution

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
::::::::::::::::::::::::::::::::::::::::::::::::

Now we can use this function to look up concept names by their concept_id.


``` r
get_concept_name(8507)
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Male        
```

::::::::::::::::::::::::::::::::::::: keypoints 

- Parquet files are a columnar storage file format optimized for big data processing.

- The `arrow` package in R can be used to read and manipulate parquet files.

::::::::::::::::::::::::::::::::::::::::::::::::
