
ggplot(idat, aes(t.end, e.rel, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(t.start, e.rel.pred2), lty = 'solid') +
  geom_line(aes(t.start, e.rel.pred1), lty = '11') +
  ylim(0, 0.7) +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_emis.png', height = 5, width = 6)

ggplot(idat, aes(t.start, j.NH3, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(t.start, j.NH3.pred2), lty = 'solid') +
  geom_line(aes(t.start, j.NH3.pred1), lty = '11') +
  ylim(0, 0.7) +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_flux.png', height = 5, width = 6)
