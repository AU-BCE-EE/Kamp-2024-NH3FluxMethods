# Get eGylle experiments 

idat$pmid <- as.character(idat$pmid)
pdat$pmid <- as.character(pdat$pmid)

pdat$app.date <- format(pdat$app.start, format = '%Y-%m-%d')

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

# Bin bLS data to check for weather resolution effect
dd <- bdat[, .(pmid, cta, air.temp, wind.2m, rain.rate)]
dd[, ctbin := cut(cta, 0:50 * 6)]

bindat <- dd[, .(cta = max(cta), air.temp = mean(air.temp), wind.2m = mean(wind.2m), rain.rate = mean(rain.rate)), by = .(pmid, ctbin)]

# Add plot-level predictors to binned data
bindat <- merge(bindat, bdat[, c('pmid', 'cta', 'tan.app', 'app.mthd', 'app.rate.ni', 'man.dm', 'man.ph')], by = c('pmid', 'cta'))
