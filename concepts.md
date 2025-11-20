---
title: "concepts and conditions"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is an OMOP concept ?
- Where are patient conditions stored in OMOP ?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand that nearly everything in a hospital can be represented by an OMOP concept_id.
- Know that OMOP data usually includes the OMOP concept table and other data from the vocabularies
- Be able to look up concepts by their name
- Know that patient conditions are stored in the condition_occurrence table

::::::::::::::::::::::::::::::::::::::::::::::::


## Introduction

Nearly everything in a hospital can be represented by an OMOP concept_id.

Any column within the OMOP CDM named `*concept_id` contains OMOP concept IDs. An OMOP concept_id is a unique integer identifier. Concept_ids are defined in the OMOP concept table where a corresponding name and other attributes are stored. OMOP contains concept_ids for other medical vocabularies such as SNOMED and LOINC, which OMOP terms as source vocabularies.

| concept table columns           | Description
|-----------------------|---------------------------------------
| concept_id            | Unique identifier for the concept.
| concept_name          | Name or description of the concept.
| domain_id             | The domain to which the concept belongs (e.g. Condition, Drug).
| vocabulary_id         | The vocabulary from which the concept originates (e.g. SNOMED, RxNorm).
| concept_class_id      | Classification within the vocabulary (e.g. Clinical Finding, Ingredient).
| standard_concept      | 'S' for standard concepts that can be included in network studies
| concept_code          | Code used by the source vocabulary to identify the concept.
| valid_start_date      | Date the concept became valid in OMOP.
| valid_end_date        | Date the concept ceased to be valid.
| invalid_reason        | Reason for invalidation, if applicable 

## Looking up OMOP concepts

OMOP concepts can be looked up in [Athena](https://athena.ohdsi.org) an online tool provided by OHDSI.

The CDMConnector package allows connection to an OMOP Common Data Model in a database. It also contains synthetic example data that can be used to demonstrate querying the data.

::::::::::::::::::::::::::::::::::::::::::::::::::: discussion

In the previous lesson we set up the CDMConnector package to connect to an OMOP Common Data Model database and used it to look at the concepts table.


``` r
library(CDMConnector)

dbName <- "GiBleed"
CDMConnector::requireEunomia(datasetName = dbName)
```

``` output

Download completed!
```

``` r
db <- DBI::dbConnect(duckdb::duckdb(), dbdir = CDMConnector::eunomiaDir(datasetName = dbName))

cdm <- CDMConnector::cdmFromCon(con = db, cdmSchema = "main", writeSchema = "main") 
```

The data themselves are not actually read into the created cdm object.
Rather it is a reference that allows us to query the data from the database.

Typing `cdm` will give a summary of the tables in the database and we can look at these individually using the `$` operator.

``` r
cdm
```


``` r
cdm$person
```

``` output
# Source:   table<person> [?? x 18]
# Database: DuckDB 1.4.2 [unknown@Linux 6.8.0-1041-azure:R 4.5.2//tmp/RtmpqM9C9A/file2b2ee119870.duckdb]
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
:::::::::::::::::::::::::::::::::::::::::::::::::::

Many of the columns in the OMOP CDM tables contain concept_ids. For example the `condition_occurrence` table contains a `condition_concept_id` column that contains the concept_id for the patient's condition.

::::::::::::::::::::::::::::::::::::::::::::::::::: challenge
Using the functions count, filter and select from the dplyr package find

1. How many concepts are included in this dataset?

2. What are the top 5 most common conditions in the `condition_occurrence` table.

3. How many people were born after 1984?

4. How many distinct vocabularies are used in the concept table?

5. (Optional) Look up the concept_id for "Type 2 diabetes mellitus" in Athena. How many people in this dataset have this condition?
::::::::::::::::::::::::::::::::::::::::::::::::::: solution

``` r
library(dplyr)
# 1. How many concepts are included in this dataset?
cdm$concept %>%
  summarise(n = n_distinct(concept_id))
```

``` output
# Source:   SQL [?? x 1]
# Database: DuckDB 1.4.2 [unknown@Linux 6.8.0-1041-azure:R 4.5.2//tmp/RtmpqM9C9A/file2b2ee119870.duckdb]
      n
  <dbl>
1   444
```
Answer: There are 444 concepts in this dataset. Remember it is not the full set of OMOP concepts.

``` r
# 2. What are the top 5 most common conditions in the condition_occurrence table.
cdm$condition_occurrence %>%
  dplyr::count(condition_concept_id, sort = TRUE) %>%                 # creates n
  dplyr::mutate(rn = dplyr::row_number(dplyr::desc(n))) %>%          # window fn
  dplyr::filter(rn <= 5) %>%
  dplyr::left_join(cdm$concept, by = c("condition_concept_id" = "concept_id")) %>%
  dplyr::select(condition_concept_id, concept_name, n) %>%
  dplyr::arrange(dplyr::desc(n))
```

``` output
# Source:     SQL [?? x 3]
# Database:   DuckDB 1.4.2 [unknown@Linux 6.8.0-1041-azure:R 4.5.2//tmp/RtmpqM9C9A/file2b2ee119870.duckdb]
# Ordered by: dplyr::desc(n)
  condition_concept_id concept_name                n
                 <int> <chr>                   <dbl>
1               260139 Acute bronchitis         8184
2             40481087 Viral sinusitis         17268
3               372328 Otitis media             3605
4              4112343 Acute viral pharyngitis 10217
5                80180 Osteoarthritis           2694
```
Answer: The top 5 most common conditions are:   
| condition_concept_id |        concept_name         |   n   |
|----------------------|-----------------------------|-------|
| 260139	 | Acute bronchitis	| 8184		|
| 40481087 |	Viral sinusitis	| 17268		|
| 372328	 | Otitis media	    | 3605		|
| 4112343	| Acute viral pharyngitis	|10217		|
|80180	| Osteoarthritis	     |                      2694	| 



``` r
# 3. How many people were born after 1984?
cdm$person |>
  dplyr::filter(year_of_birth > 1984) |>
  dplyr::count()
```

``` output
# Source:   SQL [?? x 1]
# Database: DuckDB 1.4.2 [unknown@Linux 6.8.0-1041-azure:R 4.5.2//tmp/RtmpqM9C9A/file2b2ee119870.duckdb]
      n
  <dbl>
1     6
```
Answer: There are 6 people born after 1984 in this dataset.

``` r
# 4. How many distinct vocabularies are used in the concept table?
cdm$vocabulary %>% summarise(n_distinct_vocabularies = n_distinct(vocabulary_id ))
```

``` output
# Source:   SQL [?? x 1]
# Database: DuckDB 1.4.2 [unknown@Linux 6.8.0-1041-azure:R 4.5.2//tmp/RtmpqM9C9A/file2b2ee119870.duckdb]
  n_distinct_vocabularies
                    <dbl>
1                     125
```
Answer: There are 125 distinct vocabularies used in this dataset.

:::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::




::::::::::::::::::::::::::::::::::::: keypoints 

- Understand that nearly everything in a hospital can be represented by an OMOP concept_id.
- Know that OMOP data usually includes the OMOP concept table and other data from the vocabularies
- Be able to look up concepts by their name
::::::::::::::::::::::::::::::::::::::::::::::::
