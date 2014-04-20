<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{An Introduction to the corrplot package}
-->

An Introduction to the **'animalmove'** package
=======================================






Introduction
------------


The  **animalmove** package provides a series statistical analyses of the spatio-temporal animal movement patterns at the population level.
The package implement analyses described in the original paper **"How landscape dynamics link individualto population-level movement patterns:a multispecies comparison of ungulate relocation data"** (Mueller T., et. al, 2011).


Statistical Analyses
----------------------------


There are three statistical analyses in the package: 

* Realized Mobility Index
* Movement Coordination Index
* Population Dispersion Index

Each of the analyses incorporates the methodology described in the paper, and produces a numerical outcome, which can assesed by the examining the result set or summarized and visualized the custom summaries and high-level functions.

The analyses assume the relocation data of multiple species are preliminary syncronized and preprocessed by time and space dimensions.

We start with the import of the library **animalmove** in R environment. The package can be installed in the local system from the source package archive for OS X or Win platform.

## [Package Installation](../README.md)



```r

# Load library
library(animalmove)
```


Data Import
-----------------------------
The data can be imported in R using conventional form of reading data from csv/text files, and transforming them in *Individuals* object data frame.



```r
# Read data the sample data set is located in data directory of the source
# archive.

caribou <- read.csv("../data/16_day_5_individuals_data_Caribou.csv")
gazelle <- read.csv("../data/16_day_5_individuals_data_Gazelle.csv")
moose <- read.csv("../data/16_day_5_individuals_data_Moose.csv")
guanaco <- read.csv("../data/16_day_5_individuals_data_Gaunaco.csv")
```




```r

# Load Data

# Caribou data

# Copy caribou data to the data table
dt.caribou <- data.table(caribou)

# Create attribute data frame
dt.caribou.attr <- dt.caribou[, list(id = uniqueID, pop.type = "caribou", x = xAlaskaAlb * 
    1000, y = caribou$yAlaskaAlb * 1000, time.lag = daysToFind)]

# Gazelle data

# Copy gazelle data to the data table
dt.gazelle <- data.table(gazelle)

# Create attribute data frame
dt.gazelle.attr <- dt.gazelle[, list(id = id, pop.type = "gazelle", x = xm * 
    1000, y = ym * 1000, time.lag = daysToFind)]

# Load Moose data

# Copy moose data to the data table
dt.moose <- data.table(moose)

# Create attribute data frame
dt.moose.attr <- dt.moose[, list(id = uniqueID, pop.type = "moose", x = xm * 
    1000, y = ym * 1000, time.lag = daysToFind)]

# Load guanaco data

# Copy guanaco data to the data table
dt.guanaco <- data.table(guanaco)


# Create attribute data frame
dt.guanaco.attr <- dt.guanaco[, list(id = uniqueID, pop.type = "guanaco", x = xm * 
    1000, y = ym * 1000, time.lag = daysToFind)]
allpopulations <- rbind(dt.caribou.attr, dt.gazelle.attr, dt.moose.attr, dt.guanaco.attr)

# save data

# save(allpopulations, file='/apps/git/animalmove/data/allpopulations.rda')

# Create spatial coordinates

dt.allpopulations <- data.table(allpopulations)

dt.allpopulations.xy <- dt.allpopulations[, list(x, y)]

str(dt.allpopulations.xy)
```

```
## Classes 'data.table' and 'data.frame':	310 obs. of  2 variables:
##  $ x: num  620673 597224 575563 411808 372566 ...
##  $ y: num  2188198 2173363 2179598 2193228 2190453 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r

dt.allpopulations.attr <- dt.allpopulations[, list(id, pop.type, time.lag)]

# Create spatial points
xy.sp.allpopulations <- SpatialPoints(dt.allpopulations.xy)

# Create spatial points data frame with attributes
xy.allpopulations.spdf <- SpatialPointsDataFrame(xy.sp.allpopulations, dt.allpopulations.attr)
str(xy.allpopulations.spdf)
```

```
## Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..@ data       :'data.frame':	310 obs. of  3 variables:
##   .. ..$ id      : Factor w/ 20 levels "S435891","S515876",..: 1 1 1 1 1 1 1 1 1 1 ...
##   .. ..$ pop.type: chr [1:310] "caribou" "caribou" "caribou" "caribou" ...
##   .. ..$ time.lag: int [1:310] 105 121 137 153 169 185 201 217 233 249 ...
##   ..@ coords.nrs : num(0) 
##   ..@ coords     : num [1:310, 1:2] 620673 597224 575563 411808 372566 ...
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : NULL
##   .. .. ..$ : chr [1:2] "x" "y"
##   ..@ bbox       : num [1:2, 1:2] -820509 -511436 1821501 2242778
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : chr [1:2] "x" "y"
##   .. .. ..$ : chr [1:2] "min" "max"
##   ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slots
##   .. .. ..@ projargs: chr NA
```

```r

# Create Individuals data.frame - relocations of gazelle data
allpopulations.spatial <- Individuals(xy.allpopulations.spdf, group.by = "pop.type")

# save(allpopulations.spatial,
# file='/apps/git/animalmove/data/allpopulations.spatial.rda')

# End Load Data
```


Realized Mobility Index
----------------------------

```r

# Realized Mobility Index
data(allpopulations.spatial)

# compute individual mcp
individual.mcp <- mcp(allpopulations.spatial[, 1], percent = 100)

# display mcp
individual.mcp
```

```
## Object of class "SpatialPolygonsDataFrame" (package sp):
## 
## Number of SpatialPolygons:  20
## 
## Variables measured:
##            id    area
## 583657 583657 2780300
## 601607 601607  631006
## 602189 602189 2208462
## 602190 602190  723942
## 602191 602191  825206
## F6         F6    2796
## ...
```

```r

# compute population mcp
population.mcp <- mcp.population(allpopulations.spatial, percent = 100)

# display mcp
population.mcp
```

```
## Object of class "SpatialPolygonsDataFrame" (package sp):
## 
## Number of SpatialPolygons:  4
## 
## Variables measured:
##              id     area
## caribou caribou 10768516
## gazelle gazelle  4477248
## guanaco guanaco   162400
## moose     moose    28201
```

```r

# compute RMIndex object that is a data.frame

rmi.index.pop <- rmi.index(allpopulations.spatial, percent = 100, id = "id")
```

```
## Loading required package: tcltk
```

```r

rmi.object <- RMIndex(rmi.index.pop)

# RMI Data
rmi.object@data
```

```
##          id pop.type ind.home.range pop.home.range rmi.index
## 1    583657  gazelle        2780300        4477248   0.62098
## 2    601607  gazelle         631006        4477248   0.14094
## 3    602189  gazelle        2208462        4477248   0.49326
## 4    602190  gazelle         723942        4477248   0.16169
## 5    602191  gazelle         825206        4477248   0.18431
## 6        F6    moose           2796          28201   0.09914
## 7   Iris474  guanaco          92608         162400   0.57025
## 8        M4    moose           1794          28201   0.06362
## 9        M6    moose           5416          28201   0.19207
## 10       M7    moose           1285          28201   0.04558
## 11       M8    moose           2129          28201   0.07550
## 12  Name213  guanaco          60964         162400   0.37539
## 13  S435891  caribou        5511582       10768516   0.51182
## 14  S515876  caribou        7507306       10768516   0.69715
## 15  S587873  caribou        5115407       10768516   0.47503
## 16  S597881  caribou        7225956       10768516   0.67103
## 17  S617880  caribou        8555763       10768516   0.79452
## 18  caro514  guanaco          49301         162400   0.30358
## 19 pablo097  guanaco           8118         162400   0.04999
## 20    su394  guanaco          12238         162400   0.07536
```

```r

summary(rmi.object)
```

```
## $caribou
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.475   0.512   0.671   0.630   0.697   0.795 
## 
## $gazelle
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.141   0.162   0.184   0.320   0.493   0.621 
## 
## $guanaco
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0500  0.0754  0.3040  0.2750  0.3750  0.5700 
## 
## $moose
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0456  0.0636  0.0755  0.0952  0.0991  0.1920
```

```r

par(mar = c(5, 5, 2, 0))
plot(rmi.object)
```

<img src="figure/Realized_Mobility_Index.png" title="plot of chunk Realized Mobility Index" alt="plot of chunk Realized Mobility Index" style="display:block; margin: auto" style="display: block; margin: auto;" />

```r

# End Realized Mobility Index
```


Movement Coordination Index
----------------------------


```r

data(puechabonsp)

ind.ds <- puechabonsp
ind.reloc <- ind.ds$relocs
ind.reloc@data$type <- "type1"
ind.reloc@data[1:50, 5] <- "type2"
head(ind.reloc, 53)
```

```
##          coordinates  Name Age Sex   Date  type
## 1  (699889, 3161560) Brock   2   1 930701 type2
## 2  (700046, 3161540) Brock   2   1 930703 type2
## 3  (698840, 3161030) Brock   2   1 930706 type2
## 4  (699809, 3161500) Brock   2   1 930707 type2
## 5  (698627, 3160940) Brock   2   1 930708 type2
## 6  (698719, 3160990) Brock   2   1 930709 type2
## 7  (698991, 3161020) Brock   2   1 930713 type2
## 8  (698626, 3160770) Brock   2   1 930714 type2
## 9  (698879, 3160960) Brock   2   1 930715 type2
## 10 (699756, 3161450) Brock   2   1 930720 type2
## 11 (699006, 3160990) Brock   2   1 930723 type2
## 12 (700387, 3161440) Brock   2   1 930724 type2
## 13 (698705, 3160820) Brock   2   1 930726 type2
## 14 (698974, 3160880) Brock   2   1 930728 type2
## 15 (698937, 3160970) Brock   2   1 930729 type2
## 16 (698987, 3161000) Brock   2   1 930730 type2
## 17 (699888, 3161510) Brock   2   1 930801 type2
## 18 (698797, 3160940) Brock   2   1 930803 type2
## 19 (698791, 3160990) Brock   2   1 930807 type2
## 20 (699535, 3161250) Brock   2   1 930809 type2
## 21 (699406, 3161330) Brock   2   1 930810 type2
## 22 (699461, 3161170) Brock   2   1 930813 type2
## 23 (699529, 3161230) Brock   2   1 930816 type2
## 24 (698992, 3161040) Brock   2   1 930819 type2
## 25 (698905, 3160910) Brock   2   1 930821 type2
## 26 (699474, 3161190) Brock   2   1 930822 type2
## 27 (699367, 3161100) Brock   2   1 930827 type2
## 28 (698689, 3160850) Brock   2   1 930829 type2
## 29 (699341, 3161110) Brock   2   1 930830 type2
## 30 (699207, 3161100) Brock   2   1 930831 type2
## 31 (700098, 3161650) Calou   2   1 930703 type2
## 32 (700310, 3161320) Calou   2   1 930704 type2
## 33 (699877, 3161470) Calou   2   1 930707 type2
## 34 (700003, 3161360) Calou   2   1 930708 type2
## 35 (699820, 3161390) Calou   2   1 930709 type2
## 36 (699778, 3161330) Calou   2   1 930711 type2
## 37 (700419, 3161480) Calou   2   1 930718 type2
## 38 (700261, 3161580) Calou   2   1 930720 type2
## 39 (699797, 3161400) Calou   2   1 930725 type2
## 41 (700344, 3161520) Calou   2   1 930803 type2
## 42 (700355, 3161430) Calou   2   1 930806 type2
## 43 (700301, 3161480) Calou   2   1 930810 type2
## 44 (700040, 3161040) Calou   2   1 930812 type2
## 45 (699855, 3160550) Calou   2   1 930819 type2
## 46 (700022, 3160750) Calou   2   1 930821 type2
## 47 (699656, 3161130) Calou   2   1 930823 type2
## 48 (700122, 3160700) Calou   2   1 930828 type2
## 49 (700266, 3161520) Calou   2   1 930830 type2
## 50 (700010, 3161680) Calou   2   1 930831 type2
## 51 (699520, 3159570)  Chou   3   2 920729 type2
## 52 (699640, 3158700)  Chou   3   2 920802 type1
## 53 (699689, 3158860)  Chou   3   2 920803 type1
## 54 (699670, 3158840)  Chou   3   2 920804 type1
## Coordinate Reference System (CRS) arguments: NA
```

```r

pop.data <- Individuals(ind.reloc, group.by = c("type"))

pop.data@data$time.lag <- 365
pop.data@data[1:50, 6] <- 200

# display data population data
str(pop.data)
```

```
## Formal class 'Individuals' [package "animalmove"] with 6 slots
##   ..@ group.by   : chr "type"
##   ..@ data       :'data.frame':	119 obs. of  6 variables:
##   .. ..$ Name    : Factor w/ 4 levels "Brock","Calou",..: 1 1 1 1 1 1 1 1 1 1 ...
##   .. ..$ Age     : int [1:119] 2 2 2 2 2 2 2 2 2 2 ...
##   .. ..$ Sex     : int [1:119] 1 1 1 1 1 1 1 1 1 1 ...
##   .. ..$ Date    : int [1:119] 930701 930703 930706 930707 930708 930709 930713 930714 930715 930720 ...
##   .. ..$ type    : chr [1:119] "type2" "type2" "type2" "type2" ...
##   .. ..$ time.lag: num [1:119] 200 200 200 200 200 200 200 200 200 200 ...
##   ..@ coords.nrs : num(0) 
##   ..@ coords     : num [1:119, 1:2] 699889 700046 698840 699809 698627 ...
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : chr [1:119] "1" "2" "3" "4" ...
##   .. .. ..$ : chr [1:2] "X" "Y"
##   ..@ bbox       : num [1:2, 1:2] 698626 3157848 701410 3161678
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : chr [1:2] "X" "Y"
##   .. .. ..$ : chr [1:2] "min" "max"
##   ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slots
##   .. .. ..@ projargs: chr NA
```

```r

head(pop.data)
```

```
##         coordinates  Name Age Sex   Date  type time.lag
## 1 (699889, 3161560) Brock   2   1 930701 type2      200
## 2 (700046, 3161540) Brock   2   1 930703 type2      200
## 3 (698840, 3161030) Brock   2   1 930706 type2      200
## 4 (699809, 3161500) Brock   2   1 930707 type2      200
## 5 (698627, 3160940) Brock   2   1 930708 type2      200
## 6 (698719, 3160990) Brock   2   1 930709 type2      200
## Coordinate Reference System (CRS) arguments: NA
```

```r

group.by = colnames(populations(pop.data))
index.group.by = grep(group.by, colnames(pop.data@data))

# test - call using generic method
res.ind <- mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

# display data
head(res.ind)
```

```
##   time.lag pop.type mci.index
## 1      200    type2    0.9996
## 2      200    type2    0.9996
## 3      200    type2    0.9996
## 4      200    type2    0.9996
## 5      200    type2    0.9996
## 6      200    type2    0.9996
```

```r


# Create MCIndex object
mci.object <- MCIndex(res.ind)

# Compute ANOVA stats

anova.model <- aov(mci.object)

# display anova
anova.model
```

```
## Call:
##    aov(formula = mci.index ~ species, data = data)
## 
## Terms:
##                   species Residuals
## Sum of Squares  5.944e-07 0.000e+00
## Deg. of Freedom         1       117
## 
## Residual standard error: 2.087e-15
## Estimated effects may be unbalanced
```

```r

# TukeyHSD from model
TukeyHSD(anova.model)
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = mci.index ~ species, data = data)
## 
## $species
##                   diff        lwr        upr p adj
## type2-type1 -0.0001432 -0.0001432 -0.0001432     0
```



Population Dispersion Index
----------------------------


```r
# Population Dispersion Index

# load data
data(caribou.reloc.16day.5indiv)
data(gazelle.reloc.16day.5indiv)
data(moose.reloc.16day.5indiv)
data(guanaco.reloc.16day.5indiv)

caribou.scale = seq(0, 1e+05, 5000)  #caribou and gazelles
gazelle.scale = caribou.scale
moose.scale = seq(0, 10000, 500)  #moose
guanaco.scale = seq(0, 15000, 500)  #guanaco


# create PDIndex for each specie
pdi.index.caribou <- pdi.index(caribou.reloc.16day.5indiv, percent = 100, caribou.scale, 
    unin = "m", unout = "km2")
pdi.index.gazelle <- pdi.index(gazelle.reloc.16day.5indiv, percent = 100, gazelle.scale, 
    unin = "m", unout = "km2")
pdi.index.guanaco <- pdi.index(guanaco.reloc.16day.5indiv, percent = 100, guanaco.scale, 
    unin = "m", unout = "km2")
pdi.index.moose <- pdi.index(moose.reloc.16day.5indiv, percent = 100, moose.scale, 
    unin = "m", unout = "km2")

# Get summaries of each specie PDI

summary.caribou <- summary.pdi(pdi.index.caribou)
summary.gazelle <- summary.pdi(pdi.index.gazelle)
summary.guanaco <- summary.pdi(pdi.index.guanaco)
summary.moose <- summary.pdi(pdi.index.moose)
```

### PDI Index Summaries

#### Caribou PDI Summary

```r
summary.caribou
```

```
##    rowid pop.type max.pdi min.pdi mean.pdi se.pdi  scale
## 1      1  caribou     0.0       0        0      0      0
## 2      2  caribou  5000.0   -8050    -1687   2779   5000
## 3      3  caribou -2076.1  -13645    -7620   2337  10000
## 4      4  caribou -4964.1  -19141   -11974   3151  15000
## 5      5  caribou -1935.4  -21003   -12932   3785  20000
## 6      6  caribou -2901.3  -23581   -13914   4297  25000
## 7      7  caribou -4143.6  -26083   -16021   4776  30000
## 8      8  caribou -4325.4  -28574   -17352   5302  35000
## 9      9  caribou -3548.7  -31364   -18721   6032  40000
## 10    10  caribou -2552.3  -32152   -18981   6561  45000
## 11    11  caribou -2170.8  -31076   -19048   6244  50000
## 12    12  caribou  -473.3  -32114   -19897   6410  55000
## 13    13  caribou  2032.1  -30519   -18211   6474  60000
## 14    14  caribou  2995.6  -28748   -17087   6160  65000
## 15    15  caribou  4144.0  -27355   -15840   6148  70000
## 16    16  caribou  5701.3  -23910   -13217   5872  75000
## 17    17  caribou  9197.9  -21782   -10758   5997  80000
## 18    18  caribou 11686.9  -18569    -8083   5758  85000
## 19    19  caribou 14084.0  -17980    -6743   5812  90000
## 20    20  caribou 16829.2  -15805    -4934   5864  95000
## 21    21  caribou 18985.6  -13956    -2621   5785 100000
```

#### Gazelle PDI Summary

```r
summary.gazelle
```

```
##    rowid pop.type max.pdi min.pdi mean.pdi se.pdi  scale
## 1      1  gazelle     0.0       0      0.0    0.0      0
## 2      2  gazelle  5000.0   -2292    447.7 1210.9   5000
## 3      3  gazelle  3684.7   -1284    980.3 1059.6  10000
## 4      4  gazelle  -281.3   -4452  -2096.2  783.1  15000
## 5      5  gazelle -2470.9   -7706  -4651.4  854.1  20000
## 6      6  gazelle  -256.4   -9679  -4104.6 1617.7  25000
## 7      7  gazelle  -751.7  -12179  -5305.0 2084.3  30000
## 8      8  gazelle  -595.5  -11605  -4458.2 2045.0  35000
## 9      9  gazelle  1122.8  -10776  -3517.3 2126.6  40000
## 10    10  gazelle  3272.7   -9835  -3161.6 2306.2  45000
## 11    11  gazelle  3269.0  -10091  -3384.0 2409.8  50000
## 12    12  gazelle  5402.1   -9819  -2464.7 2714.6  55000
## 13    13  gazelle  7709.3   -9712  -1014.2 3062.3  60000
## 14    14  gazelle  5236.6   -9359  -1784.1 2842.2  65000
## 15    15  gazelle  6850.8   -7725   -425.4 2890.4  70000
## 16    16  gazelle  8435.5   -6859   -650.7 2922.9  75000
## 17    17  gazelle  8683.4   -7610  -1126.9 2911.0  80000
## 18    18  gazelle  8757.4   -7219   -899.8 2839.9  85000
## 19    19  gazelle 11160.7   -8516  -1285.9 3434.8  90000
## 20    20  gazelle 10693.7   -7617  -2055.5 3288.5  95000
## 21    21  gazelle 10792.1   -7148  -2200.6 3316.0 100000
```


#### Guanaco PDI Summary

```r
summary.guanaco
```

```
##    rowid pop.type  max.pdi min.pdi mean.pdi se.pdi scale
## 1      1  guanaco     0.00       0      0.0    0.0     0
## 2      2  guanaco   500.00   -1043   -117.4  378.1   500
## 3      3  guanaco  -543.43   -2781  -1427.4  441.0  1000
## 4      4  guanaco   -43.43   -3130  -1661.8  599.5  1500
## 5      5  guanaco  -182.75   -4496  -2767.6  738.5  2000
## 6      6  guanaco -1280.63   -4692  -3476.4  628.7  2500
## 7      7  guanaco -2346.61   -5593  -4152.4  589.1  3000
## 8      8  guanaco -3151.52   -6383  -4700.7  676.3  3500
## 9      9  guanaco -3168.63   -6581  -4912.1  714.8  4000
## 10    10  guanaco -2832.90   -7355  -5634.6  795.6  4500
## 11    11  guanaco -2805.00   -7918  -6110.9  883.9  5000
## 12    12  guanaco -2305.00   -7959  -6222.4 1014.8  5500
## 13    13  guanaco -2126.72   -7841  -6325.1 1067.9  6000
## 14    14  guanaco -1775.26   -8310  -6684.5 1245.2  6500
## 15    15  guanaco -1601.14   -8307  -6657.8 1280.2  7000
## 16    16  guanaco -1957.78   -9057  -7131.1 1313.7  7500
## 17    17  guanaco -1754.82   -9520  -7267.9 1415.7  8000
## 18    18  guanaco -1399.58   -9955  -7446.7 1542.6  8500
## 19    19  guanaco -1196.24  -10072  -7334.7 1571.8  9000
## 20    20  guanaco -1132.43   -9861  -7332.1 1580.6  9500
## 21    21  guanaco  -763.26  -10373  -7399.2 1700.2 10000
## 22    22  guanaco  -725.86  -10670  -7381.9 1725.6 10500
## 23    23  guanaco -1399.80  -11339  -7678.9 1670.6 11000
## 24    24  guanaco -1480.27  -11064  -7528.8 1605.4 11500
## 25    25  guanaco -1317.26  -11042  -7316.0 1609.9 12000
## 26    26  guanaco  -817.26  -10929  -7125.7 1683.4 12500
## 27    27  guanaco  -449.05  -10730  -6818.1 1702.4 13000
## 28    28  guanaco  -134.53  -10352  -6502.6 1695.5 13500
## 29    29  guanaco  -392.56   -9959  -6329.7 1584.4 14000
## 30    30  guanaco  -246.35   -9588  -6008.6 1543.1 14500
## 31    31  guanaco   140.25   -9161  -5725.3 1553.7 15000
```


#### Moose PDI Summary

```r
summary.moose
```

```
##    rowid pop.type max.pdi min.pdi mean.pdi se.pdi scale
## 1      1    moose       0    0.00      0.0    0.0     0
## 2      2    moose     500 -174.87    236.4  161.5   500
## 3      3    moose    1000   58.53    625.5  229.3  1000
## 4      4    moose    1500 -419.92    694.2  434.6  1500
## 5      5    moose    2000 -457.51    990.6  558.8  2000
## 6      6    moose    2192 -240.87   1199.2  563.6  2500
## 7      7    moose    2564  -94.57   1423.0  615.0  3000
## 8      8    moose    2702 -272.19   1448.6  688.0  3500
## 9      9    moose    2912 -170.10   1585.1  700.9  4000
## 10    10    moose    3153 -420.83   1624.1  810.9  4500
## 11    11    moose    3434 -226.30   1827.0  828.6  5000
## 12    12    moose    3395 -106.99   1850.4  798.8  5500
## 13    13    moose    3005   45.75   1790.2  690.9  6000
## 14    14    moose    2951  269.49   1800.0  588.0  6500
## 15    15    moose    2974  344.11   1911.9  586.2  7000
## 16    16    moose    2944  523.03   1923.5  534.0  7500
## 17    17    moose    2704  580.21   1831.9  448.0  8000
## 18    18    moose    2437  637.86   1695.1  377.7  8500
## 19    19    moose    2319  511.90   1577.5  333.0  9000
## 20    20    moose    2166  517.73   1346.2  266.8  9500
## 21    21    moose    1958  846.38   1303.2  193.7 10000
```



### Plot PDI

```r
# Create X and Y axes for each species

# caribou
caribou.X <- c(summary.caribou$scale, rev(summary.caribou$scale))
caribou.Y <- c(summary.caribou$mean.pdi + summary.caribou$se.pdi, rev(summary.caribou$mean.pdi - 
    summary.caribou$se.pdi))

# gazelle
gazelle.X <- c(summary.gazelle$scale, rev(summary.gazelle$scale))
gazelle.Y <- c(summary.gazelle$mean.pdi + summary.gazelle$se.pdi, rev(summary.gazelle$mean.pdi - 
    summary.gazelle$se.pdi))

# guanaco
guanaco.X <- c(summary.guanaco$scale, rev(summary.guanaco$scale))
guanaco.Y <- c(summary.guanaco$mean.pdi + summary.guanaco$se.pdi, rev(summary.guanaco$mean.pdi - 
    summary.guanaco$se.pdi))

# moose
moose.X <- c(summary.moose$scale, rev(summary.moose$scale))
moose.Y <- c(summary.moose$mean.pdi + summary.moose$se.pdi, rev(summary.moose$mean.pdi - 
    summary.moose$se.pdi))


# Plot default settings

colorCaribou = "pink"
colorGazelle = "lightblue"
colorGuanaco = "khaki1"  #'#FFFF99'
colorMoose = "lightgreen"
colorCaribou2 = "red"
colorGazelle2 = "blue"
colorGuanaco2 = "darkorange"
colorMoose2 = "darkgreen"

cexValue = 2

cexValue = 1

# Change number of panels in the plotting window back to a single panel
par(mfrow = c(1, 1))

# Change margin size par(mar = c(5, 5, 2, 1))

# Create empty plot, with axes labels
plot(caribou.scale, summary.gazelle$mean.pdi, ylim = c(-25000, 5000), xlim = c(0, 
    50000), col = NA, ylab = "Population Dispersion Index", xlab = "lag (km)", 
    cex.lab = cexValue, cex.axis = cexValue, cex = cexValue, axes = F)

# Add caribou data
polygon(caribou.X, caribou.Y, col = colorCaribou, border = NA)  # plots CI's

# Add gazelle data
polygon(gazelle.X, gazelle.Y, col = colorGazelle, border = NA)  # plots CI's

# Add Moose data
polygon(moose.X, moose.Y, col = colorMoose, border = NA)  # plots CI's

# Add guanaco data
polygon(guanaco.X, guanaco.Y, col = colorGuanaco, border = NA)  # plots CI's


# Add lines
lines(summary.caribou$scale, summary.caribou$mean.pdi, col = colorCaribou2, 
    lwd = 2)  # plots PDI
lines(summary.gazelle$scale, summary.gazelle$mean.pdi, col = colorGazelle2, 
    lwd = 2)  # plots PDI
lines(summary.moose$scale, summary.moose$mean.pdi, col = colorMoose2, lwd = 2)  # plots PDI
lines(summary.guanaco$scale, summary.guanaco$mean.pdi, col = colorGuanaco2, 
    lwd = 2)  # plots PDI


lines(c(0, 1e+05), c(0, 0), lwd = 2, lty = 1)  # add baseline

# Add axes
axis(1, at = seq(0, 50000, 10000), labels = seq(0, 50, 10), cex.axis = cexValue)
axis(2, at = seq(-25000, 5000, 10000), cex.axis = cexValue)

# Add legend
legend(-1000, -18000, legend = c("Caribou (C)", "M. gazelle (MG)", "Guanaco (G)", 
    "Moose (M)"), col = c(colorCaribou2, colorGazelle2, colorGuanaco2, colorMoose2), 
    box.lty = 0, lty = 1, lwd = 3, cex = cexValue, bg = NA)
```

<img src="figure/unnamed-chunk-71.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display:block; margin: auto" style="display: block; margin: auto;" />

```r
par(mfrow = c(2, 2))
par(cex = 0.4)
plot(pdi.index.caribou, col = colorCaribou, linecol = colorCaribou2, title = "Spatial Population Dispersion - Caribou, Kilometers")
plot(pdi.index.gazelle, col = colorGazelle, linecol = colorGazelle2, title = "Spatial Population Dispersion - Gazelle, Kilometers")
plot(pdi.index.moose, col = colorMoose, linecol = colorMoose2, title = "Spatial Population Dispersion - Moose, Kilometers")
plot(pdi.index.guanaco, col = colorGuanaco, linecol = colorGuanaco2, title = "Spatial Population Dispersion - Guanaco, Kilometers")
```

<img src="figure/unnamed-chunk-72.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display:block; margin: auto" style="display: block; margin: auto;" />


