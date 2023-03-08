# Export model results

# Fix some names to match mod/meas and earlier export
names(bpred) <- gsub('er\\.', 'e\\.rel\\.', names(bpred))
names(bpred) <- gsub('e\\.pred', 'e\\.cum\\.pred', names(bpred))
names(bpred) <- gsub('j\\.pred', 'j\\.NH3\\.pred', names(bpred))

exdat <- bpred[, c('pmid', 'file', 'row.in.file.plot', 'row.in.file.int', 'field', 'app.date', 
                  'meas.tech.orig', 'meas.tech2', 'oid', 't.start', 't.end', 'ct', 'cta', 'dt',
                  'e.rel', 'j.NH3',
                  'e.rel.pred1', 'e.cum.pred1', 'j.NH3.pred1',
                  'e.rel.pred2', 'e.cum.pred2', 'j.NH3.pred2')]

write.csv(exdat, '../output/ALFAM2_emis.csv', row.names = FALSE)
