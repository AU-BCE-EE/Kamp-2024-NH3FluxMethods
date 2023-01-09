
library(data.table)

sink('../logs/versions.txt')
  print(sessionInfo())
sink()

