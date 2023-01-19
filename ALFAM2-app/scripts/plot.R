
ggplot(idat, aes(t.end, e.rel, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(t.end, e.rel.pred2), lty = 'solid', col = 'gray45') +
  geom_line(aes(t.end, e.rel.pred1), lty = '11', col = 'black') +
  ylim(0, 0.7) +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_emis.png', height = 7, width = 6)

ggplot(idat, aes(t.start, j.NH3, colour = app.mthd, group = pmid)) +
  geom_point(alpha = 0.3) +
  geom_line(aes(t.start, j.NH3.pred2), lty = 'solid', colour = 'gray45') +
  geom_line(aes(t.start, j.NH3.pred1), lty = '11', colour = 'black') +
  facet_grid(meas.tech.u ~ app.date, scale = 'free')
ggsave('../plots/ALFAM2_flux.png', height = 7, width = 6)

# bLS emission with ALFAM2 error
dd <- subset(idat, meas.tech == 'bLS')
eb <- subset(dd, ct > 241.6 | (app.mthd == 'os' & ct > 188.6))
ggplot(dd, aes(t.end, e.rel, colour = meas.tech.u, group = pmid)) +
  geom_line() +
  geom_line(aes(t.end, e.rel.pred2), lty = 'solid', col = 'gray45') +
  geom_errorbar(data = eb, aes(x = t.end, y = e.rel.pred2,
                               ymin = e.rel.pred2.lwr, 
                               ymax = e.rel.pred2.upr), col = 'gray45', width = 0.4) +
  facet_wrap(~ interaction(app.date, app.mthd), scale = 'free')
ggsave('../plots/ALFAM2_emis_error.png', height = 4, width = 8)


