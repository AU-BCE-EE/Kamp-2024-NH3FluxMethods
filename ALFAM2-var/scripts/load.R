
idat <- fread('../data-emission/data/sub_interval.csv')
pdat <- fread('../data-emission/data/sub_plot.csv')

# Merge, because idat lack plot level data to keep file size small
idat <- merge(pdat, idat, by = c('pid', 'pmid'))
