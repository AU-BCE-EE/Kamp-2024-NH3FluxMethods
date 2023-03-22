
write.csv(idat, '../data/eGylle_interval.csv', row.names = FALSE)
write.csv(pdat, '../data/eGylle_plot.csv', row.names = FALSE)
cat(verfile, file = '../data/data_version.txt')
write.csv(pmids, '../data/pmids.csv', row.names = FALSE)
