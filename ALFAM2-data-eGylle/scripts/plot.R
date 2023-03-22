# Plot curves

cdat <- merge(pdat, idat, by = c('pid', 'pmid'))
ggplot(cdat, aes(cta, e.rel, colour = meas.tech, group = pmid)) +
  geom_line() +
  facet_grid(~ country) +
  labs(x = 'Time since application (h)', y = 'Relative emission (frac. applied TAN)', colour = 'Measurement method')
ggsave('../plots/cum_emis.png', height = 3, width = 6)
