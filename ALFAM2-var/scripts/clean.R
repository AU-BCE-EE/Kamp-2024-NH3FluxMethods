# Sort out some variables and names

idat$pmid <- as.character(idat$pmid)
pdat$pmid <- as.character(pdat$pmid)

pdat$app.date <- as.character(pdat$app.start, format = '%Y-%m-%d')

# Add application method and rate
idat$app.mthd <- idat$app.method
idat$app.rate.ni <- (idat$app.mthd != 'os') * idat$app.rate

idat$tan.app <- idat$app.rate * idat$man.tan
