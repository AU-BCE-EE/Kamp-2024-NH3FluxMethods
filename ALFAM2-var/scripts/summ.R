
# Add to idat
names(dpred1) <- paste0(names(dpred1), '.pred1')
ipred <- cbind(idat, dpred1[, c('j.pred1', 'e.pred1', 'er.pred1')])
names(dpred2) <- paste0(names(dpred2), '.pred2')
ipred <- cbind(ipred, dpred2[, c('j.pred2', 'e.pred2', 'er.pred2')])

# Calculate apparent error
ipred$err1 <- ipred$er.pred1 - ipred$e.rel
ipred$err2 <- ipred$er.pred2 - ipred$e.rel

# Get latest times
ipred <- ipred[, ct.max := max(ct), by = pmid]

dfinal <- ipred[ct == ct.max, ] 

args(aggregate2)
names(dfinal)
aggregate2(as.data.frame(dfinal), x = c('err1', 'err2'), by = c('country', 'institute'), FUN = c(mean = mean, sd = sd, n = length))

ggplot(dfinal, aes(country, err2, fill = app.mthd)) +
  geom_boxplot() 

x <- subset(dfinal, err2 > 1)

range(dfinal$er.pred2)
