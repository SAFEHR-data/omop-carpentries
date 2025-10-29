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


TODO provide a challenge to look up a concept in Athena
TODO add a challenge to look up the same concept in one of the synthea datasets
TODO add briefly about concept relationships

TODO ? add about the condition_occurrence table to make the episode longer and give something for concept to refer to


::::::::::::::::::::::::::::::::::::: keypoints 

- Understand that nearly everything in a hospital can be represented by an OMOP concept_id.
- Know that OMOP data usually includes the OMOP concept table and other data from the vocabularies
- Be able to look up concepts by their name
- Know that patient conditions are stored in the condition_occurrence table


::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/
