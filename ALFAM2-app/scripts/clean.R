# Get eGylle experiments 

idat$pmid <- as.character(idat$pmid)
pdat$pmid <- as.character(pdat$pmid)

pdat$app.date <- as.character(pdat$app.start, format = '%Y-%m-%d')

# Subset to 2 trials in paper
pdat <- subset(pdat, proj == 'eGylle' & app.date %in% c('2021-08-20', '2021-11-09'))

# Merge to get some predictor variables
idat <- merge(pdat, idat, by = c('pid', 'pmid'))

# Remove pre-application measurements
idat <- subset(idat, cta > 0.25 * dt)

# Add application method and rate
idat$app.mthd <- idat$app.method
idat$app.rate.ni <- (idat$app.mthd != 'os') * idat$app.rate

# Unique measurement techniques
idat$meas.tech.u <- paste(idat$meas.tech, idat$meas.tech.det)

# Get main (high-res, CRDS) bLS results to use weather intervals
# b for bLS
bdat <- subset(idat, meas.tech.u == 'bLS NA')
