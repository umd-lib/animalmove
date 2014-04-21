# Demo script based on Khulan Data

#Load Khulan Data
# Khulan data has been saved in the data directory, and loaded on the package load
# khulan.raw.data - original khulan data
# khulan.test.data - enhanced data frame with a column pop.type, which indicates specie type
# Individuals with ids 3,4,7 assigned to the specie1 type, and the rest is identified as specie2 type

# Examine khulan.test.data
head(khulan.test.data)

# Number of rows in the khulan.test.data
nrow(khulan.test.data)

#Preprocess data & subsample data

pdi.data <- subsample(khulan.test.data, start=c("2009-01-01 00:00"),end="2009-12-31 00:00",interval=c("50 hours"),accuracy=c("3 mins"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="pdi")

head(pdi.data)
# Number of rows in subsampled data
nrow(pdi.data)

#Prepare data for the analysis

# Create attribute data frame
dt.pdi.data <- data.table(pdi.data)

dt.pdi.data.attr  <- dt.pdi.data[,list(id=id, pop.type=pop.type, x=X,y=Y, time=time, time.lag=time.lag, age=age, elevation= elevation, behaviour = behaviour)]
str(dt.pdi.data.attr)

# Subset species 1
dt.pdi.data.species1 <- dt.pdi.data.attr[pop.type=="species1"]

# Subset species 2
dt.pdi.data.species2 <- dt.pdi.data.attr[pop.type=="species2"]

# Create spatial coordinates - Specie1
dt.pdi.data.specie1.xy <- dt.pdi.data.species1[, list(x,y)]
str(dt.pdi.data.specie1.xy)

# Create spatial coordinates - Specie2
dt.pdi.data.specie2.xy <- dt.pdi.data.species2[, list(x,y)]
str(dt.pdi.data.specie2.xy)

color = "green"
# Specie 1
#Create spatial points
xy.sp.pdi.data.specie1 <- SpatialPoints(dt.pdi.data.specie1.xy)

# Create spatial points data frame with attributes
xy.pdi.data.spdf.specie1 <- SpatialPointsDataFrame(xy.sp.pdi.data.specie1, dt.pdi.data.species1)
str(xy.pdi.data.spdf.specie1)

# Create Individuals data.frame - relocations of khulan data
khulan.reloc.specie1.spatial <- Individuals(xy.pdi.data.spdf.specie1, group.by="pop.type")
str(khulan.reloc.specie1.spatial)

bbox.coord1<- bbox.coordinates(khulan.reloc.specie1.spatial, percent = 100, unin = "m", unout = "km2")

specie1.scale <- bbox.scale(khulan.reloc.specie1.spatial, percent = 100, unin = "m", unout = "km2")
specie1.scale

# Specie1.poly
specie1.poly <- mcp.population(khulan.reloc.specie1.spatial, percent = 100)

plot(specie1.poly, col = color, axes = TRUE)
points(khulan.reloc.specie1.spatial, pch=3)
title(main="Specie1", xlab="X", ylab="Y")

color = "green"
# Specie 2
#Create spatial points
xy.sp.pdi.data.specie2 <- SpatialPoints(dt.pdi.data.specie2.xy)

# Create spatial points data frame with attributes
xy.pdi.data.spdf.specie2 <- SpatialPointsDataFrame(xy.sp.pdi.data.specie2, dt.pdi.data.species2)
str(xy.pdi.data.spdf.specie2)

# Create Individuals data.frame - relocations of khulan data
khulan.reloc.specie2.spatial <- Individuals(xy.pdi.data.spdf.specie2, group.by="pop.type")
str(khulan.reloc.specie2.spatial)

bbox.coord2<- bbox.coordinates(khulan.reloc.specie2.spatial, percent = 100, unin = "m", unout = "km2")
specie2.scale <- bbox.scale(khulan.reloc.specie2.spatial, percent = 100, unin = "m", unout = "km2")
specie2.scale

# Specie1.poly
specie2.poly <- mcp.population(khulan.reloc.specie1.spatial, percent = 100)

plot(specie2.poly, col = color, axes = TRUE)
points(khulan.reloc.specie2.spatial, pch=3)
title(main="Specie2", xlab="X", ylab="Y")

pdi.index.specie2 <- pdi.index(khulan.reloc.specie2.spatial, percent = 100, specie2.scale, unin = "m", unout = "km2")

#Get summaries of each specie PDI
summary.specie2 <- summary.pdi(pdi.index.specie2)
summary.specie2

# Create X and Y axes for each species

# Specie1
specie1.X <- c(summary.specie1$scale, rev(summary.specie1$scale))
specie1.Y <- c(summary.specie1$mean.pdi + summary.specie1$se.pdi, rev(summary.specie1$mean.pdi - summary.specie1$se.pdi))

cexValue = 2
cexValue = 1

colorSpecie1 = "pink" 
altColorSpecie1 = "red"

colorSpecie2 = "lightblue"
altcolorSpecie2 = "blue"

plot(pdi.index.specie1, col = colorSpecie1, linecol = altColorSpecie1, title = "Spatial Population Dispersion - Specie1, Kilometers")

# Specie2
specie2.X <- c(summary.specie2$scale, rev(summary.specie2$scale))
specie2.Y <- c(summary.specie2$mean.pdi + summary.specie2$se.pdi, rev(summary.specie2$mean.pdi - summary.specie2$se.pdi))

plot(pdi.index.specie2, col = colorSpecie2, linecol = altColorSpecie2, title = "Spatial Population Dispersion - Specie2, Kilometers")

