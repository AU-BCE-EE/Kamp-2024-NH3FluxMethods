# Kamp-2023-NH3FluxMethods
Flux measurements after slurry application in two experiments. The following methods were used: bLS, WT, IHF, DTM, Alpha

# Maintainer
Jesper Nørlem Kamp.
Contact information here: <http://www.au.dk/jk@bce>.

# Published paper
This repo is associated with the following paper:

Kamp, J.N., ...

(fill in details once published)

# Directory information
## ALFAM2-app
Application of ALFAM2 model to field experiments.
Run `ALFAM2-app/scripts/main.R` in R to run ALFAM2 model using the bLS temporal frequency, and interpolate cumulative emission and flux to the intervals used in the other methods. 
Results are in `ALFAM2-app/output`.

## ALFAM2-data-eGylle
Measurement data downloaded from ALFAM2 database.
R scripts in `scripts` download data, subset, and export to the `ALFAM2-data-eGylle/data` directory.
Run `ALFAM2-data-eGylle/scripts/main.R` to download a new version.

## ALFAM2-app
Application of ALFAM2 model to field trials.
Run `ALFAM2-app/scripts/main.R` to generate predictions.

## rand-eff-models
Random-effects models for measurement error.
Run `rand-eff-models/scripts/main.R` to fit models.

## scripts-WT
R scripts for processing WT data to calculate measured ammonia emission. 
Data files are too large to include but scripts are still included here for partial reproducibility. 
The script 'main.R' calls all others.

## scripts-MatLab
MatLab scripts for plotting all figures. 

## data-MatLab
Data files are too large to include but summary data files are provided here for reproducing figures.

# Links to published paper
This section give the sources of tables, figures, and some statistical results presented in the paper.
See the value under "Repo source" for the results themselves, and "Repo scripts" for the scripts that created the results.

| Paper component                    |  Repo source                             |  Repo scripts                                                            |
|-----------------                   |-----------------                         |---------------                                                           |
|                                    |                                          |                                                                          |
|                                    |                                          |                                                                          |
|                                    |                                          |                                                                          |
|                                    |                                          |                                                                          |
| Sect. 3.1 AER F test, p = 0.0025   | `AER-stats/stats/stats.pdf`              | `AER-stats/scripts/stats.Rmd` (run `AER-stats/scripts/main.R`)           |
| ALFAM2 model predictions           | `ALFAM2-app/output/ALFAM2_emis.csv`      | `ALFAM2-app/scripts/export.R` (run `ALFAM2-app/scripts/main.R`)          |
| All random-effects model results   | `rand-eff-models/stats/mods.md`          | `rand-eff-models/scripts/mods.Rmd` (run `rand-eff-models/scripts/main.R`)|
