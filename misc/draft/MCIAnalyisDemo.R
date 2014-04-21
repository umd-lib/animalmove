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

rmi.data <- subsample(khulan.test.data, start=c("2009-07-20 00:00"),end="2009-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=5,mustIndiv=NULL,index.type="rmi")

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

dt.rmi.data.attr  <- dt.allpopulations[, list(id=id, pop.type=pop.type, time=time, time.lag=time.lag, age=age, elevation= elevation, behaviour = behaviour)]

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

# Movement Coordination Index

data(puechabonsp)

# compute absolute distance

x <- as.numeric(c(1,2, 3, 4 ))
abs.dist <- abs.std.mean(x)

# display abs.dist
abs.dist


# Test MCI on the Individuals object
ind.ds <- puechabonsp
ind.reloc <- ind.ds$relocs
ind.reloc@data$type <- "type1"
ind.reloc@data[1:50,5] <- "type2"
head(ind.reloc, 53)

pop.data <- Individuals(ind.reloc, group.by = c("type"))

pop.data@data$time.lag <- 365
pop.data@data[1:50,6] <- 200

# display data population data
str(pop.data)

pop.data

group.by = colnames(populations(pop.data))
index.group.by = grep(group.by, colnames(pop.data@data))

# test - call using generic method
res.ind <- mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

# display data
head(res.ind)


# Create MCIndex object
mci.object <- MCIndex(res.ind)

mci.object

# Compute ANOVA stats

anova.model <- aov(mci.object)

# display anova
anova.model

# TukeyHSD from model
TukeyHSD(anova.model)

TukeyHSD(mci.object)

kruskal.test(mci.object)

#End Movement Coordination Index


# Population Dispersion Index

# load data
data(caribou.reloc.16day.5indiv)
data(gazelle.reloc.16day.5indiv)
data(moose.reloc.16day.5indiv)
data(guanaco.reloc.16day.5indiv)

caribou.scale = seq(0,100000,5000) #caribou and gazelles
gazelle.scale = caribou.scale
moose.scale = seq(0,10000,500) #moose
guanaco.scale = seq(0,15000,500) #guanaco


# create PDIndex for each specie
pdi.index.caribou <- pdi.index(caribou.reloc.16day.5indiv, percent = 100, caribou.scale, unin = "m", unout = "km2")
pdi.index.gazelle <- pdi.index(gazelle.reloc.16day.5indiv, percent = 100, gazelle.scale, unin = "m", unout = "km2")
pdi.index.guanaco <- pdi.index(guanaco.reloc.16day.5indiv, percent = 100, guanaco.scale, unin = "m", unout = "km2")
pdi.index.moose <- pdi.index(moose.reloc.16day.5indiv, percent = 100,   moose.scale, unin = "m", unout = "km2")

#Get summaries of each specie PDI

summary.caribou <- summary.pdi(pdi.index.caribou)
summary.gazelle <- summary.pdi(pdi.index.gazelle)
summary.guanaco <- summary.pdi(pdi.index.guanaco)
summary.moose <- summary.pdi(pdi.index.moose)

# Create X and Y axes for each species

# caribou
caribou.X <- c(summary.caribou$scale, rev(summary.caribou$scale))
caribou.Y <- c(summary.caribou$mean.pdi + summary.caribou$se.pdi, rev(summary.caribou$mean.pdi - summary.caribou$se.pdi))

# gazelle
gazelle.X <- c(summary.gazelle$scale, rev(summary.gazelle$scale))
gazelle.Y <- c(summary.gazelle$mean.pdi + summary.gazelle$se.pdi, rev(summary.gazelle$mean.pdi - summary.gazelle$se.pdi))

# guanaco
guanaco.X <- c(summary.guanaco$scale, rev(summary.guanaco$scale))
guanaco.Y <- c(summary.guanaco$mean.pdi + summary.guanaco$se.pdi, rev(summary.guanaco$mean.pdi - summary.guanaco$se.pdi))

# moose
moose.X <- c(summary.moose$scale, rev(summary.moose$scale))
moose.Y <- c(summary.moose$mean.pdi + summary.moose$se.pdi, rev(summary.moose$mean.pdi - summary.moose$se.pdi))


# Plot default settings

colorCaribou = "pink" 
colorGazelle = "lightblue"
colorGuanaco = "khaki1"#"#FFFF99"
colorMoose = "lightgreen"
colorCaribou2 = "red" 
colorGazelle2 = "blue"
colorGuanaco2 =  "darkorange"
colorMoose2 = "darkgreen"

cexValue = 2

cexValue = 1

# Change number of panels in the plotting window back to a single panel
par(mfrow=c(1,1))

# Change margin size 
#par(mar = c(5, 5, 2, 1)) 

# Create empty plot, with axes labels
plot(caribou.scale, summary.gazelle$mean.pdi, ylim = c(-25000,5000), xlim = c(0,50000), col = NA,  
     ylab = "Population Dispersion Index", xlab = "lag (km)",
     cex.lab = cexValue, cex.axis = cexValue,cex = cexValue, axes = F)

#Add caribou data
polygon(caribou.X, caribou.Y, col = colorCaribou, border = NA) # plots CI's

#Add gazelle data
polygon(gazelle.X, gazelle.Y, col = colorGazelle, border = NA) # plots CI's

# Add Moose data
polygon(moose.X, moose.Y, col = colorMoose, border = NA) # plots CI's

# Add guanaco data
polygon(guanaco.X, guanaco.Y, col = colorGuanaco, border = NA) # plots CI's


# Add lines
lines(summary.caribou$scale,summary.caribou$mean.pdi,col = colorCaribou2, lwd = 2) # plots PDI
lines(summary.gazelle$scale,summary.gazelle$mean.pdi,col = colorGazelle2, lwd = 2) # plots PDI
lines(summary.moose$scale,summary.moose$mean.pdi,col = colorMoose2, lwd = 2) # plots PDI
lines(summary.guanaco$scale,summary.guanaco$mean.pdi,col = colorGuanaco2, lwd = 2) # plots PDI


lines(c(0,100000),c(0,0),lwd = 2, lty = 1) # add baseline

#Add axes
axis(1, at=seq(0,50000,10000),labels = seq(0,50,10), cex.axis = cexValue)
axis(2,at = seq(-25000,5000,10000), cex.axis= cexValue)

#Add legend
legend(-1000,-18000, legend = c("Caribou (C)", "M. gazelle (MG)", "Guanaco (G)","Moose (M)"), col = c( colorCaribou2,colorGazelle2, colorGuanaco2,colorMoose2),        box.lty= 0,lty = 1, lwd = 3, cex = cexValue, bg = NA)
par(mfrow=c(2,2))
par(cex=0.35)
plot(pdi.index.caribou, col = colorCaribou, linecol = colorCaribou2, title = "Spatial Population Dispersion - Caribou, Kilometers")
plot(pdi.index.gazelle, col = colorGazelle, linecol = colorGazelle2, title = "Spatial Population Dispersion - Gazelle, Kilometers")
plot(pdi.index.moose, col = colorMoose, linecol = colorMoose2, title = "Spatial Population Dispersion - Moose, Kilometers")
plot(pdi.index.guanaco, col = colorGuanaco, linecol = colorGuanaco2, title = "Spatial Population Dispersion - Guanaco, Kilometers")