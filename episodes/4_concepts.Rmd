---
title: "OMOP concepts (probably to go before measurement)"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is an OMOP concept ?
- What information is in the OMOP concept table ?
- Where can the OMOP concept table be found ?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand that nearly everything in a hospital can be represented by an OMOP concept_id.

::::::::::::::::::::::::::::::::::::::::::::::::

~~ concept table, part of the vocabularies
~~ what columns ?
~~ Athena
~~ relationships, ancestors, descendants
~~ examples
~~ exercises

## Introduction

Nearly everything in a hospital can be represented by an OMOP concept_id.

Any column within the OMOP CDM named `*concept_id` contains OMOP concept IDs, integer values that are defined in the OMOP concept table where a corresponding name and other attributes are stored. 

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


OMOP concepts can be looked up in [Athena](https://athena.ohdsi.org) an online tool provided by OHDSI.






::::::::::::::::::::::::::::::::::::: keypoints 



::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/
