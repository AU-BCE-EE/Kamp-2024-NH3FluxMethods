
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

# NTS: why are there NAs for AAFC???
dfinal <- subset(dfinal, institute != 'AAFC')

summ1 <- aggregate2(as.data.frame(dfinal), x = c('err1', 'err2'), 
                    by = c('country', 'institute', 'meas.tech2'), 
                    FUN = c(mean = mean, sd = sd, n = length))

summ2 <- aggregate2(dfinal, x = c('err1', 'err2'), 
                    by = c('app.mthd', 'meas.tech2'), 
                    FUN = c(mean = mean, sd = sd, n = length))

summ3 <- aggregate2(as.data.frame(dfinal), x = c('err1', 'err2'), 
                    by = 'meas.tech2', 
                    FUN = c(mean = mean, sd = sd, n = length))


# Summarize measured variability
names(dfinal)
table(pdat$incorp)
dim(pdat)
aggregate2(pdat, x = 'e.rel.final', by = c('man.source', 'app.mthd', 'incorp'), 
           FUN = list(mean = mean, sd = sd))

library(lme4)
m5 <- lmer(log10(emis.perc) ~ pH + DM + app.meth + (1|source), data = dsub)

table(dfinal$meas.tech2)

dfinal$inst <- factor(dfinal$inst)
dfinal$imt <- interaction(dfinal$institute, dfinal$meas.tech)
dbsth <- subset(dfinal, app.mthd == 'bsth' & e.rel.final < 0.75)
dbc <- subset(dfinal, app.mthd == 'bc' & e.rel.final < 1.1)
dos <- subset(dfinal, app.mthd == 'os' & e.rel.final < 1.1)

m1 <- lmer(e.rel ~ (1|inst), data = dbsth)
m2 <- lmer(e.rel ~ (1|imt), data = dbsth)
m3 <- lmer(err2 ~ (1|inst), data = dbsth)
m4 <- lmer(err2 ~ (1|imt), data = dbsth)

summary(m1)
summary(m2)
summary(m3)
summary(m4)

m1 <- lmer(e.rel ~ (1|inst), data = dbc)
m2 <- lmer(e.rel ~ (1|imt), data = dbc)
m3 <- lmer(err2 ~ (1|inst), data = dbc)
m4 <- lmer(err2 ~ (1|imt), data = dbc)

summary(m1)
summary(m2)
summary(m3)
summary(m4)

m1 <- lmer(e.rel ~ (1|inst), data = dos)
m2 <- lmer(e.rel ~ (1|imt), data = dos)
m3 <- lmer(err2 ~ (1|inst), data = dos)
m4 <- lmer(err2 ~ (1|imt), data = dos)

summary(m1)
summary(m2)
summary(m3)
summary(m4)
