# Summarize

# Apparent error
summ1 <- aggregate2(dfinal, x = c('err1', 'err2'), 
                    by = c('country', 'institute', 'meas.tech2'), 
                    FUN = c(mean = mean, sd = sd, n = length))

summ2 <- aggregate2(dfinal, x = c('err1', 'err2'), 
                    by = c('app.mthd', 'meas.tech2'), 
                    FUN = c(mean = mean, sd = sd, n = length))

summ3 <- aggregate2(as.data.frame(dfinal), x = c('err1', 'err2'), 
                    by = 'meas.tech2', 
                    FUN = c(mean = mean, sd = sd, n = length))

# By meas tech
summ4 <- aggregate2(dfinal, x = c('err1', 'err2'), 
                    by = c('institute', 'meas.tech'), 
                    FUN = c(mean = mean, sd = sd, n = length))

# Counts
counts <- dfinal[, .(n = length(e.rel), n.inst = length(unique(inst)), emis.mean = mean(e.rel), emis.sd = sd(e.rel)), by = c('app.mthd', 'meas.tech2')]
counts <- counts[order(app.mthd, meas.tech2), ]
counts <- rounddf(counts, 2)

# Total counts
countstot <- dfinal[, .(n = length(e.rel), n.inst = length(unique(inst)), emis.mean = mean(e.rel), emis.sd = sd(e.rel))]
countsnobc <- dfinal[, .(n = length(e.rel), n.inst = length(unique(inst)), emis.mean = mean(e.rel), emis.sd = sd(e.rel)), by = app.mthd == 'bc']
