
dfsumm(as.data.frame(id2[, c('e.int', 'air.temp', 'wind.2m', 'rain.rate', 'rain.cum')]))
dfsumm(as.data.frame(pd2[, c('till', 'incorp', 'crop', 'app.mthd', 'man.dm', 'man.ph', 'man.source')]))

# Fill in missing values
id2$rain.rate[is.na(id2$rain.rate)] <- 0
id2$rain.cum[is.na(id2$rain.cum)] <- 0
id2$air.temp[is.na(id2$air.temp)] <- 12 
id2$wind.2m[is.na(id2$wind.2m)] <- 3

pd2$man.ph[is.na(pd2$man.ph)] <- 7
pd2$incorp[is.na(pd2$incorp)] <- 'none'

dfsumm(as.data.frame(id2[, c('e.int', 'air.temp', 'wind.2m', 'rain.rate', 'rain.cum')]))
dfsumm(as.data.frame(pd2[, c('till', 'incorp', 'crop', 'app.mthd', 'man.dm', 'man.ph', 'man.source')]))
