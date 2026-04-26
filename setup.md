---
title: Setup
---

# Setup instructions

## Install R Packages

Run these commands in the R terminal to install the following libraries needed for the courses.

```r
pkgs <- c(
    "dplyr",
    "readr",
    "purrr",
    "CDMConnector",
    "duckdb",
    "lubridate",
    "arrow",
    "tibble"
)
install.packages(pkgs)
```


## Download course data and example code
1. Make a new folder in your Desktop called `omop_course`.
2. Download [workshop.zip](episodes/workshop.zip) and move the file to this folder.
3. If it's not unzipped yet, unzip it. There should now be a folder called `workshop` in the `omop_course` folder containing sub folders `code` and `data`.
4. You can access this folder from the Unix shell with:

```bash
$ cd
$ cd Desktop/omop_course/workshop
```

