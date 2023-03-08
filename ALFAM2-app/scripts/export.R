# Export model results

exdat <- idat[, c('pmid', 'file', 'row.in.file.plot', 'row.in.file.int', 'field', 'app.date', 
                  'meas.tech.orig', 'meas.tech2', 'oid', 't.start', 't.end', 'ct', 'cta', 'dt',
                  'e.rel', 'j.NH3',
                  'e.rel.pred1', 'e.cum.pred1', 'j.NH3.pred1',
                  'e.rel.pred2', 'e.cum.pred2', 'j.NH3.pred2')]

write.csv(exdat, '../output/ALFAM2_emis.csv', row.names = FALSE)
