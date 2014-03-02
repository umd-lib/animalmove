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
xy.sp.caribou <- SpatialPoints(dt.caribou.xy)
xy.sp.caribou

# Create spatial points data frame with attributes
xy.caribou.spdf <- SpatialPointsDataFrame(xy.sp, dt.car.attr)
str(xy.caribou.spdf)

# Create Individuals data.frame - relocations of caribou data
xy.caribou.spdf.reloc <- Individuals(xy.caribou.spdf, group.by="pop.type")

str(xy.caribou.spdf.reloc)

caribou.scale = seq(0,100000,5000) #caribou and gazelles
moose.scale = seq(0,10000,500) #moose
guanaco.scale = seq(0,15000,500) #guanaco

car.population <- mcp.population(xy.caribou.spdf.reloc, percent = 100,
                                  unin = "m", unout = "km2")

car.population


id.vector <- unique(xy.caribou.spdf@data$id)
id.vector

id.vector[1]

expr1 <- "S435891"
oneId <- subset(xy.caribou.spdf.reloc, xy.caribou.spdf.reloc@data$id == id.vector[1])
oneId

nrow(oneId)

otherId <- subset(xy.caribou.spdf.reloc, xy.caribou.spdf.reloc@data$id != id.vector[1])
otherId
nrow(otherId)

this.sp1 <- SpatialPoints(oneId)
other.sp2 <- SpatialPoints(otherId)

pc1_1 <- as.matrix(this.sp1@coords)
pc1_2 <- as.matrix(other.sp2@coords)

caribou.poly.spatial <- SpatialPolygons(caribou.poly@polygons)

caribou.xy<- caribou.poly@polygons[[1]]@Polygons[[1]]@coords

caribou.xy

#k1 <- k12hat(pc1_1, pc1_2, caribouPoly, s) # original coefficients
#k1

k1_test <- k12hat(pc1_1, pc1_2, caribou.xy, caribou.scale)
k1_test 

res_k1_test <- caribou.scale - sqrt(k1_test/pi)
res_k1_test 

#identical(k1_test,k2, FALSE, FALSE, FALSE, FALSE) 
#identical(k1_test,k2, FALSE, FALSE, FALSE, FALSE) 

# "S435891" "S515876" "S587873" "S597881" "S617880"
#pC1 = as.points(caribou[as.character(caribou$uniqueID) =="S435891",]$xAlaskaAlb*1000, 
 #               caribou[as.character(caribou$uniqueID) =="S435891",]$yAlaskaAlb*1000)

#points of all other caribou
#pC2 = as.points(caribou[as.character(caribou$uniqueID) !="S435891",]$xAlaskaAlb*1000, 
 #               caribou[as.character(caribou$uniqueID) !="S435891",]$yAlaskaAlb*1000)

#pC1
#pC2

#k2 = k12hat(pC1,pC2, caribouPoly, s)
#k2

#res_k2 <- s - sqrt(k2/pi)
#res_k2

#identical(k1,k2)
#identical(res_k1_test, res_k2) 


#mymatrix <- as.data.frame(cbind(caribou.scale, caribou.scale, caribou.scale, caribou.scale, caribou.scale))

# test PDI-methods starts here 

id.vector <- unique(xy.caribou.spdf.reloc@data$id)
id.vector

id.vector[1]

this.id <- id.vector[1]
this.id

data <- getData(this.id, xy.caribou.spdf.reloc)
data
nrow(data)

polXY <- as.matrix.extractPolygonPointsXY(caribou.poly)
polXY

df1 <- getData(id, xy.caribou.spdf.reloc)
head(df1)
nrow(df1)

df2<- getComplementData(id, xy.caribou.spdf.reloc)
head(df2)

k121 <- compute.k12hat(df1, df2, caribou.poly, caribou.scale)
k121

pdi <- compute.Individual.PDI (id, xy.caribou.spdf.reloc, caribou.poly, caribou.scale)
pdi

dt <- data.table(xy.caribou.spdf.reloc@data)

df <- xy.caribou.spdf.reloc@data

f1 <- as.data.frame(id.vector)

newdf <-data.frame(data.frame(row.names=1:21))

x <- as.data.frame(cbind(c(id.vector)))
x

df3 <- with (f1,cbind(newdf, compute.Individual.PDI (id.vector, xy.caribou.spdf.reloc, caribou.poly, caribou.scale)))

df$id

mf = as.data.frame(cbind(s,s,s,s,s))

mf = mf*0
count <- 0
test <- newdf

tmpdf <-data.frame(data.frame(row.names=1:21))


for (id in id.vector) {
    
    print (id)
    tmp = as.numeric(compute.Individual.PDI(id, xy.caribou.spdf.reloc, caribou.poly, caribou.scale))
    tmpdf <- cbind(tmpdf, id = tmp)
    
}

tmpdf

maxC1 = apply(tmpdf,1,max) #out of all five caribou, get max value for each row (spatial lag)
minC1 = apply(tmpdf,1,min) #out of all five caribou, get min value for each row (spatial lag)
meanC1 = apply(tmpdf,1,mean)    #for all five caribou, get mean for each row (spatial lag])
seC1 =apply(tmpdf,1,se) #for all five caribou, get standard deviation for each row (spatial lag)	 

maxC1
maxC

identical(maxC1, maxC)

minC1
minC

meanC1
meanC

seC1
seC

maxC1
maxC

