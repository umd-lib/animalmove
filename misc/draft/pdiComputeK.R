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
dt.caribou.xy <- dt.car[, list(x=xAlaskaAlb*1000, y=yAlaskaAlb*1000)]
dt.caribou.xy
str(dt.caribou.xy)

#Create Individuals data frame
xy.sp.caribou <- SpatialPoints(dt.car.xy)
xy.sp.caribou

# Create spatial points data frame with attributes
xy.caribou.spdf <- SpatialPointsDataFrame(xy.sp, dt.car.attr)
str(xy.caribou.spdf)

# Create Individuals data.frame - relocations of caribou data
xy.caribou.spdf.reloc <- Individuals(xy.caribou.spdf, group.by="pop.type")

str(xy.caribou.spdf.reloc)


getComplementData < function(x){
    
}

#df <- data.table(xy.caribou.spdf.reloc@data)
#str(df)

#df[, ]
#df <- data.frame(pop.type = rep("caribou",nrow(caribou)))

#xy.caribou.spdf = SpatialPointsDataFrame(xy.sp, df)