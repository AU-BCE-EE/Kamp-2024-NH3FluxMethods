
ggplot(idat, aes(t.end, e.rel, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.2) +
  geom_line(aes(t.start, e.rel.pred2), lty = 'solid', col = 'red') +
  geom_line(aes(t.start, e.rel.pred1), lty = '11', col = 'blue') +
  geom_line(aes(t.start, e.rel.predx), lty = '12', col = 'orange') +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_emis.png', height = 5, width = 6)

ggplot(idat, aes(t.start, j.NH3, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(t.start, j.NH3.pred2), lty = 'solid') +
  geom_line(aes(t.start, j.NH3.pred1), lty = '11') +
  geom_line(aes(t.start, j.NH3.predx), lty = 'solid', col = 'orange') +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_flux.png', height = 5, width = 6)

ggplot(idat, aes(cta, j.NH3, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(cta, j.NH3.predx), lty = 'solid', col = 'orange') +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_flux.png', height = 5, width = 6)

ggplot(x, aes(cta, j.NH3, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(cta, j.NH3.predx), lty = 'solid', col = 'orange') +
  ylim(0, 0.7) 

plot(j.NH3.predx ~ cta, data = x)

x <- subset(idat, meas.tech.u == 'bLS NA' & app.date == '2021-08-20')

points(j.NH3 ~ cta, data = x, col = 'red')
head(x)
head(idat)

head(idat)
