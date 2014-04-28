caribou<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gaunaco.csv")

# Caribou data

# Copy caribou data to the data table
dt.caribou <- data.table(caribou)

load("/apps/git/animalmove/misc/originaldata/martin/khulanData.Rdata")

# Create attribute data frame
dt.caribou.attr <- dt.caribou[, list(id=uniqueID, pop.type="caribou", x=xAlaskaAlb*1000,y=caribou$yAlaskaAlb*1000, time.lag=daysToFind )]

# Gazelle data

# Copy gazelle data to the data table
dt.gazelle <- data.table(gazelle)

# Create attribute data frame
dt.gazelle.attr <- dt.gazelle[, list(id=id, pop.type="gazelle", x=xm*1000, y=ym*1000, time.lag=daysToFind)]

# Load Moose data

# Copy moose data to the data table
dt.moose <- data.table(moose)

# Create attribute data frame
dt.moose.attr <- dt.moose[, list(id=uniqueID, pop.type="moose", x=xm*1000, y=ym*1000, time.lag=daysToFind)]

# Load guanaco data

# Copy guanaco data to the data table
dt.guanaco <- data.table(guanaco)


# Create attribute data frame
dt.guanaco.attr <- dt.guanaco[, list(id=uniqueID, pop.type="guanaco", x=xm*1000, y=ym*1000, time.lag=daysToFind)]
allpopulations <- rbind(dt.caribou.attr, dt.gazelle.attr, dt.moose.attr, dt.guanaco.attr)


# save data

#save(allpopulations, file="/apps/git/animalmove/data/allpopulations.rda")

# Create spatial coordinates

dt.allpopulations <- data.table(allpopulations)

dt.allpopulations.xy <- dt.allpopulations[, list(x, y)]

str(dt.allpopulations.xy)

dt.allpopulations.attr <- dt.allpopulations[, list(id, pop.type, time.lag)]

#Create spatial points
xy.sp.allpopulations <- SpatialPoints(dt.allpopulations.xy)

# Create spatial points data frame with attributes
xy.allpopulations.spdf <- SpatialPointsDataFrame(xy.sp.allpopulations, dt.allpopulations.attr)
str(xy.allpopulations.spdf)

# Create Individuals data.frame - relocations of gazelle data
allpopulations.spatial <- Individuals(xy.allpopulations.spdf, group.by="pop.type")

save(allpopulations.spatial, file="/apps/git/animalmove/data/allpopulations.spatial.rda")

data(allpopulations.spatial)