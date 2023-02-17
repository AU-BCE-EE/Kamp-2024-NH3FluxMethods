
dfsumm(as.data.frame(id2[, c('e.int', 'app.mthd', 'man.dm', 'man.ph', 'man.source', 'air.temp',
                             'wind.2m', 'rain.rate', 'rain.cum', 'till', 'incorp', 'crop')]))

# Fille in missing values
id2$rain.rate[is.na(id2$rain.rate)] <- 0
id2$rain.cum[is.na(id2$rain.cum)] <- 0
id2$air.temp[is.na(id2$air.temp)] <- 12 
id2$wind.2m[is.na(id2$wind.2m)] <- 3
id2$man.ph[is.na(id2$man.ph)] <- 7
id2$incorp[is.na(id2$incorp)] <- 'none'

dfsumm(as.data.frame(id2[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp',
                             'wind.2m', 'rain.rate', 'rain.cum', 'till', 'incorp', 'crop')]))
