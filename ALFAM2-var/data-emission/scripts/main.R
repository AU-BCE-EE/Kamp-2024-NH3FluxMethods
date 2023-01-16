# Download ALFAM2 data, subset to plots with input data, save
# This is only run when a new version of measurement data is needed (e.g., when corrections have been submitted to ALFAM2 database)

rm(list = ls())

# Set release tag for download
ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/'
rtag <- 'v2.17'

### Or, use specific commit
##ghpath <- 'https://github.com/sashahafner/ALFAM2-data/raw/bf608a10d324444627acf35f0aadeaced5f008c9/'
##rtag <- ''

source('packages.R')
source('functions.R')
source('load.R')
source('subset.R')
source('fill.R')
source('export.R')
