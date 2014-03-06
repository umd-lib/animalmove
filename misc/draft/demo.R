caribou<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("/apps/git/animalmove/misc/originaldata/16_day_5_individuals_data_Gaunaco.csv")

#Load Data

# Caribou data

# Copy caribou data to the data table
dt.caribou <- data.table(caribou)

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

#save(allpopulations.spatial, file="/apps/git/animalmove/data/allpopulations.spatial.rda")

# End Load Data

# Realized Mobility Index
data(allpopulations.spatial)

# compute individual mcp
individual.mcp <- mcp(allpopulations.spatial[,1], percent = 100)

# display mcp
individual.mcp

# compute population mcp
population.mcp <- mcp.population(allpopulations.spatial, percent = 100)

# display mcp
population.mcp

# compute RMIndex object that is a data.frame

rmi.index.pop <- rmi.index(allpopulations.spatial, percent = 100, id = "id")

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