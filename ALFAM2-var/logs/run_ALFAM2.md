---
title: 'Model call record'
output: pdf_document
classoption: landscape
author: Sasha D. Hafner
date: "15 January, 2023 19:53"
---

Check package version.


```r
packageVersion('ALFAM2')
```

```
## [1] '2.16'
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
dfsumm(as.data.frame(idat)[, c('pmid', 'tan.app', 'app.mthd', 'app.rate.ni', 'man.dm', 'air.temp', 'wind.2m', 'man.ph', 'rain.rate')])
```

```
## Error in dfsumm(as.data.frame(idat)[, c("pmid", "tan.app", "app.mthd", : could not find function "dfsumm"
```

```r
table(idat$file)
```

```
## 
##      ../../data-submitted/03/AU/ALFAM2_template_6_1_eGylle_JK_3.xlsx 
##                                                                  336 
##           ../../data-submitted/03/UNINA/ALFAM2_UNINA_5_6_1_ver6.xlsx 
##                                                                   33 
## ../../data-submitted/03/UNINI/ALFAM2_template_6.1_ARMOSA2013_V1.xlsx 
##                                                                  284 
##                             1 ALFAM2_96TVNH3_DERVAL(44)_2011 v4.xlsx 
##                                                                  336 
##                             2 ALFAM2_96TVNH3_LACHAP(44)_2011 v4.xlsx 
##                                                                  336 
##                                         6 ALFAM2_FR-GRI-2012 v4.xlsx 
##                                                                  317 
##                                            8 ALFAM_LI94_SURF v5.xlsx 
##                                                                  768 
##                                                          ALFAM1.xlsx 
##                                                                  870 
##                                           ALFAM2 CAU-LU FTIR v2.xlsx 
##                                                                  566 
##                                             ALFAM2_ADAS_RRes_v2.xlsx 
##                                                                  733 
##                                                       ALFAM2_AT.xlsx 
##                                                                  102 
##                                                    ALFAM2_AU_v5.xlsx 
##                                                                  210 
##                                     ALFAM2_data_NL-grass9703_v2.xlsx 
##                                                                  654 
##                                               ALFAM2_NMI-WUR_v3.xlsx 
##                                                                   30 
##                                        ALFAM2_PoValley-Italy_v7.xlsx 
##                                                                  336 
##                                           ALFAM2_Switzerland_v2.xlsx 
##                                                                  821 
##                                               ALFAM2_Teagasc_v5.xlsx 
##                                                                  314 
##                                               Bittman ALFAM2 v5.xlsx 
##                                                                   25
```

Run model with set 2 parameters


```r
# NTS: should use cat for eGylle data
dpred1 <- alfam2(as.data.frame(idat), pars = ALFAM2pars01, app.name = 'tan.app', time.name = 'ct', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```
## Warning in alfam2(as.data.frame(idat), pars = ALFAM2pars01, app.name = "tan.app", : Running with 17 parameters. Dropped 3 with no match.
## These secondary parameters have been dropped:
##   incorp.deep.f4
##   incorp.shallow.f4
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
##   app.mthd.bc.r1
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
dpred2 <- alfam2(as.data.frame(idat), pars = ALFAM2pars02, app.name = 'tan.app', time.name = 'ct', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```
## Warning in alfam2(as.data.frame(idat), pars = ALFAM2pars02, app.name = "tan.app", : Running with 17 parameters. Dropped 7 with no match.
## These secondary parameters have been dropped:
##   app.mthd.cs.f0
##   ts.cereal.hght.r1
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
##   man.source.pig.f0
##   int.r1
##   app.mthd.bc.r1
##   man.dm.r1
##   air.temp.r1
##   wind.2m.r1
##   app.mthd.ts.r1
##   man.ph.r1
##   int.r2
##   rain.rate.r2
##   int.r3
##   app.mthd.bc.r3
##   man.ph.r3
```

