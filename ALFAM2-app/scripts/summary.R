# Get final cumulative emission from ALFAM2 model for comparison

bpred[, `:=` (cta.max = max(cta), cta.168 = cta[which.min(abs(cta - 168))]), by = pmid]
cemis <- bpred[cta %in% c(cta.max, cta.168)][, .(pmid, app.mthd, cta, e.pred1, er.pred1, e.pred2, er.pred2)]

bpredb[, `:=` (cta.max = max(cta), cta.168 = cta[which.min(abs(cta - 168))]), by = pmid]
cemisb <- bpredb[cta %in% c(cta.max, cta.168)][, .(pmid, app.mthd, cta, e.pred1, er.pred1, e.pred2, er.pred2)]

cemisdiff <- cemisb[, -1:-2] - cemis[, -1:-2] 
cemisdiff <- cbind(cemis[, 1:2], cemisdiff)
