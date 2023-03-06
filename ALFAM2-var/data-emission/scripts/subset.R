
pdat$app.date <- as.character(pdat$app.start, format = '%Y-%m-%d')

# Subset 2
# No acidification 
# No incorporation
# Manure pH required
# Accept any type of manure (including mixes), some missing weather data and manure pH
pdat$app.mthd <- pdat$app.method
pd2 <- pdat[!is.na(e.24) &
          !is.na(app.mthd) &
          !is.na(man.dm) &
          !acid &
          e.24 > 0 & 
          e.rel.24 < 1.0 &
          man.dm <= 15 &
          app.mthd != 'pi' &
          app.mthd != 'cs' &
          app.mthd != 'bss' &
          meas.tech2 %in% c('micro met', 'wt') &
          !inst == 102 & # Exclude AUN
          (!inst == 107 | meas.tech2 == 'wt') & # Exclude old Swiss (IUL/FAT) micro met
          !grepl('Exclude data from analysis', notes.plot) # This removes pmid 1488 bc of improper injection operation
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
