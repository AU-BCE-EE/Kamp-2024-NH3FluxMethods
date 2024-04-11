---
title: 'Mixed-effects models'
output: pdf_document
author: Sasha D. Hafner
date: "11 April, 2024 14:23"
---

# Factor levels and 2 subsets


```r
pdat[, meas.level := paste(meas.tech, meas.tech.det, treat)]
pdat[, meas.level := gsub('bLS Alpha samplers.+$', 'bLS-alpha', meas.level)]
pdat[, meas.level := gsub('DTM.+$', 'DTM', meas.level)]
pdat[, meas.level := gsub('Wind tunnel NA', 'WT', meas.level)]
pdat[, meas.level := gsub('bLS NA eGylle_bLS', 'bLS-CRDS', meas.level)]
pdat[, meas.level := gsub('.+_FC_.+$', 'FC', meas.level)]
pdat[, meas.level := gsub('diluted$', '', meas.level)]
pdat[, meas.level := gsub('_traps_.+m$', '', meas.level)]
d1 <- pdat[country == 'DK', ]
d2 <- pdat[country == 'NL', ]
```

# I-AU micromet


```r
d1mm <- d1[meas.tech2 == 'micro met', ]
d1mm[, .(pmid, meas.level, e.rel.168)]
```

```
##     pmid meas.level e.rel.168
##    <int>     <char>     <num>
## 1:  1936   bLS-CRDS   0.49741
## 2:  1939  bLS-alpha   0.35479
## 3:  1940  bLS-alpha   0.37910
```

```r
d1mm[, .(pmid, meas.level, e.rel.final)]
```

```
##     pmid meas.level e.rel.final
##    <int>     <char>       <num>
## 1:  1936   bLS-CRDS     0.51214
## 2:  1939  bLS-alpha     0.35754
## 3:  1940  bLS-alpha     0.38189
```

```r
table(d1mm[, meas.level])
```

```
## 
## bLS-alpha  bLS-CRDS 
##         2         1
```


```r
m1 <- lmer(e.rel.168 ~ 1|meas.level, data = d1mm)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: e.rel.168 ~ 1 | meas.level
##    Data: d1mm
## 
## REML criterion at convergence: -5.8
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.7730 -0.3206  0.1318  0.3865  0.6412 
## 
## Random effects:
##  Groups     Name        Variance  Std.Dev.
##  meas.level (Intercept) 0.0082889 0.09104 
##  Residual               0.0002955 0.01719 
## Number of obs: 3, groups:  meas.level, 2
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  0.43161    0.06523   6.617
```

```r
VarCorr(m1)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.091044
##  Residual               0.017190
```


```r
m2 <- lmer(log10(e.rel.168) ~ 1|meas.level, data = d1mm)
summary(m2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: log10(e.rel.168) ~ 1 | meas.level
##    Data: d1mm
## 
## REML criterion at convergence: -5.5
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.7840 -0.3151  0.1538  0.3920  0.6302 
## 
## Random effects:
##  Groups     Name        Variance  Std.Dev.
##  meas.level (Intercept) 0.0084479 0.09191 
##  Residual               0.0004142 0.02035 
## Number of obs: 3, groups:  meas.level, 2
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept) -0.37024    0.06617  -5.595
```

```r
VarCorr(m2)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.091912
##  Residual               0.020352
```

```r
100 * (10^(as.data.frame(VarCorr(m2))[, 5]) - 1)
```

```
## [1] 23.569771  4.797817
```

Total.


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.09413859
```

# I-AU enclosure


```r
d1en <- d1[meas.tech2 != 'micro met', ]
d1en[, .(pmid, meas.level, e.rel.168)]
```

```
##      pmid meas.level e.rel.168
##     <int>     <char>     <num>
##  1:  1911    WT AER7   0.41202
##  2:  1912   WT AER25   0.46643
##  3:  1913   WT AER25   0.44840
##  4:  1914    WT AER7   0.33273
##  5:  1915   WT AER25   0.46788
##  6:  1916   WT AER54   0.55949
##  7:  1917   WT AER54   0.53404
##  8:  1941        DTM   0.14856
##  9:  1942        DTM   0.15142
## 10:  1943        DTM   0.16570
```

```r
d1en[, .(pmid, meas.level, e.rel.final)]
```

```
##      pmid meas.level e.rel.final
##     <int>     <char>       <num>
##  1:  1911    WT AER7     0.41477
##  2:  1912   WT AER25     0.46939
##  3:  1913   WT AER25     0.45111
##  4:  1914    WT AER7     0.33480
##  5:  1915   WT AER25     0.47110
##  6:  1916   WT AER54     0.56296
##  7:  1917   WT AER54     0.53740
##  8:  1941        DTM     0.14856
##  9:  1942        DTM     0.15142
## 10:  1943        DTM     0.16570
```

```r
table(d1en[, meas.level])
```

```
## 
##      DTM WT AER25 WT AER54  WT AER7 
##        3        3        2        2
```


```r
m1 <- lmer(e.rel.168 ~ 1|meas.level, data = d1en)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: e.rel.168 ~ 1 | meas.level
##    Data: d1en
## 
## REML criterion at convergence: -24.3
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.56605 -0.40378  0.01123  0.33245  1.55594 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.028064 0.1675  
##  Residual               0.000645 0.0254  
## Number of obs: 10, groups:  meas.level, 4
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  0.38367    0.08416   4.559
```

```r
VarCorr(m1)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.167524
##  Residual               0.025397
```


```r
m2 <- lmer(log10(e.rel.168) ~ 1|meas.level, data = d1en)
summary(m2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: log10(e.rel.168) ~ 1 | meas.level
##    Data: d1en
## 
## REML criterion at convergence: -19.4
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.45940 -0.37882 -0.03926  0.33695  1.47468 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.058782 0.24245 
##  Residual               0.001001 0.03164 
## Number of obs: 10, groups:  meas.level, 4
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  -0.4601     0.1217  -3.782
```

```r
VarCorr(m2)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.242450
##  Residual               0.031637
```

```r
100 * (10^(as.data.frame(VarCorr(m2))[, 5]) - 1)
```

```
## [1] 74.763381  7.556652
```

Total.


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.2445059
```

# I-AU enclosure without DTM


```r
d1en <- d1[!meas.tech2 %in% c('micro met', 'DTM'), ]
d1en[, .(pmid, meas.level, e.rel.168)]
```

```
##     pmid meas.level e.rel.168
##    <int>     <char>     <num>
## 1:  1911    WT AER7   0.41202
## 2:  1912   WT AER25   0.46643
## 3:  1913   WT AER25   0.44840
## 4:  1914    WT AER7   0.33273
## 5:  1915   WT AER25   0.46788
## 6:  1916   WT AER54   0.55949
## 7:  1917   WT AER54   0.53404
```

```r
d1en[, .(pmid, meas.level, e.rel.final)]
```

```
##     pmid meas.level e.rel.final
##    <int>     <char>       <num>
## 1:  1911    WT AER7     0.41477
## 2:  1912   WT AER25     0.46939
## 3:  1913   WT AER25     0.45111
## 4:  1914    WT AER7     0.33480
## 5:  1915   WT AER25     0.47110
## 6:  1916   WT AER54     0.56296
## 7:  1917   WT AER54     0.53740
```

```r
table(d1en[, meas.level])
```

```
## 
## WT AER25 WT AER54  WT AER7 
##        3        2        2
```


```r
m1 <- lmer(e.rel.168 ~ 1|meas.level, data = d1en)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: e.rel.168 ~ 1 | meas.level
##    Data: d1en
## 
## REML criterion at convergence: -17.1
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -1.4776 -0.3257  0.1825  0.4113  1.1239 
## 
## Random effects:
##  Groups     Name        Variance  Std.Dev.
##  meas.level (Intercept) 0.0070868 0.08418 
##  Residual               0.0009289 0.03048 
## Number of obs: 7, groups:  meas.level, 3
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)     0.46       0.05   9.201
```

```r
VarCorr(m1)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.084183
##  Residual               0.030478
```


```r
m2 <- lmer(log10(e.rel.168) ~ 1|meas.level, data = d1en)
summary(m2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: log10(e.rel.168) ~ 1 | meas.level
##    Data: d1en
## 
## REML criterion at convergence: -16.2
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -1.5603 -0.2152  0.1640  0.3463  1.1343 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.006532 0.08082 
##  Residual               0.001187 0.03445 
## Number of obs: 7, groups:  meas.level, 3
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept) -0.34336    0.04851  -7.079
```

```r
VarCorr(m2)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.080823
##  Residual               0.034449
```

```r
100 * (10^(as.data.frame(VarCorr(m2))[, 5]) - 1)
```

```
## [1] 20.45462  8.25524
```

Total.


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.08785876
```

# II-WUR micromet


```r
d2mm <- d2[meas.tech2 == 'micro met', ]
d2mm[, .(pmid, meas.level, e.rel.168)]
```

```
##     pmid                        meas.level e.rel.168
##    <int>                            <char>     <num>
## 1:  1937                          bLS-CRDS   0.12683
## 2:  1945 bLS CRDS avg. eGylle_bLS_avg_time        NA
## 3:  1946         IHF Acid traps eGylle_IHF        NA
## 4:  2248    bLS Acid traps eGylle_bLS_acid        NA
## 5:  2249    bLS Acid traps eGylle_bLS_acid        NA
## 6:  2250    bLS Acid traps eGylle_bLS_acid        NA
```

```r
d2mm[, .(pmid, meas.level, e.rel.final)]
```

```
##     pmid                        meas.level e.rel.final
##    <int>                            <char>       <num>
## 1:  1937                          bLS-CRDS    0.128440
## 2:  1945 bLS CRDS avg. eGylle_bLS_avg_time    0.124280
## 3:  1946         IHF Acid traps eGylle_IHF    0.080097
## 4:  2248    bLS Acid traps eGylle_bLS_acid    0.149360
## 5:  2249    bLS Acid traps eGylle_bLS_acid    0.125170
## 6:  2250    bLS Acid traps eGylle_bLS_acid    0.171890
```

```r
table(d2mm[, meas.level])
```

```
## 
##    bLS Acid traps eGylle_bLS_acid bLS CRDS avg. eGylle_bLS_avg_time 
##                                 3                                 1 
##                          bLS-CRDS         IHF Acid traps eGylle_IHF 
##                                 1                                 1
```


```r
m1 <- lmer(e.rel.final ~ 1|meas.level, data = d2mm)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: e.rel.final ~ 1 | meas.level
##    Data: d2mm
## 
## REML criterion at convergence: -19.5
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -0.97484 -0.56914  0.06167  0.25834  1.30701 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.000498 0.02232 
##  Residual               0.000509 0.02256 
## Number of obs: 6, groups:  meas.level, 4
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  0.12361    0.01495   8.271
```

```r
VarCorr(m1)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.022316
##  Residual               0.022560
```


```r
m2 <- lmer(log10(e.rel.final) ~ 1|meas.level, data = d2mm)
summary(m2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: log10(e.rel.final) ~ 1 | meas.level
##    Data: d2mm
## 
## REML criterion at convergence: -7
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.8491 -0.6004  0.1256  0.2422  1.1591 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.009490 0.09742 
##  Residual               0.004705 0.06859 
## Number of obs: 6, groups:  meas.level, 4
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept) -0.92445    0.05756  -16.06
```

```r
VarCorr(m2)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.097415
##  Residual               0.068592
```

```r
100 * (10^(as.data.frame(VarCorr(m2))[, 5]) - 1)
```

```
## [1] 25.14547 17.10940
```


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.1191408
```

Total.


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.1191408
```

# II-WUR enclosure

Note that AER was 25 for all WT ("20" is application rate).


```r
d2en <- d2[meas.tech2 != 'micro met' & meas.level %in% c('WT 20', 'FC') & !grepl('diluted', treat), ]
d2en[, .(pmid, meas.level, e.rel.168)]
```

```
##     pmid meas.level e.rel.168
##    <int>     <char>     <num>
## 1:  1927      WT 20   0.35403
## 2:  1929      WT 20   0.38712
## 3:  1933      WT 20   0.33742
## 4:  2244         FC        NA
## 5:  2245         FC        NA
## 6:  2246         FC        NA
## 7:  2247         FC        NA
```

```r
d2en[, .(pmid, meas.level, e.rel.final)]
```

```
##     pmid meas.level e.rel.final
##    <int>     <char>       <num>
## 1:  1927      WT 20     0.35426
## 2:  1929      WT 20     0.38741
## 3:  1933      WT 20     0.33770
## 4:  2244         FC     0.15707
## 5:  2245         FC     0.16987
## 6:  2246         FC     0.16513
## 7:  2247         FC     0.22263
```

```r
table(d2en[, meas.level])
```

```
## 
##    FC WT 20 
##     4     3
```


```r
d2en[, .(meas.tech.orig, e.rel.168)]
```

```
##     meas.tech.orig e.rel.168
##             <char>     <num>
## 1:     Wind tunnel   0.35403
## 2:     Wind tunnel   0.38712
## 3:     Wind tunnel   0.33742
## 4: Dynamic chamber        NA
## 5: Dynamic chamber        NA
## 6: Dynamic chamber        NA
## 7: Dynamic chamber        NA
```

```r
d2en[, .(meas.level, e.rel.168)]
```

```
##    meas.level e.rel.168
##        <char>     <num>
## 1:      WT 20   0.35403
## 2:      WT 20   0.38712
## 3:      WT 20   0.33742
## 4:         FC        NA
## 5:         FC        NA
## 6:         FC        NA
## 7:         FC        NA
```

```r
d2en[, .(meas.level, e.rel.final)]
```

```
##    meas.level e.rel.final
##        <char>       <num>
## 1:      WT 20     0.35426
## 2:      WT 20     0.38741
## 3:      WT 20     0.33770
## 4:         FC     0.15707
## 5:         FC     0.16987
## 6:         FC     0.16513
## 7:         FC     0.22263
```


```r
m1 <- lmer(e.rel.final ~ 1|meas.level, data = d2en)
summary(m1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: e.rel.final ~ 1 | meas.level
##    Data: d2en
## 
## REML criterion at convergence: -19.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.8083 -0.6282 -0.3524  0.4451  1.5268 
## 
## Random effects:
##  Groups     Name        Variance  Std.Dev.
##  meas.level (Intercept) 0.0161714 0.12717 
##  Residual               0.0007882 0.02808 
## Number of obs: 7, groups:  meas.level, 2
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  0.26905    0.09056   2.971
```

```r
VarCorr(m1)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.127167
##  Residual               0.028076
```


```r
m2 <- lmer(log10(e.rel.final) ~ 1|meas.level, data = d2en)
summary(m2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: log10(e.rel.final) ~ 1 | meas.level
##    Data: d2en
## 
## REML criterion at convergence: -11.7
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.9709 -0.5004 -0.3632  0.3001  1.7348 
## 
## Random effects:
##  Groups     Name        Variance Std.Dev.
##  meas.level (Intercept) 0.046344 0.21528 
##  Residual               0.003135 0.05599 
## Number of obs: 7, groups:  meas.level, 2
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  -0.5988     0.1537  -3.895
```

```r
VarCorr(m2)
```

```
##  Groups     Name        Std.Dev.
##  meas.level (Intercept) 0.21528 
##  Residual               0.05599
```

```r
100 * (10^(as.data.frame(VarCorr(m2))[, 5]) - 1)
```

```
## [1] 64.16371 13.76005
```

Total.


```r
sqrt(sum(as.data.frame(VarCorr(m2))[, 5]^2))
```

```
## [1] 0.222439
```


