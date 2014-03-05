library(animalmove)

caribou<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gaunaco.csv")

head(guanaco)

# Caribou data
x <- caribou$xAlaskaAlb*1000
y <- caribou$yAlaskaAlb*1000

# Copy caribou data to the data table
dt.caribou <- data.table(caribou)
dt.caribou

# Create attribute data frame
dt.caribou.attr <- dt.caribou[, list(id=uniqueID, pop.type="caribou")]
dt.caribou.attr

# Create spatial coordinates
dt.caribou.xy <- dt.caribou[, list(x=xAlaskaAlb*1000, y=yAlaskaAlb*1000)]
dt.caribou.xy
str(dt.caribou.xy)

#Create caribou spatial points
xy.sp.caribou <- SpatialPoints(dt.caribou.xy)
xy.sp.caribou

# Create spatial points data frame with attributes
xy.caribou.spdf <- SpatialPointsDataFrame(xy.sp.caribou, dt.caribou.attr)
str(xy.caribou.spdf)

# Create Individuals data.frame - relocations of caribou data
caribou.reloc.16day.5indiv <- Individuals(xy.caribou.spdf, group.by="pop.type")

str(caribou.reloc.16day.5indiv)

caribou.reloc.16day.5indiv

# END Caribou data

# Gazelle data

x <- gazelle$xm*1000
y <- gazelle$ym*1000

# Copy gazelle data to the data table
dt.gazelle <- data.table(gazelle)
dt.gazelle

# Create attribute data frame
dt.gazelle.attr <- dt.gazelle[, list(id=id, pop.type="gazelle")]
dt.gazelle.attr

# Create spatial coordinates
dt.gazelle.xy <- dt.gazelle[, list(x=xm*1000, y=ym*1000)]
dt.gazelle.xy
str(dt.gazelle.xy)

#Create gazelle spatial points
xy.sp.gazelle <- SpatialPoints(dt.gazelle.xy)
xy.sp.gazelle

# Create spatial points data frame with attributes
xy.gazelle.spdf <- SpatialPointsDataFrame(xy.sp.gazelle, dt.gazelle.attr)
str(xy.gazelle.spdf)

# Create Individuals data.frame - relocations of gazelle data
gazelle.reloc.16day.5indiv <- Individuals(xy.gazelle.spdf, group.by="pop.type")

str(gazelle.reloc.16day.5indiv)

gazelle.reloc.16day.5indiv

# END gazelle data


# Load Moose data

x <- moose$xm*1000
y <- moose$ym*1000

# Copy moose data to the data table
dt.moose <- data.table(moose)
dt.moose

# Create attribute data frame
dt.moose.attr <- dt.moose[, list(id=uniqueID, pop.type="moose")]
dt.moose.attr

# Create spatial coordinates
dt.moose.xy <- dt.moose[, list(x=xm*1000, y=ym*1000)]
dt.moose.xy
str(dt.moose.xy)

#Create moose spatial points
xy.sp.moose <- SpatialPoints(dt.moose.xy)
xy.sp.moose

# Create spatial points data frame with attributes
xy.moose.spdf <- SpatialPointsDataFrame(xy.sp.moose, dt.moose.attr)
str(xy.moose.spdf)

# Create Individuals data.frame - relocations of gazelle data
moose.reloc.16day.5indiv <- Individuals(xy.moose.spdf, group.by="pop.type")

str(moose.reloc.16day.5indiv)

moose.reloc.16day.5indiv

# END Moose data

# Load guanaco data


x <- guanaco$xm*1000
y <- guanaco$ym*1000

# Copy moose data to the data table
dt.guanaco <- data.table(guanaco)
dt.guanaco

# Create attribute data frame
dt.guanaco.attr <- dt.guanaco[, list(id=uniqueID, pop.type="guanaco")]
dt.guanaco.attr

# Create spatial coordinates
dt.guanaco.xy <- dt.guanaco[, list(x=xm*1000, y=ym*1000)]
dt.guanaco.xy
str(dt.guanaco.xy)

#Create moose spatial points
xy.sp.guanaco <- SpatialPoints(dt.guanaco.xy)
xy.sp.guanaco

# Create spatial points data frame with attributes
xy.guanaco.spdf <- SpatialPointsDataFrame(xy.sp.guanaco, dt.guanaco.attr)
str(xy.guanaco.spdf)

# Create Individuals data.frame - relocations of gazelle data
guanaco.reloc.16day.5indiv <- Individuals(xy.guanaco.spdf, group.by="pop.type")

str(guanaco.reloc.16day.5indiv)

guanaco.reloc.16day.5indiv

# save data

save(caribou.reloc.16day.5indiv, file="/apps/git/animalmove/data/caribou.reloc.16day.5indiv.rda")
save(gazelle.reloc.16day.5indiv, file="/apps/git/animalmove/data/gazelle.reloc.16day.5indiv.rda")
save(moose.reloc.16day.5indiv, file="/apps/git/animalmove/data/moose.reloc.16day.5indiv.rda")
save(guanaco.reloc.16day.5indiv, file="/apps/git/animalmove/data/guanaco.reloc.16day.5indiv.rda")




