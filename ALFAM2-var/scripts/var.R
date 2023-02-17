# Try to quantify variability in data

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
