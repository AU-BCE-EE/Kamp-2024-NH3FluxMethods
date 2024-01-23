# Download ALFAM2 data, subset to this study, and save copy
# This is only run when a new version of measurement data is needed (e.g., when corrections have been submitted to ALFAM2 database)

rm(list = ls())

## Set release tag for download
#ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/'
#rtag <- 'v2.23'

# Or, use specific commit
ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/4601e21737c1bed42d6edf6340c6edd798a2a59f/'
rtag <- ''

source('packages.R')
source('functions.R')
source('load.R')
source('subset.R')
source('export.R')
