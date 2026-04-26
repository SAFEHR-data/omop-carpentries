---
title: 'Glossary'
---

[argument]{#argument}
:   A value given to a function or program when it runs.
    The term is often used interchangeably (and inconsistently) with parameter.

[assign]{#assign}
:   To give a value a name by associating a variable with it.
    In R, this is typically done using the <- operator (e.g., x <- 5).

[body]{#body}
:   (of a function): the statements that are executed when a function runs.

[CDM]{#cdm}
:   Common Data Model - a standardized data structure that organizes healthcare data into a consistent format.
    The OMOP CDM is one of the most widely used healthcare CDMs.

[clinical event]{#clinical-event}
:   Any observation or occurrence in a patient's healthcare journey, such as a diagnosis, procedure, drug exposure, or measurement.

[cohort]{#cohort}
:   A group of patients who share a common characteristic or experience within a defined time period.
    In OMOP, cohorts are often defined using specific inclusion and exclusion criteria.

[comment]{#comment}
:   A remark in a program that is intended to help human readers understand what is going on,
    but is ignored by the computer.
    Comments in R start with a # character and run to the end of the line.

[comma-separated values]{#comma-separated-values}
:   (CSV) A common textual representation for tables
    in which the values in each row are separated by commas.

[concept]{#concept}
:   In OMOP, a standardized clinical term with a unique identifier that represents medical entities like conditions, drugs, or procedures.

[conceptid]{#concept-id}
:   A unique numerical identifier assigned to each concept in the OMOP vocabulary.

[data frame]{#data-frame}
:   In R, a two-dimensional data structure similar to a table or spreadsheet, where each column can contain different data types.

[delimiter]{#delimiter}
:   A character or characters used to separate individual values,
    such as the commas between columns in a CSV file.

[documentation]{#documentation}
:   Human-language text written to explain what software does,
    how it works, or how to use it.

[domain]{#domain}
:   In OMOP, a high-level category that classifies clinical data (e.g., Condition, Drug, Procedure, Measurement).

[EHR]{#ehr}
:   Electronic Health Record - a digital version of a patient's medical history maintained by healthcare providers.

[floating-point number]{#floating-point-number}
:   A number containing a fractional part and an exponent.
    See also: integer.

[for loop]{#for-loop}
:   A loop that is executed once for each value in some kind of set, list, or range.
    See also: while loop.

[function call]{#function-call}
:   A use of a function in another piece of code.

[index]{#index}
:   A subscript that specifies the location of a single value in a collection,
    such as a single pixel in an image or a row in a data frame.

[integer]{#integer}
:   A whole number, such as -12343. See also: floating-point number.

[library]{#library}
:   In R, the directory(ies) where packages are stored.

[observational data]{#observational-data}
:   Healthcare data collected during routine clinical practice, as opposed to data from controlled clinical trials.

[OMOP]{#omop}
:   Observational Medical Outcomes Partnership - a common data model for healthcare data developed to standardize the structure and content of observational data.

[package]{#package}
:   A collection of R functions, data and compiled code in a well-defined format. 
    Packages are stored in a library and loaded using the library() function.

[parameter]{#parameter}
:   A variable named in the function's declaration that is used to hold a value passed into the call.
    The term is often used interchangeably (and inconsistently) with argument.

[personid]{#person-id}
:   A unique identifier for each patient in the OMOP CDM that links all clinical events for an individual across different tables.

[return statement]{#return-statement}
:   A statement that causes a function to stop executing and return a value to its caller immediately.

[sequence]{#sequence}
:   A collection of information that is presented in a specific order.

[shape]{#shape}
:   An array's dimensions, represented as a vector.
    For example, a 5×3 array's shape is (5,3).

[standard concept]{#standard-concept}
:   In OMOP, a concept designated as the preferred term for representing clinical information in analyses.

[string]{#string}
:   Short for "character string",
    a sequence of zero or more characters.

[syntax error]{#syntax-error}
:   A programming error that occurs when statements are in an order or contain characters
    not expected by the programming language.

[tibble]{#tibble}
:   A modern reimagining of the data frame in R (from the tidyverse), with some improved behaviors for displaying and subsetting data.

[type]{#type}
:   The classification of something in a program (for example, the contents of a variable)
    as a kind of number (e.g. floating-point number, integer), string,
    or something else. In R the command typeof() is used to query a variable's type.

[variable]{#variable}
:   A named storage location in a program that can hold a value which may change during program execution.

[vector]{#vector}
:   In R, a basic data structure that contains elements of the same type (e.g., all numbers or all characters).

[vocabulary]{#vocabulary}
:   In OMOP, a standardized terminology system (such as SNOMED, LOINC, or RxNorm) used to code clinical concepts.

[while loop]{#while-loop}
:   A loop that keeps executing as long as some condition is true.
    See also: for loop.
``
