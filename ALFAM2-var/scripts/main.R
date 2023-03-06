# Make ALFAM2 model predictions for all subset plots and summarize residuals

rm(list = ls())

source('functions.R')
source('packages.R')
source('load.R')
source('clean.R')
knit('run_ALFAM2.Rmd', output = '../logs/run_ALFAM2.md')
source('merge.R')
render('me_mods.Rmd', output_dir = '../stats')
source('summ.R')
source('export.R')
source('plot.R')
