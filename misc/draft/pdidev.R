
require(adehabitatHR)
require(sp)
require(data.table)
require(RColorBrewer)
require(pgirmess)

library(adehabitatHR)
library(sp)
library(sqldf)
library(data.table)
library(RColorBrewer)

source('/apps/git/animalmove/R/Class-Individuals.R', echo=TRUE)
source('/apps/git/animalmove/R/Individuals-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/MovementAnalysis-methods.R', echo=TRUE)

caribou<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gaunaco.csv")

head(guanaco)

par(mfrow=c(2,2))

# Compute Spatial Polygon for Caribou

x <- caribou$xAlaskaAlb*1000
y <- caribou$yAlaskaAlb*1000

xy <- cbind(x, y)
xy.sp <- SpatialPoints(xy)
xy.sp
xy.cc = coordinates(xy.sp)
xy.df <- as.data.frame(xy.sp)
df <- data.frame(pop.type = rep("caribou",nrow(caribou)))

xy.caribou.spdf = SpatialPointsDataFrame(xy.sp, df)

caribou.poly <- mcp(xy.caribou.spdf, percent = 100)
#caribou.poly

plot(caribou.poly)

caribou.area <- mcp.area(xy.caribou.spdf, percent = 100, plotit = F)
caribou.area

# Compute Spatial Polygon for Gazelle

x <- gazelle$xm*1000
y <- gazelle$ym*1000

xy <- cbind(x, y)
xy.sp <- SpatialPoints(xy)
xy.sp
xy.cc = coordinates(xy.sp)
xy.df <- as.data.frame(xy.sp)
df <- data.frame(pop.type = rep("gazelle",nrow(gazelle)))

xy.gazelle.spdf = SpatialPointsDataFrame(xy.sp, df)

gazelle.poly <- mcp(xy.gazelle.spdf, percent = 100)
#gazelle.poly

plot(gazelle.poly)

gazelle.area <- mcp.area(xy.gazelle.spdf, percent = 100, plotit = F)
gazelle.area

# Compute Guanaco Polygon

x <- guanaco$xm*1000
y <- guanaco$ym*1000

xy <- cbind(x, y)
xy.sp <- SpatialPoints(xy)
xy.sp
xy.cc = coordinates(xy.sp)
xy.df <- as.data.frame(xy.sp)
df <- data.frame(pop.type = rep("guanaco",nrow(guanaco)))

xy.guanaco.spdf = SpatialPointsDataFrame(xy.sp, df)

guanaco.poly <- mcp(xy.guanaco.spdf, percent = 100)
#guanaco.poly

plot(guanaco.poly)

guanaco.area <- mcp.area(xy.guanaco.spdf, percent = 100, plotit = F)
guanaco.area

# Compute Moose Poly

x <- moose$xm*1000
y <- moose$ym*1000

xy <- cbind(x, y)
xy.sp <- SpatialPoints(xy)
xy.sp
xy.cc = coordinates(xy.sp)
xy.df <- as.data.frame(xy.sp)
df <- data.frame(pop.type = rep("moose",nrow(moose)))

xy.moose.spdf = SpatialPointsDataFrame(xy.sp, df)

moose.poly <- mcp(xy.guanaco.spdf, percent = 100)
#moose.poly

plot(moose.poly)

moose.area <- mcp.area(xy.moose.spdf, percent = 100, plotit = F)
moose.area

# movement scales for diffrent species

caribou.scale = seq(0,100000,5000) #caribou and gazelles
moose.scale = seq(0,10000,500) #moose
guanaco.scale = seq(0,15000,500) #guanaco