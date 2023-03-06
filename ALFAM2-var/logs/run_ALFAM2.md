---
title: 'ALFAM2 model call record'
output: pdf_document
author: Sasha D. Hafner
date: "06 March, 2023 14:59"
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
dfsumm(as.data.frame(idat)[, c('pmid', 'tan.app', 'app.mthd', 'app.rate.ni', 'man.dm', 'air.temp', 'wind.2m', 'man.ph', 'rain.rate')])
```

```
## 
##  39442 rows and 9 columns
##  36501 unique rows
##                         pmid tan.app  app.mthd app.rate.ni  man.dm air.temp
## Class              character numeric character     numeric numeric  numeric
## Minimum                    1    6.65        bc           0    0.55    -4.65
## Maximum                  999     602        ts         315    13.6     37.8
## Mean                    <NA>    80.6      <NA>        40.5    5.08     13.6
## Unique (excld. NA)      1487     690         4         307     364     4831
## Missing values             0       0         0           0       0        0
## Sorted                 FALSE   FALSE     FALSE       FALSE   FALSE    FALSE
##                                                                            
##                    wind.2m  man.ph rain.rate
## Class              numeric numeric   numeric
## Minimum                  0    6.54         0
## Maximum               28.4    9.02      71.2
## Mean                  2.57     7.5    0.0459
## Unique (excld. NA)    7193     133       644
## Missing values           0       0         0
## Sorted               FALSE   FALSE     FALSE
## 
```

```r
table(idat$file)
```

```
## 
##                  ../../data-submitted/03/AU/ALFAM2_JNK_2019_Aug_5_5_b.xlsx 
##                                                                       1284 
##                  ../../data-submitted/03/AU/ALFAM2_JNK_2019_May_5_6_a.xlsx 
##                                                                        828 
## ../../data-submitted/03/AU/ALFAM2_template_5_2_210929_JP_CanadianData.xlsx 
##                                                                        540 
##        ../../data-submitted/03/AU/ALFAM2_template_5_2_211012_JP_18ABC.xlsx 
##                                                                       1788 
##        ../../data-submitted/03/AU/ALFAM2_template_5_2_211012_JP_18GHI.xlsx 
##                                                                       1733 
##       ../../data-submitted/03/AU/ALFAM2_template_5_2_211012_JP_18KLRS.xlsx 
##                                                                       2845 
##        ../../data-submitted/03/AU/ALFAM2_template_5_2_211012_JP_18NOP.xlsx 
##                                                                       2556 
##       ../../data-submitted/03/AU/ALFAM2_template_5_2_211012_JP_19BCHI.xlsx 
##                                                                       1622 
##   ../../data-submitted/03/AU/ALFAM2_template_6_0_220126_JP_20CD21A_JP.xlsx 
##                                                                       1303 
##    ../../data-submitted/03/AU/ALFAM2_template_6_0_220310_JP_20EFGH_v2.xlsx 
##                                                                       1134 
##      ../../data-submitted/03/AU/ALFAM2_template_6_1_220317_JP_21CD22A.xlsx 
##                                                                       2540 
##   ../../data-submitted/03/AU/ALFAM2_template_6_1_220524_JP_21E_220610.xlsx 
##                                                                        829 
##            ../../data-submitted/03/AU/ALFAM2_template_6_1_eGylle_JK_3.xlsx 
##                                                                       1345 
##        ../../data-submitted/03/AU/ALFAM2_template_7_0_eGylle_NL_DE_JK.xlsx 
##                                                                         52 
##       ../../data-submitted/03/DiSSA-IT/ALFAM2_data from Adani-Zilio_2.xlsx 
##                                                                         27 
##                 ../../data-submitted/03/UNINA/ALFAM2_UNINA_5_6_1_ver6.xlsx 
##                                                                        115 
##       ../../data-submitted/03/UNINI/ALFAM2_template_6.1_ARMOSA2013_V1.xlsx 
##                                                                       1136 
##                                   1 ALFAM2_96TVNH3_DERVAL(44)_2011 v4.xlsx 
##                                                                        672 
##                                   2 ALFAM2_96TVNH3_LACHAP(44)_2011 v4.xlsx 
##                                                                        504 
##                                     3 ALFAM2_96TVNH3_TREV(29)_2011 v4.xlsx 
##                                                                        672 
##                                               4 ALFAM2_FR-GRI-2008 v4.xlsx 
##                                                                        105 
##                                               5 ALFAM2_FR-GRI-2009 v5.xlsx 
##                                                                        296 
##                                               6 ALFAM2_FR-GRI-2012 v4.xlsx 
##                                                                        317 
##                                               7 ALFAM2_LI94_INCORP v5.xlsx 
##                                                                       1058 
##                                                  8 ALFAM_LI94_SURF v5.xlsx 
##                                                                        768 
##                                                                ALFAM1.xlsx 
##                                                                       4591 
##                                     ALFAM2 CAU-LU cps and micromet v5.xlsx 
##                                                                         67 
##                                                 ALFAM2 CAU-LU FTIR v2.xlsx 
##                                                                        566 
##                                                   ALFAM2_ADAS_RRes_v2.xlsx 
##                                                                        733 
##                                                             ALFAM2_AT.xlsx 
##                                                                        102 
##                                                          ALFAM2_AU_v5.xlsx 
##                                                                        285 
##                                                 ALFAM2_Chantigny_2000.xlsx 
##                                                                        132 
##                                            ALFAM2_Chantigny_2004_2005.xlsx 
##                                                                       2091 
##                                            ALFAM2_data_NL_arable01_v3.xlsx 
##                                                                        458 
##                                           ALFAM2_data_NL-grass9703_v2.xlsx 
##                                                                        670 
##                                                     ALFAM2_NMI-WUR_v3.xlsx 
##                                                                         58 
##                                              ALFAM2_PoValley-Italy_v7.xlsx 
##                                                                       1882 
##                                                 ALFAM2_Switzerland_v2.xlsx 
##                                                                        851 
##                                                     ALFAM2_Teagasc_v5.xlsx 
##                                                                        314 
##                                                           ALFAM2_USDA.xlsx 
##                                                                         36 
##                                                     Bittman ALFAM2 v5.xlsx 
##                                                                        537
```

Run model with set 2 parameters


```r
# NTS: should use cat for eGylle data
dpred1 <- alfam2(as.data.frame(idat), pars = ALFAM2pars01, app.name = 'tan.app', time.name = 'ct', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```r
dpred2 <- alfam2(as.data.frame(idat), pars = ALFAM2pars02, app.name = 'tan.app', time.name = 'ct', group = 'pmid', prep = TRUE)
```

```
## User-supplied parameters are being used.
```

```
## Warning in alfam2(as.data.frame(idat), pars = ALFAM2pars02, app.name = "tan.app", : Running with 21 parameters. Dropped 3 with no match.
## These secondary parameters have been dropped:
##   app.mthd.cs.f0
##   ts.cereal.hght.r1
##   app.mthd.cs.r3
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
##   incorp.shallow.f4
##   incorp.shallow.r3
##   incorp.deep.f4
##   incorp.deep.r3
```

