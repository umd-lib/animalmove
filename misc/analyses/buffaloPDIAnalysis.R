library(lubridate)
library(animalmove)
library(plyr)
library(ggplot2)

buffalodata <- read.csv("./data/buffalo.csv", stringsAsFactors = FALSE, header =TRUE)

str(buffalodata)
head(buffalodata)
nrow(buffalodata)

names(buffalodata)[names(buffalodata)=="timestamp"] <- "time"
names(buffalodata)[names(buffalodata)=="utm.easting"] <- "x"
names(buffalodata)[names(buffalodata)=="utm.northing"] <- "y"
names(buffalodata)[names(buffalodata)=="tag.local.identifier"] <- "id"
names(buffalodata)[names(buffalodata)=="individual.taxon.canonical.name"] <- "pop.type"

# Data Conversion
buffalodata$time <- as.POSIXct(strptime(buffalodata$time,format="%Y-%m-%d %H:%M",tz="GMT"))

# Display time range
study.time.range.min <- min(buffalodata$time)
study.time.range.max <- max(buffalodata$time)

study.time.range.min
study.time.range.max

# Number of individuals in the dataset
length(table((buffalodata$id)))

str(buffalodata)

show.mcp(buffalo.indiv, percent = 100, id="id")
print(buffalo.indiv)

pdi.subsample.data <- subsample(dat=buffalodata, start=c("2005-02-17 00:00:00"),end="2006-12-31 00:00:00",interval=c("50 hours"),accuracy=c("3 hours"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="pdi")

buffalo.indiv <- Individuals(pdi.subsample.data, id="id", time="time", x="x", y="y", group.by="pop.type", proj4string= CRS("+proj=utm +zone=28 +datum=WGS84"))
                        
#Analysis

## Display bounding box and scale
    
bbox.coord1<- bbox.coordinates(buffalo.indiv, percent = 100, unin = "m", unout = "km2")
bbox.coord1

specie1.scale <- bbox.scale(buffalo.indiv, percent = 100, unin = "m", unout = "km2")
specie1.scale

## Species polygon
specie1.poly <- mcp.population(buffalo.indiv, percent = 100)
specie1.poly

color = "green"

plot(specie1.poly, col = color, axes = TRUE)
points(buffalo.indiv, pch=3)
title(main="Syncerus caffer", xlab="X", ylab="Y")

## Compute PDI for each specie

pdi.index.specie1 <- pdi.index(buffalo.indiv, percent = 100, specie1.scale, unin = "m", unout = "km2")

### Compute summaries of each specie PDI
summary.specie1 <- summary.pdi(pdi.index.specie1)
summary.specie1

### Plot PDI

colorSpecie1 = "pink" 
altColorSpecie1 = "red"

plot(pdi.index.specie1, col = colorSpecie1, linecol = altColorSpecie1, title = "Syncerus caffer")
