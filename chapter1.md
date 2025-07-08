---
title: "What is OMOP?"
teaching: 0
exercises: 0
---
:::::::::::::::::::::::::::::::::::::: questions 

- What is OMOP?
- What information would you expect to find in the person table?
- What information would you expect to find in the condition_occurrence table?
- How can you join these tables to aggregate information?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Examine the diagram of the OMOP tables and the data specification
- Interrogate the data in the person table

::::::::::::::::::::::::::::::::::::::::::::::::
 
## Setting up R

### Getting started

Since we want to import the files called `*.csv` into our R
environment, we need to be able to tell our computer where the file is.
To do this, we will create a "Project" with RStudio that contains the
data we want to work with.
The "Projects" interface in RStudio not only creates a working directory for
you, but also remembers its location (allowing you to quickly navigate to it).
The interface also (optionally) preserves custom settings and open files to
make it easier to resume work after a break.

### Create a new project


::::::::::::::::::::::::::::::::::::: group-tab

### Experienced
Create a new project in your environment.

### Need a reminder
- Under the `File` menu in RStudio, click on `New project`, choose
  `New directory`, then `New project`
- Enter a name for this new folder (or "directory") and choose a convenient
  location for it. This will be your **working directory** for the rest of the
  day (e.g., `~/Desktop/r-omop`).
- Click on `Create project`
- Create a new file where we will type our scripts. Go to File > New File > R
  script. Click the save icon on your toolbar and save your script as
  "`script.R`".
- Make sure you copy the data for the lesson into this folder, if they're
  not there already.
:::::::::::::::::::::::::::::::::::::::::::::::

### Install the required packages

You will need the `tidyverse` package from CRAN (the official package repository).
You will also need a package we have developed `omopcept`.



``` r
install.packages("tidyverse")
```

``` output
# Downloading packages -------------------------------------------------------
- Downloading tidyverse from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [415.9 Kb in 0.3s]
- Downloading broom from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.8 Mb in 0.27s]
- Downloading conflicted from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [53.8 Kb in 0.2s]
- Downloading dtplyr from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [349.5 Kb in 0.3s]
- Downloading data.table from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [2.6 Mb in 0.24s]
- Downloading forcats from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [411.7 Kb in 0.33s]
- Downloading ggplot2 from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [4.8 Mb in 0.28s]
- Downloading gtable from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [217.4 Kb in 0.26s]
- Downloading isoband from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.6 Mb in 0.15s]
- Downloading scales from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [822 Kb in 0.22s]
- Downloading farver from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.4 Mb in 0.18s]
- Downloading labeling from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [59.5 Kb in 0.23s]
- Downloading RColorBrewer from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [50.8 Kb in 0.31s]
- Downloading viridisLite from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.2 Mb in 0.22s]
- Downloading googledrive from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.8 Mb in 0.48s]
- Downloading gargle from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [757.5 Kb in 0.15s]
- Downloading httr from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [475.7 Kb in 0.2s]
- Downloading curl from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [770.7 Kb in 0.21s]
- Downloading openssl from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [1.3 Mb in 0.19s]
- Downloading askpass from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [21.5 Kb in 0.21s]
- Downloading sys from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [39.9 Kb in 0.18s]
- Downloading uuid from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [47.7 Kb in 0.24s]
- Downloading googlesheets4 from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [504.9 Kb in 0.16s]
- Downloading cellranger from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [101.5 Kb in 0.23s]
- Downloading rematch from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [15.9 Kb in 0.14s]
- Downloading ids from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [119.8 Kb in 0.15s]
- Downloading rematch2 from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [45 Kb in 0.24s]
- Downloading haven from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [378.6 Kb in 0.16s]
- Downloading lubridate from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [969.9 Kb in 0.23s]
- Downloading timechange from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [166.5 Kb in 0.17s]
- Downloading modelr from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [196.1 Kb in 0.16s]
- Downloading ragg from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [646.1 Kb in 0.16s]
- Downloading systemfonts from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [334.9 Kb in 0.17s]
- Downloading textshaping from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [179.4 Kb in 0.22s]
- Downloading readxl from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [398.9 Kb in 0.16s]
- Downloading reprex from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [483.4 Kb in 0.29s]
- Downloading callr from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [438.9 Kb in 0.16s]
- Downloading processx from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [329.4 Kb in 0.16s]
- Downloading ps from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [488.8 Kb in 0.18s]
- Downloading rstudioapi from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [310.4 Kb in 0.15s]
- Downloading rvest from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [293.1 Kb in 0.16s]
- Downloading selectr from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [491.3 Kb in 0.16s]
- Downloading xml2 from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [275.2 Kb in 0.14s]
Successfully downloaded 43 packages in 17 seconds.

The following package(s) will be installed:
- askpass       [1.2.1]
- broom         [1.0.8]
- callr         [3.7.6]
- cellranger    [1.1.0]
- conflicted    [1.2.0]
- curl          [6.4.0]
- data.table    [1.17.6]
- dtplyr        [1.3.1]
- farver        [2.1.2]
- forcats       [1.0.0]
- gargle        [1.5.2]
- ggplot2       [3.5.2]
- googledrive   [2.1.1]
- googlesheets4 [1.1.1]
- gtable        [0.3.6]
- haven         [2.5.5]
- httr          [1.4.7]
- ids           [1.0.1]
- isoband       [0.2.7]
- labeling      [0.4.3]
- lubridate     [1.9.4]
- modelr        [0.1.11]
- openssl       [2.3.3]
- processx      [3.8.6]
- ps            [1.9.1]
- ragg          [1.4.0]
- RColorBrewer  [1.1-3]
- readxl        [1.4.5]
- rematch       [2.0.0]
- rematch2      [2.1.2]
- reprex        [2.1.1]
- rstudioapi    [0.17.1]
- rvest         [1.0.4]
- scales        [1.4.0]
- selectr       [0.4-2]
- sys           [3.4.3]
- systemfonts   [1.2.3]
- textshaping   [1.0.1]
- tidyverse     [2.0.0]
- timechange    [0.3.0]
- uuid          [1.2-1]
- viridisLite   [0.4.2]
- xml2          [1.3.8]
These packages will be installed into "~/work/omop-carpentries/omop-carpentries/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-jammy/R-4.5/x86_64-pc-linux-gnu".

The following required system packages are not installed:
- pandoc  [required by reprex]
The R packages depending on these system packages may fail to install.

An administrator can install these packages with:
- sudo apt install pandoc

# Installing packages --------------------------------------------------------
- Installing broom ...                          OK [installed binary and cached in 0.53s]
- Installing conflicted ...                     OK [installed binary and cached in 0.26s]
- Installing data.table ...                     OK [installed binary and cached in 0.28s]
- Installing dtplyr ...                         OK [installed binary and cached in 0.55s]
- Installing forcats ...                        OK [installed binary and cached in 0.29s]
- Installing gtable ...                         OK [installed binary and cached in 0.41s]
- Installing isoband ...                        OK [installed binary and cached in 0.2s]
- Installing farver ...                         OK [installed binary and cached in 0.19s]
- Installing labeling ...                       OK [installed binary and cached in 0.16s]
- Installing RColorBrewer ...                   OK [installed binary and cached in 0.16s]
- Installing viridisLite ...                    OK [installed binary and cached in 0.17s]
- Installing scales ...                         OK [installed binary and cached in 0.39s]
- Installing ggplot2 ...                        OK [installed binary and cached in 0.75s]
- Installing curl ...                           OK [installed binary and cached in 0.19s]
- Installing sys ...                            OK [installed binary and cached in 0.16s]
- Installing askpass ...                        OK [installed binary and cached in 0.16s]
- Installing openssl ...                        OK [installed binary and cached in 0.21s]
- Installing httr ...                           OK [installed binary and cached in 0.17s]
- Installing gargle ...                         OK [installed binary and cached in 0.33s]
- Installing uuid ...                           OK [installed binary and cached in 0.16s]
- Installing googledrive ...                    OK [installed binary and cached in 0.59s]
- Installing rematch ...                        OK [installed binary and cached in 0.16s]
- Installing cellranger ...                     OK [installed binary and cached in 0.16s]
- Installing ids ...                            OK [installed binary and cached in 0.16s]
- Installing rematch2 ...                       OK [installed binary and cached in 0.39s]
- Installing googlesheets4 ...                  OK [installed binary and cached in 0.58s]
- Installing haven ...                          OK [installed binary and cached in 0.42s]
- Installing timechange ...                     OK [installed binary and cached in 0.17s]
- Installing lubridate ...                      OK [installed binary and cached in 0.3s]
- Installing modelr ...                         OK [installed binary and cached in 0.5s]
- Installing systemfonts ...                    OK [installed binary and cached in 0.27s]
- Installing textshaping ...                    OK [installed binary and cached in 0.27s]
- Installing ragg ...                           OK [installed binary and cached in 0.3s]
- Installing readxl ...                         OK [installed binary and cached in 0.18s]
- Installing ps ...                             OK [installed binary and cached in 0.17s]
- Installing processx ...                       OK [installed binary and cached in 0.18s]
- Installing callr ...                          OK [installed binary and cached in 0.19s]
- Installing rstudioapi ...                     OK [installed binary and cached in 0.17s]
- Installing reprex ...                         OK [installed binary and cached in 0.32s]
- Installing selectr ...                        OK [installed binary and cached in 0.31s]
- Installing xml2 ...                           OK [installed binary and cached in 0.26s]
- Installing rvest ...                          OK [installed binary and cached in 0.31s]
- Installing tidyverse ...                      OK [installed binary and cached in 0.17s]
Successfully installed 43 packages in 13 seconds.
```

``` r
install.packages("remotes")
```

``` output
# Downloading packages -------------------------------------------------------
- Downloading remotes from https://packagemanager.posit.co/cran/__linux__/jammy/latest ... OK [425.9 Kb in 0.17s]
Successfully downloaded 1 package in 0.38 seconds.

The following package(s) will be installed:
- remotes [2.5.0]
These packages will be installed into "~/work/omop-carpentries/omop-carpentries/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-jammy/R-4.5/x86_64-pc-linux-gnu".

# Installing packages --------------------------------------------------------
- Installing remotes ...                        OK [installed binary and cached in 0.18s]
Successfully installed 1 package in 0.2 seconds.
```


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Make sure everyone has R open

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

OMOP is a format for recording Electronic Healthcare Records. It allows you to follow a patient journey through a hospital by linking every aspect to a standard vocabulary thus enabling easy sharing of data between hospitals, trusts and even countries.

### OMOP CDM Diagram

![The OMOP Common Data Model ](fig/OMOP-CDM.png)


::::::::::::::::::::::::::::::::::::: challenge 

## Test yourself

Look at the OMOP-CDM figure and answer the following questions:

1. Which table is the key to all the other tables?
2. Which table allows you to distinguish between different stays in hospital?

:::::::::::::::::::::::: solution 
1. The **Person** table

2. The **Visit_occurrence** table
:::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

## Why use OMOP?

![Why use the OMOP-CDM](fig/Why-CDM.png)

Once a database has been converted to the OMOP CDM, evidence can be generated using standardized analytics tools. This means that different tools can also be shared and reused. So using OMOP can help make your research FAIR.

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Check that everyone knows what FAIR stands for

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Some simple tables
### Loading Data

Now that we are set up with an Rstudio project, we are sure that the
data and scripts we are using are all in our working directory.
The data files should be located in the directory `data`, inside the working
directory. Now we can load the data into R, there are three data files `person.csv`, `condition_occurrence.csv` and `drug_exposure.csv`. Read each of these into a table with the same name.

::::::::::::::::::::::::::::::::::::: group-tab

### Experienced

Use the function read.csv.

### Need a reminder
The expression `read.csv(...)` is a [function call](../learners/reference.md#function-call) that asks R to run the function `read.csv`.

`read.csv` has two [arguments](../learners/reference.md#argument): the name of the file we want to read, and whether the first line of the file contains names for the columns of data.

The filename needs to be a character string (or [string](../learners/reference.md#string) for short), so we put it in quotes. Assigning the second argument, `header`, to be `FALSE` indicates that the data file does not have column headers.  
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 
## Read the Data

There are three data files `person.csv`, `condition_occurrence.csv` and `drug_exposure.csv`. Read each of these into a table with the same name.

NOTE: The data does have headers.

:::::::::::::::::::::::: solution 

``` r
person <- read.csv(file = "data/person.csv", header = TRUE)
condition_occurrence <- read.csv(file = "data/condition_occurrence.csv", header = TRUE)
drug_exposure <- read.csv(file = "data/drug_exposure.csv", header = TRUE)
```
::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::

When you have read in the data, take some time to explore it.


## Adding concept names

You will have noticed that content of the tables are not terribly easy to understand. This is because everything in OMOP is viewed as a concept that allows it to be related to one or more standard vocabularies such as SNOMED, ICD-10, etc.

We have developed a package that makes it very easy to add concept names to the tables. 

You will need the function omopcept::omop_join_name_all(). This will look up the concept_id in the main table of concepts and add a column for the name of the concept associated with that id.

::::::::::::::::::::::::::::::::::::: challenge 

## Who's who?

By creating tables that also have the name of the concepts answer the following questions 

1. How old is the black gentleman?
2. In which month was an unspecified fever prevalent in the hospital?
3. What was the ethnicity of the patient not affected by this fever?
4. Give a description of the patient who received Amoxicillin because they were wheezing?

:::::::::::::::::::::::: hint 

``` r
person_named <- person |> omop_join_name_all()
```

``` error
Error in omop_join_name_all(person): could not find function "omop_join_name_all"
```

``` r
condition_occurrence_named <- condition_occurrence |> omop_join_name_all()
```

``` error
Error in omop_join_name_all(condition_occurrence): could not find function "omop_join_name_all"
```

``` r
drug_exposure_named <- person |> omop_join_name_all()
```

``` error
Error in omop_join_name_all(person): could not find function "omop_join_name_all"
```
::::::::::::::::::::::::::::::::
 
:::::::::::::::::::::::: solution 

1. 25 (or 24 if he hasn't had his birthday this year)
2. July
3. Don't know - it hasn't been specified
4. A 53/54 white female
::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::


## Joining and interrogating the tables

### Using `join`

We established when looking at the diagram that the person table was the key to accessing all the other tables. In fact it is the person_id column that is the actual key that will allow us to join with other tables.

So we can join two of the tables together to get information about the different conditions suffered by each person.

[R documentation - join][join]

I am going to use a left join because I want a record of every person and the conditions they may have.


``` r
person_condition <- 
  person_named |> 
  left_join(condition_occurrence_named, by = join_by(person_id) )
```

``` error
Error in left_join(person_named, condition_occurrence_named, by = join_by(person_id)): could not find function "left_join"
```
This produces a new table with all the column names from both tables and six rows.

### Using `count`

::::::::::::::::::::::::::::::::::::: group-tab
### Experienced

You know what count is

### Need a reminder

count: Count observations by group
Description
count() lets you quickly count the unique values of one or more variables: 
df |> count(a, b)

:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 
Count the number of people with each condition

:::::::::::::::::::::::: solution 

``` r
person_condition |> count(gender_concept_name, condition_concept_name)
```

``` error
Error in count(person_condition, gender_concept_name, condition_concept_name): could not find function "count"
```
:::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

This produces a table:

![A table of the condition counts](fig/condition_count.png)

::::::::::::::::::::::::::::::::::::: group-tab
### Happy-ish

Solve the questions in Who's who programmatically.

### Confident
The CDMConnector package allows connection to an OMOP Common Data Model in a database it also contains synthetic example data that can be used to demonstrate querying the data


``` r
install.packages("CDMConnector")
```

``` output
The following package(s) will be installed:
- CDMConnector [2.1.0]
These packages will be installed into "~/work/omop-carpentries/omop-carpentries/renv/profiles/lesson-requirements/renv/library/linux-ubuntu-jammy/R-4.5/x86_64-pc-linux-gnu".

# Installing packages --------------------------------------------------------
- Installing CDMConnector ...                   OK [linked from cache]
Successfully installed 1 package in 5.3 milliseconds.
```

``` r
library(CDMConnector)
```

A set of synthetic example data is called Eunomia and one example called GiBleed contains 2,600 patients representing a gastrointestinal bleeding study

Download these data

``` r
dbName <- "GiBleed"
CDMConnector::requireEunomia(datasetName = dbName)
```

``` output
ℹ `EUNOMIA_DATA_FOLDER` set to: '/tmp/Rtmp0TTzPR'.
```

``` output

Download completed!
```

We can use the DBI & duckdb packages to connect to this local database

``` r
db <- DBI::dbConnect(duckdb::duckdb(), dbdir = CDMConnector::eunomiaDir(datasetName = dbName))
```

``` output
Creating CDM database /tmp/Rtmp0TTzPR/GiBleed_5.3.zip
```

Databases are organised into structures called schemas usually in an omop database we would have two schemas
1. cdm schema : containing the Common Data Model tables that have read-only access
2. write schema : a place where tables can be written

The Eunomia example data just has a single schema (called main) that we can use for both.

This is how we make a CDM reference from the database connection we made above.

``` r
cdm <- CDMConnector::cdmFromCon(con = db, cdmSchema = "main", writeSchema = "main") 
```

The data themselves are not actually read into the created cdm object.
Rather it is a reference that allows us to query the data from the database.

Typing `cdm` will give a summary of the tables in the database 

``` r
cdm
```

``` output

```

``` output
── # OMOP CDM reference (duckdb) of Synthea ────────────────────────────────────
```

``` output
• omop tables: person, observation_period, visit_occurrence, visit_detail,
condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
measurement, observation, death, note, note_nlp, specimen, fact_relationship,
location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
condition_era, metadata, cdm_source, concept, vocabulary, domain,
concept_class, concept_relationship, relationship, concept_synonym,
concept_ancestor, source_to_concept_map, drug_strength
```

``` output
• cohort tables: -
```

``` output
• achilles tables: -
```

``` output
• other tables: -
```

You may recognise table names from the simple examples. earlier
e.g. `person`, `condition_occurrence` and `drug_exposure`

You can get a glimpse of the data in each table with cdm$table_name e.g.

``` r
cdm$person
```

``` output
# Source:   table<person> [?? x 18]
# Database: DuckDB v1.3.1 [unknown@Linux 6.8.0-1029-azure:R 4.5.1//tmp/Rtmp0TTzPR/file2d9dc1cc992.duckdb]
   person_id gender_concept_id year_of_birth month_of_birth day_of_birth
       <int>             <int>         <int>          <int>        <int>
 1         6              8532          1963             12           31
 2       123              8507          1950              4           12
 3       129              8507          1974             10            7
 4        16              8532          1971             10           13
 5        65              8532          1967              3           31
 6        74              8532          1972              1            5
 7        42              8532          1909             11            2
 8       187              8507          1945              7           23
 9        18              8532          1965             11           17
10       111              8532          1975              5            2
# ℹ more rows
# ℹ 13 more variables: birth_datetime <dttm>, race_concept_id <int>,
#   ethnicity_concept_id <int>, location_id <int>, provider_id <int>,
#   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
#   gender_source_concept_id <int>, race_source_value <chr>,
#   race_source_concept_id <int>, ethnicity_source_value <chr>,
#   ethnicity_source_concept_id <int>
```

``` r
cdm$condition_occurrence
```

``` output
# Source:   table<condition_occurrence> [?? x 16]
# Database: DuckDB v1.3.1 [unknown@Linux 6.8.0-1029-azure:R 4.5.1//tmp/Rtmp0TTzPR/file2d9dc1cc992.duckdb]
   condition_occurrence_id person_id condition_concept_id condition_start_date
                     <int>     <int>                <int> <date>              
 1                    4483       263              4112343 2015-10-02          
 2                    4657       273               192671 2011-10-10          
 3                    4815       283                28060 1984-02-15          
 4                    4981       293               378001 2005-11-07          
 5                    5153       304               257012 1974-07-30          
 6                    5313       312              4134304 1991-05-14          
 7                    5513       326                28060 1979-09-23          
 8                    5655       334             40481087 1999-07-12          
 9                    5811       341             40481087 1990-09-14          
10                    5977       351             40481087 1986-02-24          
# ℹ more rows
# ℹ 12 more variables: condition_start_datetime <dttm>,
#   condition_end_date <date>, condition_end_datetime <dttm>,
#   condition_type_concept_id <int>, condition_status_concept_id <int>,
#   stop_reason <chr>, provider_id <int>, visit_occurrence_id <int>,
#   visit_detail_id <int>, condition_source_value <chr>,
#   condition_source_concept_id <int>, condition_status_source_value <chr>
```

The names of the columns in each table can be seen with `colnames()`

``` r
colnames(cdm$condition_occurrence)
```

``` output
 [1] "condition_occurrence_id"       "person_id"                    
 [3] "condition_concept_id"          "condition_start_date"         
 [5] "condition_start_datetime"      "condition_end_date"           
 [7] "condition_end_datetime"        "condition_type_concept_id"    
 [9] "condition_status_concept_id"   "stop_reason"                  
[11] "provider_id"                   "visit_occurrence_id"          
[13] "visit_detail_id"               "condition_source_value"       
[15] "condition_source_concept_id"   "condition_status_source_value"
```

If you are familiar with commands from the dplyr and tidyverse packages these can be used on the cdm reference

``` r
library(dplyr)
```

``` output

Attaching package: 'dplyr'
```

``` output
The following objects are masked from 'package:stats':

    filter, lag
```

``` output
The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
```

For example this code counts the number of records per condition. 
Using collect() at the end performs the final database query and brings the data into R.

``` r
cdm$condition_occurrence |> 
  count(condition_concept_id, sort=TRUE) |> 
  collect() 
```

``` output
# A tibble: 80 × 2
   condition_concept_id     n
                  <int> <dbl>
 1             40481087 17268
 2              4112343 10217
 3               260139  8184
 4               372328  3605
 5                80180  2694
 6                28060  2656
 7                81151  1915
 8               378001  1013
 9              4283893  1001
10              4294548   939
# ℹ 70 more rows
```

The command above gives us a list of concept ids. To get the names of the conditions you can use the omopcept package as before.

fixme

Alternatively using CDMConnector also gives us access to a table called `concept` that can be used to join on the concept names. 
NOTE: Because of the way `join` works, it is easier to `arrange` the table after it is collected.

``` r
cdm$condition_occurrence |> 
  count(condition_concept_id) |> 
  left_join(select(cdm$concept, concept_id, concept_name),
                   by = join_by(condition_concept_id == concept_id)) |>
  collect() |> 
  arrange(desc(n))
```

``` output
# A tibble: 80 × 3
   condition_concept_id     n concept_name                            
                  <int> <dbl> <chr>                                   
 1             40481087 17268 Viral sinusitis                         
 2              4112343 10217 Acute viral pharyngitis                 
 3               260139  8184 Acute bronchitis                        
 4               372328  3605 Otitis media                            
 5                80180  2694 Osteoarthritis                          
 6                28060  2656 Streptococcal sore throat               
 7                81151  1915 Sprain of ankle                         
 8               378001  1013 Concussion with no loss of consciousness
 9              4283893  1001 Sinusitis                               
10              4294548   939 Acute bacterial sinusitis               
# ℹ 70 more rows
```
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 
For the Confident
Using the "GiBleed" database work out the number of male and female patients with each condition_concept_id

:::::::::::::::::::::::: solution 
to be done
:::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 
Solutions for working out Who's who programmatically.

:::::::::::::::::::::::: solution 
to be done
:::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Using a standard makes it much easier to share data
- OMOP uses concepts to link dated to standard vocabularies
- R can be used to join and interrogate data

::::::::::::::::::::::::::::::::::::::::::::::::

[join](https://www.rdocumentation.org/packages/dplyr/versions/0.7.8/topics/join)
