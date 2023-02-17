# Merge model and meas, calculate apparent error

# Add to idat
names(dpred1) <- paste0(names(dpred1), '.pred1')
ipred <- cbind(idat, as.data.table(dpred1[, c('j.pred1', 'e.pred1', 'er.pred1')]))
names(dpred2) <- paste0(names(dpred2), '.pred2')
ipred <- cbind(ipred, as.data.table(dpred2[, c('j.pred2', 'e.pred2', 'er.pred2')]))

# Calculate apparent error
# err is fraction of applied TAN
ipred$err1 <- ipred$er.pred1 - ipred$e.rel
ipred$err2 <- ipred$er.pred2 - ipred$e.rel
# rerr is fraction of measured emission
ipred$rerr1 <- ipred$er.pred1 / ipred$e.rel - 1 
ipred$rerr2 <- ipred$er.pred2 / ipred$e.rel - 1

# Get latest times
# Get ct.max again in case data were trimmed
ipred[, ct.max := max(ct), by = 'pmid'] 
dfinal <- ipred[ct == ct.max, ] 
