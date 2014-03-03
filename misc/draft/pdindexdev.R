library(animalmove)

caribou<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gaunaco.csv")

head(guanaco)


x <- caribou$xAlaskaAlb*1000
y <- caribou$yAlaskaAlb*1000

xy <- cbind(x, y)
xy.sp <- SpatialPoints(xy)
xy.sp
xy.cc = coordinates(xy.sp)
xy.df <- as.data.frame(xy.sp)

# Copy caribou data to the data frame
dt.caribou <- data.table(caribou)
dt.caribou

# Create attribute data frame
dt.caribou.attr <- dt.caribou[, list(id=uniqueID, pop.type="caribou")]
dt.caribou.attr

# Create spatial coordinates
dt.caribou.xy <- dt.caribou[, list(x=xAlaskaAlb*1000, y=yAlaskaAlb*1000)]
dt.caribou.xy
str(dt.caribou.xy)

#Create Individuals data frame
xy.sp.caribou <- SpatialPoints(dt.caribou.xy)
xy.sp.caribou

# Create spatial points data frame with attributes
xy.caribou.spdf <- SpatialPointsDataFrame(xy.sp, dt.caribou.attr)
str(xy.caribou.spdf)

# Create Individuals data.frame - relocations of caribou data
xy.caribou.spdf.reloc <- Individuals(xy.caribou.spdf, group.by="pop.type")

str(xy.caribou.spdf.reloc)

caribou.scale = seq(0,100000,5000) #caribou and gazelles
moose.scale = seq(0,10000,500) #moose
guanaco.scale = seq(0,15000,500) #guanaco

pdi.index1 <- pdi.index(xy.caribou.spdf.reloc, percent = 100, caribou.scale, unin = "m", unout = "km2")
pdi.index1


pdi.data.df <- as.data.frame(pdi.index1@data[1:5])


max.pdi = apply(pdi.data.df,1,max) #out of all five caribou, get max value for each row (spatial lag)
min.pdi = apply(pdi.data.df,1,min) #out of all five caribou, get min value for each row (spatial lag)
mean.pdi = apply(pdi.data.df,1,mean)    #for all five caribou, get mean for each row (spatial lag])
se.pdi =apply(pdi.data.df,1,se) #for all five caribou, get standard deviation for each row (spatial lag)

# summary od PDI 

pdi.summary <- summary.pdi(pdi.index1)

pdi.summary
