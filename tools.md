---
title: "Community provided software for working with OMOP data"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are some of the R tools that can work on OMOP CDM instances ?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Brief outline of some R tools that will be useful for new OMOP users.
- Use Athena and other OHDSI tools for reference
- Describe the full landscape of OMOP tools and the community

::::::::::::::::::::::::::::::::::::::::::::::::



## Introduction

There are a range of community provided R tools that can help you work with instances of OMOP data.

We are going to show you a brief summary of some that are likely to be of use to new users.

With each you may need to balance the need to learn some new syntax with the benefits of the extra functionality that the package provides.


TODO maybe add a table with links to packages & brief descriptions.

* [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html)
To summarise an OMOP database.

* [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/)
To generate lists of OMOP concepts.


[OmopSketch](https://ohdsi.github.io/OmopSketch/index.html)
To summarise key information about an OMOP database.
To provide a broad characterisation of the data and to allow users to evaluate whether they are suitable for particular research.



  
First we can install the package and its dependencies and connect to some mock data.


``` r
#without dependencies=TRUE it failed needing omock & VisOmopResults
#with dependencies it installed 91 packages in 1.8 minutes
install.packages("OmopSketch", dependencies=TRUE, quiet=TRUE)

library(dplyr)
library(OmopSketch)

# Connect to mock database
cdm <- mockOmopSketch()
```

``` error
Error in `mockVocabularySet()`:
✖ `datasetName` a choice between: GiBleed, empty_cdm, synpuf-1k_5.3,
  synpuf-1k_5.4, synthea-allergies-10k, synthea-anemia-10k,
  synthea-breast_cancer-10k, synthea-contraceptives-10k, synthea-covid19-10k,
  synthea-covid19-200k, synthea-dermatitis-10k, synthea-heart-10k,
  synthea-hiv-10k, synthea-lung_cancer-10k, synthea-medications-10k,
  synthea-metabolic_syndrome-10k, synthea-opioid_addiction-10k,
  synthea-rheumatoid_arthritis-10k, …, synthea-veterans-10k, and
  synthea-weight_loss-10k.
! `datasetName` must be a choice between: GiBleed, empty_cdm, synpuf-1k_5.3,
  synpuf-1k_5.4, synthea-allergies-10k, synthea-anemia-10k,
  synthea-breast_cancer-10k, synthea-contraceptives-10k, synthea-covid19-10k,
  synthea-covid19-200k, synthea-dermatitis-10k, synthea-heart-10k,
  synthea-hiv-10k, synthea-lung_cancer-10k, synthea-medications-10k,
  synthea-metabolic_syndrome-10k, synthea-opioid_addiction-10k,
  synthea-rheumatoid_arthritis-10k, …, synthea-veterans-10k, and
  synthea-weight_loss-10k; with length = 1; it can not contain NA; it can not
  be NULL.
```

#### summarise* and table* functions

The package has the following types of functions :

function start | what it does
------------ | --------------------
summarise*   | generate results objects.
table*       | convert results objects to tables for display.

### Snapshot

Snapshot creates a broad summary of the database including person count, temporal extent and other metadata.


``` r
summariseOmopSnapshot(cdm) |>
  tableOmopSnapshot(type = "gt")
```

``` error
Error: object 'cdm' not found
```

### Missing data

Summarise missing data in each column of one or many cdm tables.


``` r
missingData <- summariseMissingData(cdm, c("drug_exposure"))
```

``` error
Error: object 'cdm' not found
```

``` r
tableMissingData(missingData)
```

``` error
Error: object 'missingData' not found
```

### Clinical Records

Allows you to summarise omop tables from a cdm. By default it gives measures including records per person, how many concepts are standard and source vocabularies.


``` r
summariseClinicalRecords(cdm, "condition_occurrence") |>
  tableClinicalRecords(type = "gt")
```

``` error
Error: object 'cdm' not found
```


You can also 

* apply to more than one table at a time
* reduce the measures of records per person
* reduce the number of rows by setting options to FALSE
* stratify by sex and/or age
* set a date range


``` r
summariseClinicalRecords(cdm, c("drug_exposure","measurement"),
                         recordsPerPerson = c("mean", "sd"),
                         inObservation = FALSE,
                         standardConcept = FALSE,
                         sourceVocabulary = FALSE,
                         domainId = FALSE,
                         typeConcept = FALSE,
                         sex = TRUE) |> 
                     tableClinicalRecords(type = "gt")
```

``` error
Error: object 'cdm' not found
```

### Record counts over time

You can plot the number of records over time for any cdm table also stratified by age and sex (so behind the scenes this will be joining clinical tables to the person table).


``` r
recordCount <- summariseRecordCount(cdm, 
                                    omopTableName =  "drug_exposure",
                                    interval = "years",
                                    sex = TRUE,
                                    ageGroup =  list("<40" = c(0,39), ">=40" = c(40, Inf)),
                                    dateRange = as.Date(c("2002-01-01", NA))) 
```

``` error
Error: object 'cdm' not found
```

``` r
plotRecordCount(recordCount, facet = "sex", colour = "age_group")
```

``` error
Error: object 'recordCount' not found
```

### Concept Id counts

You can get a summary of the numbers of concept ids in a cdm table. Unfortuntaely the summary doesn't display here but you can copy and paste the code into your console to see it.


``` r
result <- summariseConceptIdCounts(cdm = cdm, omopTableName = "condition_occurrence")
```

``` error
Error: object 'cdm' not found
```

``` r
tableConceptIdCounts(head(result,5), display = "standard", type = "datatable")
```

``` error
Error: object 'result' not found
```




::::::::::::::::::::::::::::::::::::: keypoints 

- Brief outline of some R tools that will be useful for new OMOP users.

::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/
