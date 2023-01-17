# Kamp-2023-NH3FluxMethods
Flux measurements after slurry application in two experiments. The following methods were used: bLS, WT, IHF, DTM, Alpha

# Maintainer
Jesper Nørlem Kamp.
Contact information here: <http://www.au.dk/JK@bce>.

# Directory information
## ALFAM2-app
Application of ALFAM2 model to field experiments.
Run `ALFAM2-app/scripts/main.R` in R to run ALFAM2 model using the bLS temporal frequency, and interpolate cumulative emission and flux to the intervals used in the other methods. 
Results are in `ALFAM2-app/output`.

## ALFAM2-var
Quantification of residual variation in the broader ALFAM2 database to estimate the "institutional effect".
ALFAM2 data are in `ALFAM2-var/data-emission`.
Run `ALFAM2-var/data-emission/scripts/main.R` to download a new version.
Run `ALFAM2-var/scripts/main.R` to apply the ALFAM2 model to the measurement data and calculate apparent error (residuals).
Results are summarized in `ALFAM2-var/output`.

