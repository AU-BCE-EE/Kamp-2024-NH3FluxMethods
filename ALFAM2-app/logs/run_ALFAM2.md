---
title: 'Model call record'
output: pdf_document
classoption: landscape
author: Sasha D. Hafner
date: "08 March, 2023 11:10"
---

Check package version.


```r
packageVersion('ALFAM2')
```

```
## [1] '2.19'
```

Parameter values.


```r
ALFAM2pars02
```

```
##            int.f0    app.mthd.os.f0    app.rate.ni.f0         man.dm.f0 
##       -0.60568338       -1.74351499       -0.01114900        0.39967070 
## man.source.pig.f0    app.mthd.cs.f0            int.r1    app.mthd.bc.r1 
##       -0.59202858       -7.63373787       -0.93921516        0.79352480 
##         man.dm.r1       air.temp.r1        wind.2m.r1    app.mthd.ts.r1 
##       -0.13988189        0.07354268        0.15026720       -0.45907135 
## ts.cereal.hght.r1         man.ph.r1            int.r2      rain.rate.r2 
##       -0.24471238        0.66500000       -1.79918546        0.39402156 
##            int.r3    app.mthd.bc.r3    app.mthd.cs.r3         man.ph.r3 
##       -3.22841225        0.56153956       -0.66647417        0.23800000 
## incorp.shallow.f4 incorp.shallow.r3    incorp.deep.f4    incorp.deep.r3 
##       -0.96496655       -0.58052689       -3.69494954       -1.26569562
```

Check input data.


```r
dfsumm(as.data.frame(bdat)[, c('pmid', 'tan.app', 'app.mthd', 'app.rate.ni', 'man.dm', 'air.temp', 'wind.2m', 'man.ph', 'rain.rate')])
```

```
## 
##  821 rows and 9 columns
##  818 unique rows
##                         pmid tan.app  app.mthd app.rate.ni  man.dm air.temp
## Class              character numeric character     numeric numeric  numeric
## Minimum                 1936    30.2      bsth           0    4.95     2.33
## Maximum                 1937      70        os        35.9    6.78     21.6
## Mean                    <NA>    53.4      <NA>        20.9    5.71     11.7
## Unique (excld. NA)         2       2         2           2       2      520
## Missing values             0       0         0           0       0        0
## Sorted                  TRUE   FALSE      TRUE       FALSE    TRUE    FALSE
##                                                                            
##                    wind.2m  man.ph rain.rate
## Class              numeric numeric   numeric
## Minimum             0.0765     7.7         0
## Maximum               5.74     7.9         3
## Mean                  2.03    7.82    0.0136
## Unique (excld. NA)     812       2         5
## Missing values           0       0         0
## Sorted               FALSE   FALSE     FALSE
## 
```

```r
table(bdat$app.start, bdat$man.ph, exclude = NULL)
```

```
##                      
##                       7.7 7.9
##   2021-08-20 10:58:00   0 478
##   2021-11-09 10:15:00 343   0
```

```r
table(bdat$file)
```

```
## 
## ../../data-submitted/03/AU/ALFAM2_template_6_1_eGylle_JK_3.xlsx 
##                                                             821
```

Run model with set 2 parameters


```r
dpred1 <- alfam2(as.data.frame(bdat), pars = ALFAM2pars01, app.name = 'tan.app', time.name = 'cta', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```
## Warning in alfam2(as.data.frame(bdat), pars = ALFAM2pars01, app.name = "tan.app", : Running with 16 parameters. Dropped 4 with no match.
## These secondary parameters have been dropped:
##   incorp.deep.f4
##   incorp.shallow.f4
##   app.mthd.bc.r1
##   incorp.deep.r3
## 
## These secondary parameters are being used:
##   int.f0
##   int.r1
##   int.r2
##   int.r3
##   app.mthd.os.f0
##   app.rate.f0
##   man.dm.f0
##   man.dm.r1
##   air.temp.r1
##   wind.2m.r1
##   man.ph.r1
##   air.temp.r3
##   app.mthd.os.r3
##   man.ph.r3
##   rain.rate.r2
##   rain.cum.r3
```

```r
dpred2 <- alfam2(as.data.frame(bdat), pars = ALFAM2pars02, app.name = 'tan.app', time.name = 'cta', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```
## Warning in alfam2(as.data.frame(bdat), pars = ALFAM2pars02, app.name = "tan.app", : Running with 13 parameters. Dropped 11 with no match.
## These secondary parameters have been dropped:
##   man.source.pig.f0
##   app.mthd.cs.f0
##   app.mthd.bc.r1
##   app.mthd.ts.r1
##   ts.cereal.hght.r1
##   app.mthd.bc.r3
##   app.mthd.cs.r3
##   incorp.shallow.f4
##   incorp.shallow.r3
##   incorp.deep.f4
##   incorp.deep.r3
## 
## These secondary parameters are being used:
##   int.f0
##   app.mthd.os.f0
##   app.rate.ni.f0
##   man.dm.f0
##   int.r1
##   man.dm.r1
##   air.temp.r1
##   wind.2m.r1
##   man.ph.r1
##   int.r2
##   rain.rate.r2
##   int.r3
##   man.ph.r3
```

Add to bLS data frame for now


```r
names(dpred1) <- paste0(names(dpred1), '.pred1')
bpred <- cbind(bdat, dpred1[, c('j.pred1', 'e.pred1', 'er.pred1')])
names(dpred2) <- paste0(names(dpred2), '.pred2')
bpred <- cbind(bpred, dpred2[, c('j.pred2', 'e.pred2', 'er.pred2')])
```



