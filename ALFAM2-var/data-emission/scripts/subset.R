
pdat$app.date <- as.character(pdat$app.start, format = '%Y-%m-%d')

# Subset 2
# No acidification 
# No incorporation
# Manure pH required
# Accept any type of manure (including mixes), some missing weather data and manure pH
pdat$app.mthd <- pdat$app.method
pd2 <- pdat[!is.na(pdat$e.24) &
          !is.na(pdat$app.mthd) &
          !is.na(pdat$man.dm) &
          !pdat$acid &
          pdat$e.24 > 0 & 
          pdat$e.rel.24 < 1.0 &
          pdat$man.dm <= 15 &
          pdat$app.mthd != 'pi' &
          pdat$app.mthd != 'cs' &
          pdat$app.mthd != 'bss' &
          pdat$meas.tech2 %in% c('micro met', 'wt') &
          !pdat$inst %in% c(102, 107, 108) & # Exclude AUN, old Swiss (IUL/FAT), and JTI
          pdat$pmid != 1526 & # See rows 1703 and 1728 and others in MU data
          pdat$pmid != 1183 & # Closed slot negative emission
          !grepl('Exclude data from analysis', pdat$notes)
          , ]

# These pmid will be retained (more trimming below)
pmid.keep <- pd2$pmid

# Drop obs with high 168 h emis (thinking of 1184 e.rel.72 1.10 for bsth!)
# More than 105% at 168 hr is too much
pmid.keep <- pmid.keep[!pmid.keep %in% unique(idat[idat$e.rel > 1.05 & idat$ct == idat$ct.168, 'pmid'])]

# Main subset (trimmed below also)
idat$pmid.d2 <- idat$pmid %in% pmid.keep
id2 <- droplevels(idat[idat$pmid %in% pmid.keep & idat$ct <= 168 & idat$ct > 0, ])
pd2 <- droplevels(pdat[pdat$pmid %in% pmid.keep, ])

# How many dropped?
dim(idat)
dim(id2)

dim(pdat)
dim(pd2)

# Check number of plots per country
table(pdat$country)
table(pd2$country)
table(pd2$country, pd2$app.mthd)
length(pmid.keep)
