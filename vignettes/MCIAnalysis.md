<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{An Introduction to the animalmove package}
-->

Movement Coordination Index
=======================================





Load package library

```r
library(lubridate)
library(animalmove)
library(plyr)
library(ggplot2)
```


Subsample Data
------------


Buffalo dataset has been saved in the package data directory , and loaded on the package load.

Raw **buffalo** dataset contains unaltered original data.


```r

data(buffalo)
head(buffalo)
```

```
##   event.id visible               timestamp location.long location.lat
## 1 10210419    true 2005-02-17 05:05:00.000         31.77       -24.54
## 2 10210423    true 2005-02-17 05:05:00.000         31.77       -24.54
## 3 10210428    true 2005-02-17 06:08:00.000         31.76       -24.54
## 4 10210434    true 2005-02-17 06:08:00.000         31.76       -24.54
## 5 10210456    true 2005-02-17 07:05:00.000         31.76       -24.55
## 6 10210458    true 2005-02-17 08:05:00.000         31.76       -24.55
##   behavioural.classification comments manually.marked.outlier sensor.type
## 1                          0     24.3                      NA         gps
## 2                          0     24.3                      NA         gps
## 3                          0     29.5                      NA         gps
## 4                          0     29.5                      NA         gps
## 5                          0     35.8                      NA         gps
## 6                          0     37.3                      NA         gps
##   individual.taxon.canonical.name tag.local.identifier
## 1                 Syncerus caffer             #1764820
## 2                 Syncerus caffer             #1764820
## 3                 Syncerus caffer             #1764820
## 4                 Syncerus caffer             #1764820
## 5                 Syncerus caffer             #1764820
## 6                 Syncerus caffer             #1764820
##   individual.local.identifier
## 1                       Queen
## 2                       Queen
## 3                       Queen
## 4                       Queen
## 5                       Queen
## 6                       Queen
##                                           study.name utm.easting
## 1 Kruger African Buffalo, GPS tracking, South Africa      375051
## 2 Kruger African Buffalo, GPS tracking, South Africa      375051
## 3 Kruger African Buffalo, GPS tracking, South Africa      374851
## 4 Kruger African Buffalo, GPS tracking, South Africa      374851
## 5 Kruger African Buffalo, GPS tracking, South Africa      374527
## 6 Kruger African Buffalo, GPS tracking, South Africa      374492
##   utm.northing utm.zone             study.timezone   study.local.timestamp
## 1      7285726      36S South Africa Standard Time 2005-02-17 07:05:00.000
## 2      7285726      36S South Africa Standard Time 2005-02-17 07:05:00.000
## 3      7285502      36S South Africa Standard Time 2005-02-17 08:08:00.000
## 4      7285502      36S South Africa Standard Time 2005-02-17 08:08:00.000
## 5      7284538      36S South Africa Standard Time 2005-02-17 09:05:00.000
## 6      7284644      36S South Africa Standard Time 2005-02-17 10:05:00.000
```

```r

nrow(buffalo)
```

```
## [1] 28410
```

```r

currentnames <- colnames(buffalo)
currentnames
```

```
##  [1] "event.id"                        "visible"                        
##  [3] "timestamp"                       "location.long"                  
##  [5] "location.lat"                    "behavioural.classification"     
##  [7] "comments"                        "manually.marked.outlier"        
##  [9] "sensor.type"                     "individual.taxon.canonical.name"
## [11] "tag.local.identifier"            "individual.local.identifier"    
## [13] "study.name"                      "utm.easting"                    
## [15] "utm.northing"                    "utm.zone"                       
## [17] "study.timezone"                  "study.local.timestamp"
```

```r

names(buffalo)[names(buffalo) == "timestamp"] <- "time"
names(buffalo)[names(buffalo) == "utm.easting"] <- "x"
names(buffalo)[names(buffalo) == "utm.northing"] <- "y"
names(buffalo)[names(buffalo) == "tag.local.identifier"] <- "id"
names(buffalo)[names(buffalo) == "individual.taxon.canonical.name"] <- "pop.type"

# Data Conversion
buffalo$time <- as.POSIXct(strptime(buffalo$time, format = "%Y-%m-%d %H:%M", 
    tz = "GMT"))

# Display new names
newnames <- colnames(buffalo)
newnames
```

```
##  [1] "event.id"                    "visible"                    
##  [3] "time"                        "location.long"              
##  [5] "location.lat"                "behavioural.classification" 
##  [7] "comments"                    "manually.marked.outlier"    
##  [9] "sensor.type"                 "pop.type"                   
## [11] "id"                          "individual.local.identifier"
## [13] "study.name"                  "x"                          
## [15] "y"                           "utm.zone"                   
## [17] "study.timezone"              "study.local.timestamp"
```

```r
head(buffalo)
```

```
##   event.id visible                time location.long location.lat
## 1 10210419    true 2005-02-17 05:05:00         31.77       -24.54
## 2 10210423    true 2005-02-17 05:05:00         31.77       -24.54
## 3 10210428    true 2005-02-17 06:08:00         31.76       -24.54
## 4 10210434    true 2005-02-17 06:08:00         31.76       -24.54
## 5 10210456    true 2005-02-17 07:05:00         31.76       -24.55
## 6 10210458    true 2005-02-17 08:05:00         31.76       -24.55
##   behavioural.classification comments manually.marked.outlier sensor.type
## 1                          0     24.3                      NA         gps
## 2                          0     24.3                      NA         gps
## 3                          0     29.5                      NA         gps
## 4                          0     29.5                      NA         gps
## 5                          0     35.8                      NA         gps
## 6                          0     37.3                      NA         gps
##          pop.type       id individual.local.identifier
## 1 Syncerus caffer #1764820                       Queen
## 2 Syncerus caffer #1764820                       Queen
## 3 Syncerus caffer #1764820                       Queen
## 4 Syncerus caffer #1764820                       Queen
## 5 Syncerus caffer #1764820                       Queen
## 6 Syncerus caffer #1764820                       Queen
##                                           study.name      x       y
## 1 Kruger African Buffalo, GPS tracking, South Africa 375051 7285726
## 2 Kruger African Buffalo, GPS tracking, South Africa 375051 7285726
## 3 Kruger African Buffalo, GPS tracking, South Africa 374851 7285502
## 4 Kruger African Buffalo, GPS tracking, South Africa 374851 7285502
## 5 Kruger African Buffalo, GPS tracking, South Africa 374527 7284538
## 6 Kruger African Buffalo, GPS tracking, South Africa 374492 7284644
##   utm.zone             study.timezone   study.local.timestamp
## 1      36S South Africa Standard Time 2005-02-17 07:05:00.000
## 2      36S South Africa Standard Time 2005-02-17 07:05:00.000
## 3      36S South Africa Standard Time 2005-02-17 08:08:00.000
## 4      36S South Africa Standard Time 2005-02-17 08:08:00.000
## 5      36S South Africa Standard Time 2005-02-17 09:05:00.000
## 6      36S South Africa Standard Time 2005-02-17 10:05:00.000
```


Number of rows in the buffalo data & data set structure 

```r
length(table((buffalo$id)))
```

```
## [1] 6
```

```r

str(buffalo)
```

```
## 'data.frame':	28410 obs. of  18 variables:
##  $ event.id                   : int  10210419 10210423 10210428 10210434 10210456 10210458 10210483 10210535 10210544 10210558 ...
##  $ visible                    : chr  "true" "true" "true" "true" ...
##  $ time                       : POSIXct, format: "2005-02-17 05:05:00" "2005-02-17 05:05:00" ...
##  $ location.long              : num  31.8 31.8 31.8 31.8 31.8 ...
##  $ location.lat               : num  -24.5 -24.5 -24.5 -24.5 -24.5 ...
##  $ behavioural.classification : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ comments                   : num  24.3 24.3 29.5 29.5 35.8 37.3 38.9 39.6 40 38.1 ...
##  $ manually.marked.outlier    : logi  NA NA NA NA NA NA ...
##  $ sensor.type                : chr  "gps" "gps" "gps" "gps" ...
##  $ pop.type                   : chr  "Syncerus caffer" "Syncerus caffer" "Syncerus caffer" "Syncerus caffer" ...
##  $ id                         : chr  "#1764820" "#1764820" "#1764820" "#1764820" ...
##  $ individual.local.identifier: chr  "Queen" "Queen" "Queen" "Queen" ...
##  $ study.name                 : chr  "Kruger African Buffalo, GPS tracking, South Africa" "Kruger African Buffalo, GPS tracking, South Africa" "Kruger African Buffalo, GPS tracking, South Africa" "Kruger African Buffalo, GPS tracking, South Africa" ...
##  $ x                          : num  375051 375051 374851 374851 374527 ...
##  $ y                          : num  7285726 7285726 7285502 7285502 7284538 ...
##  $ utm.zone                   : chr  "36S" "36S" "36S" "36S" ...
##  $ study.timezone             : chr  "South Africa Standard Time" "South Africa Standard Time" "South Africa Standard Time" "South Africa Standard Time" ...
##  $ study.local.timestamp      : chr  "2005-02-17 07:05:00.000" "2005-02-17 07:05:00.000" "2005-02-17 08:08:00.000" "2005-02-17 08:08:00.000" ...
```



### Subsample data within time interval
--------------------------------------

We select at most 6 individuals within 2009, time interval 50 hours, and accuracy 50 hours, and subsampling scheme for Realized Mobility Index

```r
mci.subsample.data <- subsample(dat = buffalo, start = c("2005-02-17 00:00:00"), 
    end = "2006-12-31 00:00:00", interval = c("50 hours"), accuracy = c("3 hours"), 
    minIndiv = 3, maxIndiv = 6, mustIndiv = NULL, index.type = "mci")
```

```
## [1] "50 hours"
## [1] "3 hours"
## [1] "2005-02-17 00:00:00"
## 'data.frame':	8 obs. of  9 variables:
##  $ numberOfIndividuals: int  3 4 5 6 5 5 4 3
##  $ pairsOfCompleteSets: int  32 19 8 7 9 18 37 49
##  $ completeSets       : int  34 21 10 9 10 20 39 52
##  $ scanInterval       : chr  "50 hours" "50 hours" "50 hours" "50 hours" ...
##  $ scanAccuracy       : chr  "3 hours" "3 hours" "3 hours" "3 hours" ...
##  $ firstScantime      : chr  "2005-02-17 00:00:00" "2005-02-17 00:00:00" "2005-02-17 00:00:00" "2005-02-17 00:00:00" ...
##  $ firstOverlap       : chr  "2005-07-27 10:00" "2005-08-23 12:00" "2005-09-15 10:00" "2005-09-17 12:00" ...
##  $ lastOverlap        : chr  "2005-10-06 06:00" "2005-10-06 06:00" "2005-10-06 06:00" "2005-10-06 06:00" ...
##  $ lastScantime       : chr  "2006-12-31 00:00:00" "2006-12-31 00:00:00" "2006-12-31 00:00:00" "2006-12-31 00:00:00" ...
```

```r

buffalo.indiv <- Individuals(mci.subsample.data, id = "id", time = "time", x = "x", 
    y = "y", group.by = "pop.type", proj4string = CRS("+proj=utm +zone=28 +datum=WGS84"))
```



Analysis
----------------------------

### Compute MCI 
-----------------------------


```r
mci.buffalo <- mci.index(buffalo.indiv, group.by = c("pop.type"), time.lag = c("time.lag"))
mci.buffalomci.buffalo <- mci.index(buffalo.indiv, group.by = c("pop.type"), 
    time.lag = c("time.lag"))
mci.buffalo
```

```
## An object of class "MCIndex"
## Slot "data":
##              scantimes       id        pop.type mci.index
## 1  2005-09-17 12:00:00 #1764820 Syncerus caffer    0.9954
## 2  2005-09-17 12:00:00 #1764823 Syncerus caffer    0.9985
## 3  2005-09-17 12:00:00 #1764826 Syncerus caffer    0.9959
## 4  2005-09-17 12:00:00 #1764829 Syncerus caffer    0.9964
## 5  2005-09-17 12:00:00 #1764832 Syncerus caffer    0.9977
## 6  2005-09-17 12:00:00 #1764835 Syncerus caffer    0.9954
## 7  2005-09-19 14:00:00 #1764820 Syncerus caffer    0.9954
## 8  2005-09-19 14:00:00 #1764823 Syncerus caffer    0.9985
## 9  2005-09-19 14:00:00 #1764826 Syncerus caffer    0.9959
## 10 2005-09-19 14:00:00 #1764829 Syncerus caffer    0.9964
## 11 2005-09-19 14:00:00 #1764832 Syncerus caffer    0.9977
## 12 2005-09-19 14:00:00 #1764835 Syncerus caffer    0.9954
## 13 2005-09-23 18:00:00 #1764820 Syncerus caffer    0.9954
## 14 2005-09-23 18:00:00 #1764823 Syncerus caffer    0.9985
## 15 2005-09-23 18:00:00 #1764826 Syncerus caffer    0.9959
## 16 2005-09-23 18:00:00 #1764829 Syncerus caffer    0.9964
## 17 2005-09-23 18:00:00 #1764832 Syncerus caffer    0.9977
## 18 2005-09-23 18:00:00 #1764835 Syncerus caffer    0.9954
## 19 2005-09-25 20:00:00 #1764820 Syncerus caffer    0.9954
## 20 2005-09-25 20:00:00 #1764823 Syncerus caffer    0.9985
## 21 2005-09-25 20:00:00 #1764826 Syncerus caffer    0.9959
## 22 2005-09-25 20:00:00 #1764829 Syncerus caffer    0.9964
## 23 2005-09-25 20:00:00 #1764832 Syncerus caffer    0.9977
## 24 2005-09-25 20:00:00 #1764835 Syncerus caffer    0.9954
## 25 2005-09-27 22:00:00 #1764820 Syncerus caffer    0.9954
## 26 2005-09-27 22:00:00 #1764823 Syncerus caffer    0.9985
## 27 2005-09-27 22:00:00 #1764826 Syncerus caffer    0.9959
## 28 2005-09-27 22:00:00 #1764829 Syncerus caffer    0.9964
## 29 2005-09-27 22:00:00 #1764832 Syncerus caffer    0.9977
## 30 2005-09-27 22:00:00 #1764835 Syncerus caffer    0.9954
## 31 2005-09-30 00:00:00 #1764820 Syncerus caffer    0.9954
## 32 2005-09-30 00:00:00 #1764823 Syncerus caffer    0.9985
## 33 2005-09-30 00:00:00 #1764826 Syncerus caffer    0.9959
## 34 2005-09-30 00:00:00 #1764829 Syncerus caffer    0.9964
## 35 2005-09-30 00:00:00 #1764832 Syncerus caffer    0.9977
## 36 2005-09-30 00:00:00 #1764835 Syncerus caffer    0.9954
## 37 2005-10-02 02:00:00 #1764820 Syncerus caffer    0.9954
## 38 2005-10-02 02:00:00 #1764823 Syncerus caffer    0.9985
## 39 2005-10-02 02:00:00 #1764826 Syncerus caffer    0.9959
## 40 2005-10-02 02:00:00 #1764829 Syncerus caffer    0.9964
## 41 2005-10-02 02:00:00 #1764832 Syncerus caffer    0.9977
## 42 2005-10-02 02:00:00 #1764835 Syncerus caffer    0.9954
## 43 2005-10-04 04:00:00 #1764820 Syncerus caffer    0.9954
## 44 2005-10-04 04:00:00 #1764823 Syncerus caffer    0.9985
## 45 2005-10-04 04:00:00 #1764826 Syncerus caffer    0.9959
## 46 2005-10-04 04:00:00 #1764829 Syncerus caffer    0.9964
## 47 2005-10-04 04:00:00 #1764832 Syncerus caffer    0.9977
## 48 2005-10-04 04:00:00 #1764835 Syncerus caffer    0.9954
## 49 2005-10-06 06:00:00 #1764820 Syncerus caffer    0.9954
## 50 2005-10-06 06:00:00 #1764823 Syncerus caffer    0.9985
## 51 2005-10-06 06:00:00 #1764826 Syncerus caffer    0.9959
## 52 2005-10-06 06:00:00 #1764829 Syncerus caffer    0.9964
## 53 2005-10-06 06:00:00 #1764832 Syncerus caffer    0.9977
## 54 2005-10-06 06:00:00 #1764835 Syncerus caffer    0.9954
```

```r

cexValue = 2
boxplot(mci.index ~ factor(pop.type), data = mci.buffalo, col = "green", border = NULL, 
    outline = F, lwd = 2, boxwex = 0.5, cex = cexValue, cex.lab = cexValue, 
    cex.axis = cexValue, frame = F, ylab = "Movement coordination index", xlab = NULL)
```

<img src="figure/unnamed-chunk-5.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" style="display:block; margin: auto" style="display: block; margin: auto;" />


### Compute ANOVA
-----------------------------

```r
if (length(unique(buffalo.indiv$pop.type)) > 1) {
    anova.model <- aov.mci(mci.buffalo)
    anova.model
}
```

### Tukey Test
-----------------------------

```r
if (length(unique(buffalo.indiv$pop.type)) > 1) {
    TukeyHSD(anova.model)
    TukeyHSD(mci.buffalo)
}
```


### Kruskal Test
-----------------------------

```r
if (length(unique(buffalo.indiv$pop.type)) > 1) {
    kruskal.test(mci.buffalo)
    kruskalmc(mci.buffalo)
}
```

### Summary
-----------------------------

```r
if (length(unique(buffalo.indiv$pop.type)) > 1) {
    summary(mci.buffalo)
}
```



### Extra Plotting
------------------------------------

```r
library(RColorBrewer)
g = 11
my.cols <- rev(brewer.pal(g, "RdYlBu"))
```


#### Smooth scatter 

```r
require(KernSmooth)
smoothScatter(mci.subsample.data$location.long, mci.subsample.data$location.lat, 
    nrpoints = 0.3 * 1e+05, colramp = colorRampPalette(my.cols), pch = 19, cex = 0.3, 
    col = "green1")
```

<img src="figure/unnamed-chunk-11.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" style="display:block; margin: auto" style="display: block; margin: auto;" />


#### Kernel density using MASS 

```r
library(MASS)
z <- kde2d(mci.subsample.data$location.long, mci.subsample.data$location.lat, 
    n = 50)
plot(mci.subsample.data$location.long, mci.subsample.data$location.lat, xlab = "X", 
    ylab = "Y", pch = 19, cex = 0.3, col = "gray60")
contour(z, drawlabels = FALSE, nlevels = g, col = my.cols, add = TRUE, lwd = 2)
abline(h = mean(mci.subsample.data$location.long), v = mean(mci.subsample.data$location.lat), 
    lwd = 2, col = "black")
legend("topleft", paste("r=", round(cor(mci.subsample.data$location.long, mci.subsample.data$location.lat), 
    2)), bty = "n")
```

<img src="figure/unnamed-chunk-12.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" style="display:block; margin: auto" style="display: block; margin: auto;" />

