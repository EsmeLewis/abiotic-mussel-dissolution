[README.md](https://github.com/user-attachments/files/27658125/README.1.md)
# Data from: Shell dissolution rates differ fourfold between mussel species

Dataset DOI: [10.5061/dryad.6hdr7srck](10.5061/dryad.6hdr7srck)

## Description of the data and file structure

Abiotic dissolution in sealed and unsealed interior shells of *Mytilus trossulus* and *Mytilus californianus*.

## Files and variables

#### File: abiotic_dissolution_Mtrossulus_Mcalifornianus.csv

**Description:** We measured abiotic dissolution in sealed and unsealed interior shells of *Mytilus trossulus* and *Mytilus californianus*. *Mytilus trossulus* and *Mytilus californianus* shells were exposed to a range of pH values (6.5–9.3) and aragonite saturation states (Ωₐ = 0.1–9.0). To assess the relative contribution of the inner and outer shell layers to dissolution, both sealed and unsealed shells were tested.

##### Variables

* *shell.number*: unique ID assigned to each shell for tracking purposes
* *treatment*: Unpainted shells were labeled as shell.trossulus or shell.californianus, depending on species. Painted shells were labeled as shell.trossulus.painted or shell.californianus.painted 
* *G*: rate of abiotic dissolution (umol/hr/g)
* *OmegaAragonite*: Aragonite saturation calculated with seacarb in R
* *duration*: length of incubation time (hours)
* *shell.wt*: weight of shell (g)
* *shell.length*: length of shell (mm)

## Code/software

#### File: abiotic_dissolution_analysis.R

**Code/Software Description:** The R analysis code is abiotic_dissolution_analysis.R and can be used to generate the statistics and figures in our manuscript. We used R v 4.5.0. Necessary packages are listed in the code: tidyverse, sf, purrr, ggplot2, car, rcompanion. 

## Access information

Other publicly accessible locations of the data:

* [https://github.com/rrcarlson/trossulus](https://github.com/rrcarlson/trossulus)

Data was derived from the following sources:

* Saley A, Gaylord B. Lab incubations of mussels (Mytilus californianus) examining the influence of periostracum cover and pH on external shell dissolution at Marshall Gulch Beach, CA from August 2021 to March 2022 [[http://lod.bco-dmo.org/id/dataset/935476](http://lod.bco-dmo.org/id/dataset/935476)]. Version 1. Woods Hole (MA): Biological and Chemical Oceanography Data Management Office (BCO-DMO); 2024 Dec 28.[ https://doi.org/10.26008/1912/bco-dmo.935476.1](https://doi.org/10.26008/1912/bco-dmo.935476.1) 
