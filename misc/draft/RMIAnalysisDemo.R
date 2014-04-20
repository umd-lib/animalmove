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

rmi.data <- subsample(khulan.test.data, start=c("2009-01-01 00:00"),end="2009-12-31 00:00",interval=c("50 hours"),accuracy=c("3 mins"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="rmi")

head(rmi.data)

head(rmi.data)
# Number of rows in subsampled data
nrow(rmi.data)

#Prepare data for the analysis

# Create attribute data frame
dt.rmi.data <- data.table(rmi.data)

dt.rmi.data.attr  <- dt.rmi.data[,list(id=id, pop.type=pop.type, x=X,y=Y, time=time, time.lag=time.lag, age=age, elevation= elevation, behaviour = behaviour)]
str(dt.rmi.data.attr)

# Create spatial coordinates
dt.rmi.data.spatial <- dt.rmi.data[, list(x=X,y=Y)]
str(dt.rmi.data.spatial)

dt.rmi.data.xy <- dt.rmi.data.spatial[, list(x, y)]

str(dt.rmi.data.xy)

#Create spatial points
xy.sp.rmi.data <- SpatialPoints(dt.rmi.data.xy)

# Create spatial points data frame with attributes
xy.rmi.data.spdf <- SpatialPointsDataFrame(xy.sp.rmi.data, dt.rmi.data.attr)
str(xy.rmi.data.spdf)

# Create Individuals data.frame - relocations of khulan data
khulan.reloc.spatial <- Individuals(xy.rmi.data.spdf, group.by="pop.type")
str(khulan.reloc.spatial)

#save(allpopulations.spatial, file="/apps/git/animalmove/data/allpopulations.spatial.rda")

# End Load Data

# Realized Mobility Index

# compute individual mcp
individual.mcp <- mcp(khulan.reloc.spatial[,1], percent = 100)

# display mcp
individual.mcp

# compute population mcp
population.mcp <- mcp.population(khulan.reloc.spatial, percent = 100)

# display mcp
population.mcp

# compute RMIndex object that is a data.frame

rmi.index.pop <- rmi.index(khulan.reloc.spatial, percent = 100, id = "id")

rmi.object <- RMIndex(rmi.index.pop)

summary(rmi.object)

par(mar = c(5,5, 2,0))
plot(rmi.object)

#End Realizide Mobility Index
