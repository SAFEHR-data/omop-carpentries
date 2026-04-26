---
title: "Exploring OMOP concepts with R"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- Find the `vocabulary`, `domain` and `concept_class` for a given `concept_id`
- Establish whether a `concept_id` is a standard concept
- Find all concepts within a given domain
- Find all concepts within a given vocabulary


::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand that concepts have additional attributes such as vocabulary, domain, classand standard concept status
- Use R to query the `concept` table for specific attributes of concepts
- Filter concepts based on domain, vocabulary and class
- Identify standard concepts within the OMOP vocabulary

::::::::::::::::::::::::::::::::::::::::::::::::


## Introduction

The primary purpose of the `concept` table is to provide a standardised representation of medical Concepts, allowing for consistent querying and analysis across healthcare databases. Users can join the `concept` table with other tables in the CDM to enrich clinical data with Concept information or use the `concept` table as a reference for mapping clinical data from source terminologies to Standard or other Concepts.

An OMOP `concept_id` is a unique integer identifier. These are defined in the OMOP `concept` table with a corresponding name and other attributes. OMOP contains concept_ids for other medical vocabularies such as SNOMED and LOINC, which OMOP terms as source vocabularies.

Nearly everything in a hospital can be represented by an OMOP `concept_id`.


## Looking up OMOP concepts

OMOP concepts can be looked up in [Athena](https://athena.ohdsi.org) an online tool provided by [OHDSI](https://www.ohdsi.org/) (Observational Health Data Sciences and Informatics, a collaboration that continues to develop OMOP).

The CDMConnector package allows connection to an OMOP Common Data Model in a database. It also contains synthetic example data that can be used to demonstrate querying the data.


In the previous episode we set up the CDMConnector package to connect to an OMOP Common Data Model database and used it to look at the concepts table. We also created the function `get_concept_name()` to get a humanly readable name for a `concept_id`. We will use these again in this episode.

### Setting up the connection


``` r
library(CDMConnector)
library(dplyr)

db_name <- "GiBleed"
CDMConnector::requireEunomia(datasetName = db_name)

db <- DBI::dbConnect(duckdb::duckdb(),
                     dbdir = CDMConnector::eunomiaDir(datasetName = db_name))

cdm <- CDMConnector::cdmFromCon(con = db, cdmSchema = "main",
                                writeSchema = "main")
```

## Exploring the `concept` table

``` r
colnames(cdm$concept)
```

``` output
 [1] "concept_id"       "concept_name"     "domain_id"        "vocabulary_id"   
 [5] "concept_class_id" "standard_concept" "concept_code"     "valid_start_date"
 [9] "valid_end_date"   "invalid_reason"  
```

### The `concept` table contains the following columns:
| Column Names          | Description of content |
|-----------------------|---------------------------------------|
| **concept_id**            | Unique identifier for the concept. |
| **concept_name**        | Name or description of the concept. |
| **domain_id**            | The domain to which the concept belongs (e.g. Condition, Drug). |
| **vocabulary_id**         | The vocabulary from which the concept originates (e.g. SNOMED, RxNorm). |
| **concept_class_id**      | Classification within the vocabulary (e.g. Clinical Finding, Ingredient). |
| **standard_concept**      | 'S' for standard concepts that come from internationally accepted standard vocabularies. |
| **concept_code**          | Code used by the source vocabulary to identify the concept. |
| **valid_start_date**      | Date the concept became valid in OMOP. |
| **valid_end_date**        | Date the concept ceased to be valid. |
| **invalid_reason**        | Reason for invalidation, if applicable. | 


The `concept` table is the main table for looking up information about concepts. We can use R to query the `concept` table for specific attributes of concepts.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

Answer the following questions using R and the `concept` table:

1. How many entries are there in the `concept` table?

2. How many distinct vocabularies are there in the `concept` table?

3. How many distinct domains other than 'None' are there in the `concept` table?

4. How many distinct concept_classes are there in the `concept` table?

::::::::::::::::::::::::::::::::::::::::::::::::::: solution

1. How many entries are there in the `concept` table?

``` r
cdm$concept |>
  summarise(n_concepts = n()) |>
  collect()
```

``` output
# A tibble: 1 × 1
  n_concepts
       <dbl>
1        444
```

***Answer:*** There are 444 entries in the `concept` table. This is a tiny fraction of the overall table which can be found at [Athena](https://athena.ohdsi.org)

**CODING_NOTE**: The function `n()` counts the number of rows in the table and `summarise()` creates a summary table with that count. These functions are part of the `dplyr` package. When you have loaded the library once your environment will remember it for the rest of the session.
We are also using `collect` at the end of the pipe to ensure that the data is converted to a local object in R. You can get away without using it at this stage, as R works out that you are getting a single value, but you will often need to use `collect` with database connections.

2. How many distinct vocabularies are there in the `concept` table?

``` r
cdm$concept |>
  summarise(n_distinct_vocabularies = n_distinct(vocabulary_id)) |>
  collect()
```

``` output
# A tibble: 1 × 1
  n_distinct_vocabularies
                    <dbl>
1                       9
```

***Answer:*** There are 9 distinct vocabularies used in this dataset.

**CODING_NOTE**: The function `n_distinct(x)` counts the number of distinct values in the column x.

3. How many distinct domains other than 'None' are there in the `concept` table?

``` r
cdm$concept |>
  filter(domain_id != "None") |>
  summarise(n_distinct_domains = n_distinct(domain_id)) |>
  collect()
```

``` output
# A tibble: 1 × 1
  n_distinct_domains
               <dbl>
1                  8
```

***Answer:*** There are 8 distinct domains other than 'None' in this dataset.    

**CODING_NOTE**: We use the `filter()` function to filter out rows where the domain_id is 'None' before counting the distinct domains.

4. How many distinct concept_classes are there in the `concept` table?

``` r
cdm$concept |>
  summarise(n_distinct_concept_classes = n_distinct(concept_class_id)) |>
  collect()
```

``` output
# A tibble: 1 × 1
  n_distinct_concept_classes
                       <dbl>
1                         21
```

***Answer:*** There are 21 distinct concept_classes used in this dataset.

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

## Filtering concepts by domain, vocabulary, class and standard concept status

Let's look into filtering concepts based on their domain, vocabulary, concept_class and standard_concept status.


::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

List the first ten rows of the `concept table`, ordered by `concept_id`. List only the `concept_id`, `domain_id`, `vocabulary_id`, `concept_class_id` and `standard_concept` columns. 

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
cdm$concept |>
  arrange(concept_id) |>
  filter(row_number() <= 10) |>
  select(concept_id,
         domain_id,
         vocabulary_id,
         concept_class_id,
         standard_concept) |>
  collect()
```

``` output
# A tibble: 10 × 5
   concept_id domain_id vocabulary_id concept_class_id standard_concept
        <int> <chr>     <chr>         <chr>            <chr>           
 1          0 Metadata  None          Undefined        <NA>            
 2       8507 Gender    Gender        Gender           S               
 3       8532 Gender    Gender        Gender           S               
 4       9201 Visit     Visit         Visit            S               
 5       9202 Visit     Visit         Visit            S               
 6       9203 Visit     Visit         Visit            S               
 7      28060 Condition SNOMED        Clinical Finding S               
 8      30753 Condition SNOMED        Clinical Finding S               
 9      78272 Condition SNOMED        Clinical Finding S               
10      80180 Condition SNOMED        Clinical Finding S               
```

**CODING_NOTE**: The `arrange()` function orders the rows by `concept_id`. The `filter(row_number() <= 10)` function filters to the first 10 rows. The `select()` function selects only the specified columns. We have to use `collect()` to pull the data into R memory to view it. This is because we are querying a remote database, rather than a local object. In the previous challenge R would figure out that it should display the calculated result, but here we need to be explicit. 

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::


### Look at vocabularies

Vocabulary: The source or system of coding for concepts, such as SNOMED, RxNorm, LOINC, or ICD‑10. OMOP maps many vocabularies into a common, standardised set so different coding systems can be analysed together.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

List all distinct vocabularies in the `concept` table.

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
cdm$concept |>
  filter(!is.na(vocabulary_id)) |>
  distinct(vocabulary_id) |>
  arrange(vocabulary_id) |>
  pull(vocabulary_id)
```

``` output
[1] "RxNorm"  "CVX"     "SNOMED"  "None"    "Gender"  "ICD10CM" "LOINC"  
[8] "NDC"     "Visit"  
```

**CODING_NOTE**: Here we can use `pull(x)` to pull the data x into R memory to view it. This is because we are only requiring one column of data, so we can pull that column directly into R memory without needing to use `collect()` first.

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

### Look at domains
 
 Domain: A high‑level category that groups concepts by what they represent in clinical data, such as Condition, Drug, Procedure, Measurement, or Observation. A concept’s domain determines which OMOP table it belongs to and how it’s used analytically.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

List all distinct domains in the `concept` table.

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
cdm$concept |>
  filter(!is.na(domain_id)) |>
  distinct(domain_id) |>
  arrange(domain_id) |>
  pull(domain_id)
```

``` output
[1] "Drug"        "Measurement" "Condition"   "Procedure"   "Observation"
[6] "Visit"       "Metadata"    "Gender"     
```

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

### Look at concept classes
 
 Class: A more detailed category that groups concepts within a domain by what they represent in clinical data.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

List all distinct concept_classes in the `concept` table that are in the "Drug" domain.

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
cdm$concept |>
  filter(domain_id == "Drug") |>
  filter(!is.na(concept_class_id)) |>
  distinct(concept_class_id) |>
  arrange(concept_class_id) |>
  pull(concept_class_id)
```

``` output
 [1] "Branded Drug"        "Quant Branded Drug"  "Branded Drug Comp"  
 [4] "Clinical Drug"       "Quant Clinical Drug" "CVX"                
 [7] "Ingredient"          "11-digit NDC"        "Branded Pack"       
[10] "Clinical Drug Comp" 
```

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

### Look at non standard concepts

A standard concept is the preferred, harmonised code in OMOP that represents a clinical idea across vocabularies. Standard concepts (standard_concept = "S") are the target of mappings from source codes, and they define which domain and table the data belong to for consistent analysis. However, OMOP also include nonstandard concepts from sources that are not globally used but maybe useful locally. `dm+d`, the NHS Dictionary of Medicines and Devices is one such vocabulary that is included in OMOP but is not a standard vocabulary.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

Find any nonstandard concepts (i.e. concepts where standard_concept is not 'S') by filtering the concept table. List the first 10 `concept_id`s of nonstandard concepts.
Then look up their concept_name, domain_id, vocabulary_id and standard_concept status.

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
cdm$concept |>
  filter(is.na(standard_concept) | standard_concept != "S") |>
  slice_min(order_by = concept_id, n = 10, with_ties = FALSE) |>
  pull(concept_id)
```

``` output
[1]        0  1569708 35208414 44923712 45011828
```

***Answer:*** There are only four nonstandard concepts in this dataset: **1569708**, **35208414**, **44923712**, **45011828**.

**CODING_NOTE**: We use `slice_min()` to get the first 10 rows which match the filter, ordered by `concept_id`.


``` r
cdm$concept |>
  filter(concept_id %in% c(1569708, 35208414, 44923712, 45011828)) |>
  select(concept_id,
         concept_name,
         domain_id,
         vocabulary_id,
         standard_concept) |>
  collect()
```

``` output
# A tibble: 4 × 5
  concept_id concept_name               domain_id vocabulary_id standard_concept
       <int> <chr>                      <chr>     <chr>         <chr>           
1   35208414 Gastrointestinal hemorrha… Condition ICD10CM       <NA>            
2   44923712 celecoxib 200 MG Oral Cap… Drug      NDC           <NA>            
3    1569708 Other diseases of digesti… Condition ICD10CM       <NA>            
4   45011828 Diclofenac Sodium 75 MG D… Drug      NDC           <NA>            
```

**CODING_NOTE**: We use `%in%` to filter for multiple `concept_id`s which we can list in a vector.
:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

Now you should be able to replicate our get_concept_name() function to look up other attributes of concepts such as domain, vocabulary and standard concept status.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge

Find the domain,vocabulary and concept class for `concept_id` **35208414**

Is this concept a standard concept?

::::::::::::::::::::::::::::::::::::::::::::::::::: solution


``` r
get_concept_domain <- function(cdm_obj, id) {
  cdm_obj$concept |>
    filter(concept_id == id) |>
    select(domain_id) |>
    pull()
}

get_concept_vocabulary <- function(cdm_obj, id) {
  cdm_obj$concept |>
    filter(concept_id == id) |>
    select(vocabulary_id) |>
    pull()
}

get_concept_concept_class <- function(cdm_obj, id) {
  cdm_obj$concept |>
    filter(concept_id == id) |>
    select(concept_class_id) |>
    pull()
}

get_concept_standard_status <- function(cdm_obj, id) {
  cdm_obj$concept |>
    filter(concept_id == id) |>
    select(standard_concept) |>
    pull()
}

get_concept_domain(cdm, 35208414)
```

``` output
[1] "Condition"
```

``` r
get_concept_vocabulary(cdm, 35208414)
```

``` output
[1] "ICD10CM"
```

``` r
get_concept_concept_class(cdm, 35208414)
```

``` output
[1] "4-char billing code"
```

``` r
get_concept_standard_status(cdm, 35208414)
```

``` output
[1] NA
```

***Answer:***

- The domain for `concept_id` **319835** is 'Condition'.
- The vocabulary for `concept_id` **319835** is 'ICD10CM'.
- The concept class for concept id **319835** is '4-char billing code'
- This concept is not a standard concept (standard_concept = 'NA').

:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Concepts have additional attributes such as vocabulary, domain, and standard concept status
- The `concept` table can be queried using R to retrieve specific attributes of concepts
- Concepts can be filtered based on their domain, vocabulary and class
- Standard concepts are those that are recommended for use in analyses within the OMOP framework

::::::::::::::::::::::::::::::::::::::::::::::::
