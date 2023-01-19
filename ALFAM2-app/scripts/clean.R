# Get eGylle experiments 

idat$pmid <- as.character(idat$pmid)
pdat$pmid <- as.character(pdat$pmid)

pdat$app.date <- as.character(pdat$app.start, format = '%Y-%m-%d')

# Subset to 2 trials in paper
pdat <- subset(pdat, proj == 'eGylle' & app.date %in% c('2021-08-20', '2021-11-09'))

# Merge to get some predictor variables
# NTS we do not need all these columns in pdat--just take those that are needed!
idat <- merge(pdat, idat, by = c('pid', 'pmid'))

# Remove pre-application measurements
idat <- subset(idat, cta > 0.75 * dt)

# Add application method and rate
idat$app.mthd <- idat$app.method
idat$app.rate.ni <- (idat$app.mthd != 'os') * idat$app.rate

# Unique measurement techniques
idat$meas.tech.u <- paste(idat$meas.tech, idat$meas.tech.det)

# Add par set X predictors
idat$bLS <- idat$meas.tech == 'bLS'
idat$wt <- idat$meas.tech == 'Wind tunnel'
idat$wind.wt <- (idat$meas.tech == 'wt') * sqrt(idat$wind.2m)
idat$wind.bLS <- (idat$meas.tech == 'bLS') * sqrt(idat$wind.2m)
idat$air.temp.wt <- (idat$meas.tech == 'Wind tunnel') * idat$air.temp
idat$air.temp.bLS <- (idat$meas.tech == 'bLS') * idat$air.temp

# Add AER
idat$aer <- 75 * idat$wind.2m



# Get main (high-res, CRDS) bLS results to use weather intervals
# b for bLS
bdat <- subset(idat, meas.tech.u == 'bLS NA')
