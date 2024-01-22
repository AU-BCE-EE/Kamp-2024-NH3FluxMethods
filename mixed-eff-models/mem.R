# Thinking about mixed-effects models

library(lme4)

dat <- data.frame(method = c('crds', 'imp', 'imp', 'imp', 'ihf'),
                  emis = c(12, 12.5, 14.8, 17.1, 8))

m1 <- lmer(emis ~ 1|method, data = dat)
m1

m2 <- lmer(log10(emis) ~ 1|method, data = dat)
m2
VarCorr(m2)
10^c(0.12186, 0.06775) - 1
