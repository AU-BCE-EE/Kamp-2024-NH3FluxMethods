# Interpolate predictaed emission to match intervals in each series (meas tech)
# Note only 1 application method per trial
# Trial is by app.date
# "Interpolation" is done for bLS results as well just for simple code--these should exactly match the values in bdat

#nbpmid <- unique(subset(idat, meas.tech.u != 'bLS NA')$pmid)
#for (i in nbpmid) {

for (i in unique(idat$pmid)) {

  dd <- subset(idat, pmid == i)
  tt <- dd$cta

  # Get bLS/CRDS predictaions for same trial 
  bb <- subset(bpred, app.date == dd$app.date[1])

  # Get interpolated predicted cumulative emission
  idat[idat$pmid == i, 'e.rel.pred2'] <- erp <- approx(c(0, bb$cta), c(0, bb$er.pred2), xout = dd$cta)$y

  # And from that, calculate interval emission and average flux
  idat[idat$pmid == i, 'e.int.pred2'] <- eint <- diff(c(0, erp)) * idat[idat$pmid == i, 'app.rate']
  idat[idat$pmid == i, 'e.cum.pred2'] <- cumsum(eint)
  idat[idat$pmid == i, 'j.NH3.pred2'] <- eint / idat[idat$pmid == i, 'dt']

  # Repeat for par set 1
  idat[idat$pmid == i, 'e.rel.pred1'] <- erp <- approx(c(0, bb$cta), c(0, bb$er.pred1), xout = dd$cta)$y
  idat[idat$pmid == i, 'e.int.pred1'] <- eint <- diff(c(0, erp)) * idat[idat$pmid == i, 'app.rate']
  idat[idat$pmid == i, 'e.cum.pred1'] <- cumsum(eint)
  idat[idat$pmid == i, 'j.NH3.pred1'] <- eint / idat[idat$pmid == i, 'dt']

}
