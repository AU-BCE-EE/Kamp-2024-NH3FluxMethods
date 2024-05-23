
pdat$app.date <- format(pdat$app.start, format = '%Y-%m-%d')

pdat <- subset(pdat, proj == 'eGylle' & app.date %in% c('2021-08-20', '2021-11-09'))
table(pdat$meas.tech, pdat$app.date)

# Drop non-eGylle obs from emis interval data
idat <- subset(idat, pmid %in% unique(pdat$pmid))

# Get pmid for including in paper

pdat$meas.tech3 <- paste(pdat$meas.tech, pdat$meas.tech.det)
pmids <- aggregate2(pdat, c('pmid', 'file', 'row.in.file.plot', 'first.row.in.file.int', 'app.date'), 
                    c('institute', 'meas.tech3', 'field'), FUN = list(function(x) paste(unique(x), collapse = ', ')))
