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

For this episode we will be using a sample OMOP CDM database that is pre-loaded with data. This database is a simplified version of a real-world OMOP CDM database and is intended for educational purposes only.

(UCLH only) This will come in a similar form as you would get data if you asked for a data extract via the SAFEHR platform (i.e. a set of parquet files).

As part of the setup prior to this course you were asked to download and install the sample dataset. If you have not done this yet, please refer to the [setup instructions](../learners/setup.md). For now, we will assume that you have the sample OMOP CDM dataset available on your local machine at the following path: `./data/omop/` and the functions in a folder `./code/parquet_dataset`.

  
::::::::::::::::::::::::::::::::::::::::::::::::

## Parquet files

Parquet is a columnar storage file format that is optimized for use with big data processing frameworks. It is designed to be efficient in terms of both storage space and read/write performance. Parquet files are often used in data warehousing and big data analytics applications.

## Exploring Parquet files

We have provided a function that will allow you to browse the structure of the data in the same way as we did with the database in the previous episode. This code is available below or in the downloaded `workshop/code/open_omop_dataset.R` file. You can source this file to load the function into your R environment.


``` r
open_omop_dataset <- function(path) {
    # iterate over table level directories
    list.dirs(path, recursive = FALSE) |>
      # exclude folder name from path and use it as index for named list
      purrr::set_names(~ basename(.)) |>
      # "lazy-load" list of parquet files from specified folder
      purrr::map(arrow::open_dataset)
}
```

**CODING_NOTE**: This function uses the `arrow` package to read in the parquet files. The `open_dataset()` function from the `arrow` package allows us to read in the parquet files without having to load the entire dataset into memory. This is particularly useful when working with large datasets. The function is reasonably complex but it is designed to be flexible and work with any OMOP CDM dataset that is structured in the same way as the one we are using for this course. It will read in all the parquet files in the specified directory and create a nested list structure that allows us to easily access the different tables in the dataset. We leave it to you to explore the code and understand how it works.

Now we can use this function to open the sample OMOP CDM dataset located in the `workshop/data/omop/` directory and explore it in the same way as we did with the database in the previous episode.


``` r
omop <- open_omop_dataset("./data/omop")
```

::::::::::::::::::::::::::::::::::::: instructor

Note that the path to the data directory may be different depending on where you have stored the sample OMOP CDM dataset on your local machine.

Check the people have used the right path. Their environment should now have an entry under Data reading 'omop List of 8'

::::::::::::::::::::::::::::::::::::::::::::::::

Explore the data using the following:

``` r
omop
```

``` output
$concept
FileSystemDataset with 1 Parquet file
10 columns
concept_id: int32
concept_name: string
domain_id: string
vocabulary_id: string
standard_concept: string
concept_class_id: string
concept_code: string
valid_start_date: date32[day]
valid_end_date: date32[day]
invalid_reason: string

$concept_relationship
FileSystemDataset with 1 Parquet file
6 columns
concept_id_1: int32
concept_id_2: int32
relationship_id: string
valid_start_date: date32[day]
valid_end_date: date32[day]
invalid_reason: string

$condition_occurrence
FileSystemDataset with 1 Parquet file
10 columns
condition_occurrence_id: int32
person_id: int32
condition_concept_id: int32
condition_start_date: date32[day]
condition_end_date: date32[day]
condition_type_concept_id: int32
condition_status_concept_id: int32
visit_occurrence_id: int32
condition_source_value: string
condition_source_concept_id: int32

$drug_exposure
FileSystemDataset with 1 Parquet file
12 columns
drug_exposure_id: int32
person_id: int32
drug_concept_id: int32
drug_exposure_start_date: date32[day]
drug_exposure_start_datetime: timestamp[us, tz=UTC]
drug_exposure_end_date: date32[day]
drug_exposure_end_datetime: timestamp[us, tz=UTC]
drug_type_concept_id: int32
quantity: double
route_concept_id: int32
visit_occurrence_id: int32
drug_source_concept_id: int32

$drug_strength
FileSystemDataset with 1 Parquet file
12 columns
drug_concept_id: int32
ingredient_concept_id: int32
amount_value: double
amount_unit_concept_id: int32
numerator_value: double
numerator_unit_concept_id: int32
denominator_value: double
denominator_unit_concept_id: int32
box_size: double
valid_start_date: date32[day]
valid_end_date: date32[day]
invalid_reason: string

$measurement
FileSystemDataset with 1 Parquet file
12 columns
measurement_id: double
person_id: int32
measurement_concept_id: int32
measurement_date: date32[day]
measurement_datetime: timestamp[us, tz=UTC]
operator_concept_id: double
value_as_number: double
value_as_concept_id: double
unit_concept_id: double
range_low: double
range_high: double
visit_occurrence_id: int32

$observation
FileSystemDataset with 1 Parquet file
9 columns
observation_id: int32
person_id: int32
observation_concept_id: int32
observation_date: date32[day]
observation_datetime: timestamp[us, tz=UTC]
value_as_number: int32
value_as_string: string
value_as_concept_id: int32
visit_occurrence_id: int32

$person
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

$procedure_occurrence
FileSystemDataset with 1 Parquet file
7 columns
procedure_occurrence_id: int32
person_id: int32
procedure_concept_id: int32
procedure_date: date32[day]
procedure_datetime: timestamp[us, tz=UTC]
procedure_type_concept_id: int32
visit_occurrence_id: int32

$visit_occurrence
FileSystemDataset with 1 Parquet file
10 columns
visit_occurrence_id: int32
person_id: int32
visit_concept_id: int32
visit_start_date: date32[day]
visit_start_datetime: timestamp[us, tz=UTC]
visit_end_date: date32[day]
visit_end_datetime: timestamp[us, tz=UTC]
visit_type_concept_id: int32
discharged_to_concept_id: int32
preceding_visit_occurrence_id: int32
```

You will see that this gives you a list of all the tables in this dataset and what columns they contain. It is obviously a much smaller dataset! You can explore individual tables which will also give you the column names and the data type of the entry.


``` r
omop$person
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
```
To actually open each table we can use

``` r
library(dplyr)
person <- omop$person |>
  collect()

person
```

``` output
# A tibble: 8 × 8
  person_id gender_concept_id year_of_birth month_of_birth day_of_birth
      <int>             <int>         <int>          <int>        <int>
1      1111              8507          1993              6           15
2      1112              8532          1970              6           15
3      1113              8507          1983              6           15
4     34567              8532          2015              6           15
5     78901              8532          1989              6           15
6        31              8532          1987              0            0
7         2              8532          2008              0            0
8        58              8507          1985              0            0
# ℹ 3 more variables: race_concept_id <int>, gender_source_value <chr>,
#   race_source_value <chr>
```

**CODING_NOTE**: The `collect()` function is used to actually read the data from the parquet files into memory. This is necessary because the `open_dataset()` function creates a reference to the data rather than loading it into memory. By using `collect()`, we can work with the data as a regular data frame in R.

Or we can use the specific functions from the `arrow` package to read in the parquet files directly.


``` r
library(arrow)
person <- read_parquet("./data/omop/person/part-0.parquet")
person
```

``` output
# A tibble: 8 × 8
  person_id gender_concept_id year_of_birth month_of_birth day_of_birth
      <int>             <int>         <int>          <int>        <int>
1      1111              8507          1993              6           15
2      1112              8532          1970              6           15
3      1113              8507          1983              6           15
4     34567              8532          2015              6           15
5     78901              8532          1989              6           15
6        31              8532          1987              0            0
7         2              8532          2008              0            0
8        58              8507          1985              0            0
# ℹ 3 more variables: race_concept_id <int>, gender_source_value <chr>,
#   race_source_value <chr>
```

**CODING_NOTE**: The `read_parquet()` function from the `arrow` package allows us to read in a specific parquet file directly into R. This can be useful if we only want to work with a specific table from the dataset and do not need any of the other files.

::::::::::::::::::::::::::::::::::::: instructor

Check that everyone has been able to read in the person table and see the data.

Points worth a discussion:

- the day and month of birth

- gender_source_value and race_source_value are given for some rows but not others

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: callout

As part of the privacy preserving policies around health data, dates of birth are often de-identified to only show the year of birth. This is why in this dataset the day and month of birth are set to 15/6 or 0/0 for all individuals.

You can also see that in some cases the gender_source_value and race_source_value columns are populated while in others they are not. This depends on the policy of the individual hospital. Note: the data in this dataset is a number of different sources combined together to form a single OMOP CDM database.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

Adapt the code we had developed for the get_concept_name function in the previous episode to work with this parquet file dataset.

::::::::::::::::::::::::::::::::::::: solution

``` r
get_concept_name <- function(omop_obj, id) {
  omop_obj$concept |>
    filter(concept_id == id) |>
    select(concept_name) |>
    collect()
}
```

**CODING_NOTE**: The `get_concept_name()` function is adapted to work with the parquet file dataset. It uses the `filter()` and `select()` functions from the `dplyr` package to query the `concept` table in the parquet dataset. The `collect()` function is used to read the result into memory so that we can work with it as a regular data frame in R.

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

Now we can use this function to look up concept names by their concept_id.


``` r
get_concept_name(omop, 8507)
```

``` output
# A tibble: 1 × 1
  concept_name
  <chr>       
1 Male        
```

***Answer:*** The concept_id **8507** corresponds to the concept "Male".

::::::::::::::::::::::::::::::::::::: keypoints 

- Parquet files are a columnar storage file format optimized for big data processing.

- The `arrow` package in R can be used to read and manipulate parquet files.

::::::::::::::::::::::::::::::::::::::::::::::::
