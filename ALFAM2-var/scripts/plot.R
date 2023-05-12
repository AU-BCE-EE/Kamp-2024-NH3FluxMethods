
dfinal[, app.mthd.nm := factor(app.mthd, levels = c('bc', 'bsth', 'ts', 'os'), 
                               labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection'))]
dfinal[, inst.nm := paste(inst, institute)]

dfinalo[, app.mthd.nm := factor(app.mthd, levels = c('bc', 'bsth', 'ts', 'os'), 
                               labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection'))]
dfinalo[, inst.nm := paste(inst, institute)]

ggplot(dfinal, aes(country, err2, fill = app.mthd)) +
  geom_boxplot() 
ggsave('../plots/resid.png', height = 5, width = 6)

dfinal[, inst.meas.tech2 := interaction(inst, meas.tech2)]
dfinalo[, inst.meas.tech2 := interaction(inst, meas.tech2)]

ggplot(dfinal, aes(inst.nm, e.rel, fill = inst, group = interaction(inst.meas.tech2, app.mthd.nm))) +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm) +
  theme_bw() +
  theme(legend.position = 'none', axis.text.x = element_text(angle = 90, vjust = 0.5, hjust =1)) +
  labs(x = 'Institution', y = 'Final relative emission (frac. applied TAN)')
ggsave('../plots/emis_box.png', height = 5, width = 6)

ggplot(dfinal, aes(inst.nm, err2, fill = inst, group = interaction(inst.meas.tech2, app.mthd.nm))) +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm) +
  theme_bw() +
  theme(legend.position = 'none', axis.text.x = element_text(angle = 90, vjust = 0.5, hjust =1)) +
  labs(x = 'Institution', y = 'Apparent model error (frac. applied TAN)')
ggsave('../plots/error_box.png', height = 5, width = 6)


# Repeat with outliers removed
ggplot(dfinalo, aes(inst.nm, e.rel, fill = inst, group = interaction(inst.meas.tech2, app.mthd.nm))) +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm) +
  theme_bw() +
  theme(legend.position = 'none', axis.text.x = element_text(angle = 90, vjust = 0.5, hjust =1)) +
  labs(x = 'Institution', y = 'Final relative emission (frac. applied TAN)')
ggsave('../plots/emis_box_no.png', height = 5, width = 6)

names(dfinalo)
ggplot(dfinalo, aes(inst.nm, err2, fill = inst, group = interaction(inst.meas.tech2, app.mthd.nm))) +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm) +
  theme_bw() +
  theme(legend.position = 'none', axis.text.x = element_text(angle = 90, vjust = 0.5, hjust =1)) +
  labs(x = 'Institution', y = 'Apparent model error (frac. applied TAN)')
ggsave('../plots/error_box_no.png', height = 5, width = 6)




