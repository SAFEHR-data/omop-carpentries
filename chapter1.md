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


## Challenge 2: how do you nest solutions within challenge blocks?

:::::::::::::::::::::::: solution 

You can add a line with at least three colons and a `solution` tag.

:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

## Figures

You can also include figures generated from R Markdown:


``` r
pie(
  c(Sky = 78, "Sunny side of pyramid" = 17, "Shady side of pyramid" = 5), 
  init.angle = 315, 
  col = c("deepskyblue", "yellow", "yellow3"), 
  border = FALSE
)
```

<div class="figure" style="text-align: center">
<img src="fig/chapter1-rendered-pyramid-1.png" alt="pie chart illusion of a pyramid"  />
<p class="caption">Sun arise each and every morning</p>
</div>

Or you can use standard markdown for static figures with the following syntax:

`![optional caption that appears below the figure](figure url){alt='alt text for
accessibility purposes'}`

![You belong in The Carpentries!](https://raw.githubusercontent.com/carpentries/logo/master/Badge_Carpentries.svg){alt='Blue Carpentries hex person logo with no text.'}

::::::::::::::::::::::::::::::::::::: callout

Callout sections can highlight information.

They are sometimes used to emphasise particularly important points
but are also used in some lessons to present "asides": 
content that is not central to the narrative of the lesson,
e.g. by providing the answer to a commonly-asked question.

::::::::::::::::::::::::::::::::::::::::::::::::


## Math

One of our episodes contains $\LaTeX$ equations when describing how to create
dynamic reports with {knitr}, so we now use mathjax to describe this:

`$\alpha = \dfrac{1}{(1 - \beta)^2}$` becomes: $\alpha = \dfrac{1}{(1 - \beta)^2}$

Cool, right?

::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/
