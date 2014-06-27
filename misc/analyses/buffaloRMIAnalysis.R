library(lubridate)
library(animalmove)
library(plyr)
library(ggplot2)

buffalodata <- read.csv("./data/buffalo.csv", stringsAsFactors = FALSE, header =TRUE)

str(buffalodata)
head(buffalodata)
nrow(buffalodata)

currentnames <- colnames(buffalodata)
currentnames

names(buffalodata)[names(buffalodata)=="timestamp"] <- "time"
names(buffalodata)[names(buffalodata)=="utm.easting"] <- "x"
names(buffalodata)[names(buffalodata)=="utm.northing"] <- "y"
names(buffalodata)[names(buffalodata)=="tag.local.identifier"] <- "id"
names(buffalodata)[names(buffalodata)=="individual.taxon.canonical.name"] <- "pop.type"

# Data Conversion
buffalodata$time <- as.POSIXct(strptime(buffalodata$time,format="%Y-%m-%d %H:%M",tz="GMT"))

#Display new names
newnames <- colnames(buffalodata)
newnames

# Display 
study.time.range.min <- min(buffalodata$time)
study.time.range.max <- max(buffalodata$time)

study.time.range.min
study.time.range.max

# Number of individuals in the dataset
length(table((buffalodata$id)))

str(buffalodata)

rmi.subsample.data <- subsample(dat=buffalodata, start=c("2005-02-17 00:00:00"),end="2006-12-31 00:00:00",interval=c("50 hours"),accuracy=c("3 hours"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="rmi")
                                
buffalo.indiv <- Individuals(rmi.subsample.data, id="id", time="time", x="x", y="y", group.by="pop.type", proj4string= CRS("+proj=utm +zone=28 +datum=WGS84"))

head(coordinates(buffalo.indiv))
bbox(buffalo.indiv)
head(show(buffalo.indiv),2)
head(SpatialPoints(buffalo.indiv), 2)
coordnames(buffalo.indiv)

buffalo.data.attr <- as.data.frame(buffalo.indiv)
head(buffalo.data.attr)

buffalo.individual.mcp <- mcp(buffalo.indiv[,"id"], percent = 100)
buffalo.individual.mcp

buffalo.population.mcp <- mcp.population(buffalo.indiv, percent = 100)
buffalo.population.mcp

show.mcp(buffalo.indiv, percent = 100, id="id")
print(buffalo.indiv)

fg.pal <- color.palette(length(unique(buffalo.data.attr$pop.type)))
bg.pal <- color.palette(length(unique(buffalo.data.attr$pop.type)), palette = c("Dark2"))  

plot(buffalo.individual.mcp, col=fg.pal)
plot(buffalo.indiv, col="green")

rmi.index.population <- rmi.index(buffalo.indiv, percent = 100, id = "id")

rmi.index.population

summary(rmi.index.population)

plot(rmi.index.population)

