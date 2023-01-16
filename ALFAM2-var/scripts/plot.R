
ggplot(dfinal, aes(country, err2, fill = app.mthd)) +
  geom_boxplot() 
ggsave('../plots/resid.png', height = 5, width = 6)
