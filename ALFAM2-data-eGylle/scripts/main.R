# Download ALFAM2 data, subset to this study, and save copy
# This is only run when a new version of measurement data is needed (e.g., when corrections have been submitted to ALFAM2 database)

rm(list = ls())

# Set release tag for download
ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/'
rtag <- 'v2.22'

### Or, use specific commit
##ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/5646f11f8173d092faea6d17b0cc6abc9e74069d/'
##rtag <- ''

source('packages.R')
source('functions.R')
source('load.R')
source('subset.R')
source('export.R')
