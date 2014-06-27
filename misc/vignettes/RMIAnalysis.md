<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{An Introduction to the animalmove package}
-->

Realized Mobility Index
=======================================





Load package library

```r
library(animalmove)
```


Subsample Data
------------

Khulan dataset has been saved in the package data directory , and loaded on the package load.

Raw **khulan** dataset contains unlaltered original data.


```r
data(khulan.raw.data)
head(khulan.raw.data)
```

```
##   id    sex                time      X       Y   lat   lon age elevation
## 1  3 female 2009-07-20 12:47:00 498117 5026295 45.39 92.98 5-6      1361
## 2  3 female 2009-07-20 12:59:00 494908 5026062 45.39 92.93 5-6      1359
## 3  3 female 2009-07-20 13:12:00 493784 5026159 45.39 92.92 5-6      1357
## 4  3 female 2009-07-20 13:25:00 493014 5026142 45.39 92.91 5-6      1357
## 5  3 female 2009-07-20 13:38:00 492374 5026252 45.39 92.90 5-6      1353
## 6  3 female 2009-07-20 13:51:00 491814 5026458 45.39 92.90 5-6      1353
##   vegetation behaviour  unixTime
## 1          9           1.248e+09
## 2          9       TRA 1.248e+09
## 3          9       TRA 1.248e+09
## 4         10       TRA 1.248e+09
## 5          6       TRA 1.248e+09
## 6          9       TRA 1.248e+09
```


Number of rows in the khulan.raw.data

```r
nrow(khulan.raw.data)
```

```
## [1] 222632
```



For demonstration purposes we add a column that indicates a specie type to the data frame for each relocation data.

Enhanced dataset has been saved into khulan.test.data a column pop.type, which indicates a specie type.

Specie type assignment rule:  Individuals with ids 3,4,7, 6441 assigned to the specie1 type, and the rest is identified as specie2 type.


```r
data(khulan.test.data)
head(khulan.test.data)
```

```
##    id    sex                time      X       Y   lat   lon age elevation
## 1:  3 female 2009-07-20 12:47:00 498117 5026295 45.39 92.98 5-6      1361
## 2:  3 female 2009-07-20 12:59:00 494908 5026062 45.39 92.93 5-6      1359
## 3:  3 female 2009-07-20 13:12:00 493784 5026159 45.39 92.92 5-6      1357
## 4:  3 female 2009-07-20 13:25:00 493014 5026142 45.39 92.91 5-6      1357
## 5:  3 female 2009-07-20 13:38:00 492374 5026252 45.39 92.90 5-6      1353
## 6:  3 female 2009-07-20 13:51:00 491814 5026458 45.39 92.90 5-6      1353
##    vegetation behaviour  unixTime pop.type
## 1:          9           1.248e+09 species1
## 2:          9       TRA 1.248e+09 species1
## 3:          9       TRA 1.248e+09 species1
## 4:         10       TRA 1.248e+09 species1
## 5:          6       TRA 1.248e+09 species1
## 6:          9       TRA 1.248e+09 species1
```


Number of rows in the khulan.test.data


```r
nrow(khulan.test.data)
```

```
## [1] 222632
```


### Subsample data within time interval
--------------------------------------

We select at most 6 individuals within 2009, time interval 50 hours, and accuracy 50 hours, and subsampling scheme for Realized Mobility Index

```r
rmi.subsample.data <- subsample(khulan.test.data, start = c("2009-01-01 00:00"), 
    end = "2009-12-31 00:00", interval = c("50 hours"), accuracy = c("3 mins"), 
    minIndiv = 3, maxIndiv = 6, mustIndiv = NULL, index.type = "rmi")
```

```
## [1] "50 hours"
## [1] "3 mins"
## [1] "2009-01-01 00:00"
## 'data.frame':	10 obs. of  9 variables:
##  $ numberOfIndividuals: int  4 5 4 5 6 3 4 5 4 5
##  $ pairsOfCompleteSets: int  15 2 2 2 0 70 11 2 16 0
##  $ completeSets       : int  33 15 14 16 4 74 29 11 36 5
##  $ scanInterval       : chr  "50 hours" "50 hours" "50 hours" "50 hours" ...
##  $ scanAccuracy       : chr  "3 mins" "3 mins" "3 mins" "3 mins" ...
##  $ firstScantime      : chr  "2009-01-01 00:00" "2009-01-01 00:00" "2009-01-01 00:00" "2009-01-01 00:00" ...
##  $ firstOverlap       : chr  "2009-07-24 04:00" "2009-07-26 06:00" "2009-07-28 08:00" "2009-08-01 12:00" ...
##  $ lastOverlap        : chr  "2009-12-25 08:00" "2009-12-21 04:00" "2009-12-25 08:00" "2009-12-10 18:00" ...
##  $ lastScantime       : chr  "2009-12-31 00:00" "2009-12-31 00:00" "2009-12-31 00:00" "2009-12-31 00:00" ...
```

```r

head(rmi.subsample.data)
```

```
##   overlapID           scantimes   id    sex                time      X
## 1       105 2009-08-05 16:00:00    3 female 2009-08-05 15:58:00 516162
## 2       105 2009-08-05 16:00:00    4   male 2009-08-05 16:00:00 515341
## 3       105 2009-08-05 16:00:00 6441   male 2009-08-05 16:00:00 544872
## 4       105 2009-08-05 16:00:00 6446 female 2009-08-05 16:00:00 532589
## 5       105 2009-08-05 16:00:00    7   male 2009-08-05 16:00:00 457694
## 6       105 2009-08-05 16:00:00 7376 female 2009-08-05 16:00:00 462306
##         Y   lat   lon age elevation vegetation behaviour  unixTime
## 1 5022753 45.36 93.21 5-6      1409          9       GRA 1.249e+09
## 2 5021986 45.35 93.20   3      1405         12       GRA 1.249e+09
## 3 5013379 45.27 93.57  15      1607          9       RST 1.249e+09
## 4 5035037 45.47 93.42  15      1554          6       RST 1.249e+09
## 5 5016030 45.30 92.46  12      1547          6       GRA 1.249e+09
## 6 4992069 45.08 92.52 2-3      1674          6       GRA 1.249e+09
##   pop.type  time.lag
## 1 species1 12.5 days
## 2 species1 12.5 days
## 3 species1 12.5 days
## 4 species2 12.5 days
## 5 species1 12.5 days
## 6 species2 12.5 days
```


Note, a number of rows in the rmi subsample dataset


```r
nrow(rmi.subsample.data)
```

```
## [1] 24
```


### Prepare data for the analysis in the spatial form
----------------------------

Create attribute data frame


```r
dt.rmi.data <- data.table(rmi.subsample.data)

dt.rmi.data.attr <- dt.rmi.data[, list(id = id, pop.type = pop.type, x = X, 
    y = Y, time = time, time.lag = time.lag, age = age, elevation = elevation, 
    behaviour = behaviour)]
str(dt.rmi.data.attr)
```

```
## Classes 'data.table' and 'data.frame':	24 obs. of  9 variables:
##  $ id       : int  3 4 6441 6446 7 7376 3 4 6441 6446 ...
##  $ pop.type : chr  "species1" "species1" "species1" "species2" ...
##  $ x        : num  516162 515341 544872 532589 457694 ...
##  $ y        : num  5022753 5021986 5013379 5035037 5016030 ...
##  $ time     : POSIXct, format: "2009-08-05 15:58:00" "2009-08-05 16:00:00" ...
##  $ time.lag :Class 'difftime'  atomic [1:24] 12.5 12.5 12.5 12.5 12.5 ...
##   .. ..- attr(*, "tzone")= chr "GMT"
##   .. ..- attr(*, "units")= chr "days"
##  $ age      : Factor w/ 5 levels "12","15","2-3",..: 5 4 2 2 1 3 5 4 2 2 ...
##  $ elevation: int  1409 1405 1607 1554 1547 1674 1680 1558 1418 1310 ...
##  $ behaviour: Factor w/ 4 levels "","GRA","RST",..: 2 2 3 3 2 2 2 2 4 3 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```


Create spatial coordinates

```r
dt.rmi.data.xy <- dt.rmi.data[, list(x = X, y = Y)]

str(dt.rmi.data.xy)
```

```
## Classes 'data.table' and 'data.frame':	24 obs. of  2 variables:
##  $ x: num  516162 515341 544872 532589 457694 ...
##  $ y: num  5022753 5021986 5013379 5035037 5016030 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```


Create spatial points

```r
xy.sp.rmi.data <- SpatialPoints(dt.rmi.data.xy)
```


Create spatial points data frame with attributes

```r
xy.rmi.data.spdf <- SpatialPointsDataFrame(xy.sp.rmi.data, dt.rmi.data.attr)
```


Create Individuals data.frame - relocations of khulan data

```r
khulan.reloc.spatial <- Individuals(xy.rmi.data.spdf, id = "id", time = "time", 
    x = "x", y = "y", group.by = "pop.type", proj4string = CRS("+proj=utm +zone=28 +datum=WGS84"))
```

```
## Error: incorrect data frame supplied. Parameter data should be a data
## frame with number of rows greater than zero.
```

```r
head(khulan.reloc.spatial)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'khulan.reloc.spatial' not found
```


Analysis
----------------------------

Compute individual mcp

```r
individual.mcp <- mcp(khulan.reloc.spatial[, 1], percent = 100)
```

```
## Error: object 'khulan.reloc.spatial' not found
```


### Display individual mcp
----------------------------------

individual.mcp

```r
individual.mcp
```

```
## Error: object 'individual.mcp' not found
```


### Compute population mcp
----------------------------------

```r
population.mcp <- mcp.population(khulan.reloc.spatial, percent = 100)
```

```
## Error: object 'khulan.reloc.spatial' not found
```


* Display population mcp

```r
population.mcp
```

```
## Error: object 'population.mcp' not found
```


### Compute Realized Mobility Index
----------------------------------

```r
rmi.index.population <- rmi.index(khulan.reloc.spatial, percent = 100, id = "id")
```

```
## Error: error in evaluating the argument 'this' in selecting a method for function 'rmi.index': Error: object 'khulan.reloc.spatial' not found
```

```r

rmi.object <- RMIndex(rmi.index.population)
```

```
## Error: object 'rmi.index.population' not found
```


RMI Data 

```r
rmi.object@data
```

```
## Error: object 'rmi.object' not found
```


### RMI Summary
----------------------------------

```r
summary(rmi.object)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'rmi.object' not found
```

### Plot Results
----------------------------------


```r
par(mar = c(5, 5, 2, 0))
plot(rmi.object)
```

```
## Error: error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'rmi.object' not found
```


