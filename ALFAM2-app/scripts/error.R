# Add estimated uncertainty to predictions

args(pmax)
idat$e.rel.pred2.lwr <- pmax(idat$e.rel.pred2 - 0.15, 0 * idat$e.rel.pred2)
idat$e.rel.pred2.upr <- pmin(idat$e.rel.pred2 + 0.15, idat$e.rel.pred2 / idat$e.rel.pred2)
