
idat <- fread('../data-emission/data/eGylle_interval.csv')
pdat <- fread('../data-emission/data/eGylle_plot.csv')

parsxdt <- fread('../parsx/parsb.csv')
parsx <- parsxdt$value
names(parsx) <- parsxdt$par


