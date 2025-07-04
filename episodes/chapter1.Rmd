---
title: "What is OMOP?"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is OMOP?
- What information would you expect to find in the person table?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Examine the diagram of the OMOP tables and the data specification
- Open a parquet file
- Interrogate the data in the person table

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

OMOP is a format for recording Electronic Healthcare Records. It allows you to follow a patient journey through a hospital by linking every aspect to a standard vocabulary thus enabling easy sharing of data between hospitals, trusts and even countries.

### OMOP CDM Diagram

![ALTERNATIVE TEXT](./figures/OMOP-CDM.png)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Make sure everyone has R open

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 

## Looking at the diagram answered the following:

1. Which table is the key to all the other tables in the standardized clinical data?

2. Which table would you also need to link to, to find information about Measurements made?

:::::::::::::::::::::::: solution 

1. The **Person** table

2. The **Visit_occurrence** table
:::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1: Find the age and ethnicity of a patient.

What is the age an ethnicity or patient with patient_id = "2" ?

```r
 install omopcept from Github if not installed
if (!requireNamespace("omopcept", quietly=TRUE)) 
{
  if (!requireNamespace("remotes", quietly=TRUE)) install.packages("remotes")
  
  remotes::install_github("SAFEHR-data/omopcept")
}

library(readr)
library(dplyr)
library(here)
library(gh)
library(omopcept)
library(ggplot2)
library(stringr)
library(lubridate)

repo <- "SAFEHR-data/uclh-research-discovery"
path <- "_projects/uclh_cchic_s0/data"
destdata <- here("dynamic-docs/02-omop-walkthrough-critical-care/data")

# only download if not already present
if (! file.exists(file.path(destdata,"person.csv")))
{
  # Make GitHub API request to list contents of given path
  response <- gh::gh(glue::glue("/repos/{repo}/contents/{path}"))

  # Download all files to the destination dir
  purrr::walk(response, ~ download.file(.x$download_url, destfile = file.path(destdata, .x$name)))

  list.files(destdata)
}

omop <- omopcept::omop_cdm_read(destdata, filetype="csv")

# names() can show us names of the tables read in
names(omop)

# names() can also show column names for one of the tables
names(omop$person)


```

testing out a theory

:::::::::::::::::::::::: solution 

## Output
 
```output
[1] Not finished yet!!!
```

:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/
