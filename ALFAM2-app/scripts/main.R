# Make ALFAM2 model predictions for all measurement methods and export them

rm(list = ls())

source('functions.R')
source('packages.R')
source('load.R')
source('clean.R')
knit('run_ALFAM2.Rmd', output = '../logs/run_ALFAM2.md')
source('summary.R')
source('export.R')
source('plot.R')
