########################################################################################
#### READING IN AND ORDERING DATA ######################################################
########################################################################################

# reading in data, ordering and adding elapse.time 
org <- read.table('BLANK', header = TRUE, fill = TRUE) # Data not uploaded to GitHub, can be obtained by contacting Johanna Pedersen

data <- rbind(org)
data$date.time <- paste(data$DATE, data$TIME)
data$date.time <- ymd_hms(data$date.time)
data$date.time <- data$date.time + 117 * 60 # fixing time-bug with Picarro
dat <- data

# # removing data before the experiment 
dat <- dat[-c(1:69), ]

########################################################################################
#### ORDERING AND CROPING DATA #########################################################
########################################################################################

dat$id <- dat$MPVPosition

# taking the last point of each measurent from each valve 
dat <- filter(dat, !(dat$id == lead(dat$id)))

# Selecting points with whole numbers (when the valve change there is a measurement where the valve position
# is in between two valves, these are removed)
dat <- dat[dat$id == '1' | dat$id == '2' | dat$id == '3' | dat$id == '4' | dat$id == '5' | dat$id == '6' | dat$id == '7' | 
             dat$id == '8' | dat$id == '9' | dat$id == '10', ]

# Making elapsed.time fit with the first measurement of each valve = 0
dat$Vid <- 0
dat$Vid[1:13] <- c('V1', 'V2', 'V3', 'V4', 'V5', 'V6', 'V7', 'V8', 'V9', 'V10')

splitdat <- split(dat, f = dat$id)
new.names <- dat$Vid[1:10]

for (i in 1:10){
  assign(new.names[i], splitdat[[i]])
}

z = list(V1, V2, V3, V4, V5, V6, V7, V8, V9, V10)
new.dat = NULL
for(i in z){
  i$elapsed.time <- difftime(i$date.time, min(i$date.time), units='hour')
  new.dat <- rbind(new.dat,i)
}

# cropping data: 
dat <- new.dat[,c(19, 26:27, 29)]
dat$elapsed.time <- signif(dat$elapsed.time, digits = 3)

# adding a column with treatment names
dat$treat <- dat$id
dat$treat <- mapvalues(dat$treat, from = c('2', '4', '6'), to = c(rep('AER25', 3)))
dat$treat <- mapvalues(dat$treat, from = c('1', '5'), to = c(rep('AER7', 2)))
dat$treat <- mapvalues(dat$treat, from = c('8', '9'), to = c(rep('AER54', 2)))

dat$replicate <- dat$id
dat$replicate <- mapvalues(dat$replicate, from = c('1', '2', '8'), to = c(rep('1', 3)))
dat$replicate <- mapvalues(dat$replicate, from = c('5', '4', '9'), to = c(rep('2', 3)))
dat$replicate <- mapvalues(dat$replicate, from = c('6'), to = c(rep('3', 1)))

dat$treat <- mapvalues(dat$treat, from = c('3'), to = c('bg tunnel 2')); 
dat$treat <- mapvalues(dat$treat, from = c('7'), to = c('bg tunnel 5'))
dat$treat <- mapvalues(dat$treat, from = c('10'), to = c('bg tunnel 7'));

g <- ggplot(dat, aes(elapsed.time, NH3_30s, colour = treat)) + geom_point()
print(g)

dat$elapsed.time <- mapvalues(dat$elapsed.time, from = '2.66', to = '2.67')
dat$elapsed.time <- mapvalues(dat$elapsed.time, from = '96', to = '95.9')

dat$elapsed.time <- as.numeric(dat$elapsed.time)

# background data: 
dat.bg <- dat[dat$treat == 'bg tunnel 2' | dat$treat == 'bg tunnel 5'| dat$treat == 'bg tunnel 7', ]

# outlet data 
dat <- dat[dat$treat == 'AER25' | dat$treat == 'AER7'| dat$treat == 'AER54', ]

########################################################################################
#### TREATMENT OF BACKGROUNDS ##########################################################
########################################################################################
# plotting all background datapoints (NH3 [ppb] vs time [h])
ggplot(dat.bg, aes(elapsed.time, NH3_30s, colour = treat)) + geom_point() 

# As the backgrounds are very similar an average of the background tube for tunnel 2, 5 and 8 is used as the back
# ground value. 
# Picking out the data
dat.bg <- dat.bg[dat.bg$treat == 'bg tunnel 2' | dat.bg$treat == 'bg tunnel 5'| dat.bg$treat == 'bg tunnel 7', ]

# calculating the average and sd 
dat.bg.summ <- ddply(dat.bg, c('elapsed.time'), summarise, NH3.bg.mn = mean(NH3_30s), NH3.bg.sd = sd(NH3_30s))

# joining the datasets: 
dat <- full_join(dat.bg.summ, dat, by = 'elapsed.time')
# Subtracting the background values from the 30 second average values 
dat$NH3.corr <- dat$NH3_30s - dat$NH3.bg.mn

dat[!complete.cases(dat),]

########################################################################################
#### FLUX CALCULATIONS #################################################################
########################################################################################
# # reading in temperature data 
header <- c('date', 'time', 'temp')
weather <- read.table('BLANK', fill = TRUE, col.names = header) # Data not uploaded to GitHub, can be obtained by contacting Johanna Pedersen
weather <- weather[-1, ]

weather$date.time.weather <- paste(weather$date, weather$time)

# round date.time in data to fit with weather
dat$date.time.weather <- round_date(dat$date.time, '1 hour')
dat$date.time.weather <- as.character(format(dat$date.time.weather, format='%d-%m-%Y %H:%M'))

dat <- left_join(dat, weather, by = 'date.time.weather')

# constants:
p.con <- 1 # atm
R.con <- 0.082057338 # [L * atm * K^-1 * mol^-1]
A.frame <- 0.293 * 0.674 #m^2
M.NH3 <- 17.031 # g * mol^-1

dat$air.temp.K <- dat$temp + 273.15

dat$air.flow <- dat$treat
dat$air.flow <- mapvalues(dat$air.flow, from = 'AER25', to = 33.22 * 60); 
dat$air.flow <- mapvalues(dat$air.flow, from = 'AER7', to = 9.8 * 60)
dat$air.flow <- mapvalues(dat$air.flow, from = 'AER54', to = 72.3 * 60);
dat$air.flow <- as.numeric(dat$air.flow)

# calculation of a concentration from ppb to mol * L^-1
dat$n <- p.con / (R.con * dat$air.temp.K) * dat$NH3.corr * 10^-9  # mol * L^-1        
# calculation of flux, from mol * L^-1 to g.NH3 * min^-1 * m^-2
dat$flux <- (dat$n * M.NH3 * dat$air.flow) / A.frame

# rearanging data by tunnel 
dat <- arrange(dat, by = id)

# calculation of total flux over time
# Average ammonia flux in measurement interval
dat$flux <- rollapplyr(dat$flux, 2, mean, fill = NA)
dat$flux[dat$elapsed.time == 0] <- 0

ggplot(dat, aes(elapsed.time, flux, color = treat)) + geom_point()

############# MAKING DATA FRAME FOR ALFAM2 TEMPLATE 

dat$project <- 'eGylle'  
dat$exp <- '21D'                
dat$field <- 'FoulumgårdD'       
dat$plot.number <- dat$id
dat$treatment <- dat$trea
dat$replicate.nu <- dat$replicate

# rearanging data by tunnel 
dat <- arrange(dat, by = id)

dat$id <- as.character(dat$id)
dat <- mutate(group_by(dat, id), numbering = row_number())

dat$start.date <- format(dat$date.time, format="%d-%m-%Y %H:%M")
dat$end.date <- dat$date.time + 1.33*60*60
dat$end.date <- format(dat$end.date, format = '%d-%m-%Y %H:%M')
dat$shift.length <- '1.33'

dat$measuring.tech <- 'Wind tunnel'
dat$details <- ''
dat$detection.limit <- ''
dat$bg.value <- dat$NH3.bg.mn / 1000
dat$bg.unit <- 'ppm'

# from gN * min^-1 * m^-2 to gN * h^-1 * ha^-1
dat$NH3.value <- dat$flux *10^-3 * 60 * 10^4

dat$NH3.unit <- 'kg N/ha-hr'
dat$man.pH <- '' 
dat$air.temp <- dat$temp
dat$air.height <- '2'

dat.table <- dat[, c(18:37)]

write.xlsx(dat.table, file = 'BLANK.xlsx')