
write.csv(id2, '../data/sub_interval.csv', row.names = FALSE)
write.csv(pd2, '../data/sub_plot.csv', row.names = FALSE)
cat(verfile, file = '../data/data_version.txt')
