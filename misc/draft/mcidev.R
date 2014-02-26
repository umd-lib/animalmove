
require(sqldf)
require(adehabitatHR)
require(sp)
require(data.table)
require(RColorBrewer)

library(adehabitatHR)
library(sp)
library(sqldf)
library(data.table)
library(RColorBrewer)

source('/apps/git/animalmove/R/Class-Individuals.R', echo=TRUE)
source('/apps/git/animalmove/R/Individuals-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/MovementAnalysis-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/RMI-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/Class-RMI.R', echo=TRUE)
source('/apps/git/animalmove/R/MCI-methods.R', echo=TRUE)


# compute absolute distance

x <- as.numeric(c(1,2, 3, 4 ))
abs.dist <- abs.std.mean(x)

# display abs.dist
abs.dist

# Test MCI on the Spatial Points Dataframe
sampleds <- puechabonsp
reloc <- sampleds$relocs
reloc@data$time.lag <- 365
reloc@data[1:50,5] <- 200

df <- reloc
str(df)

# test Spatial Point  Data.Frame - call internal 
res <- .mci.spatial.index.SpatialPointsDataFrame(df, group.by = c("Name"), time.lag = c("time.lag"))
# display result
head(res)

# call using generic method
res< -mci.index(df, group.by = c("Name"), time.lag = c("time.lag"))

# display result
head(res)

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


group.by = colnames(populations(pop.data))
index.group.by = grep(group.by, colnames(pop.data@data))

# test - call using generic method
res.ind <- mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

# display data
head(res.ind)

# test - call using internal function
res.ind <- .mci.spatial.index.InduvidualsDataFrame(pop.data,  time.lag = c("time.lag"))
# display data
head(res.ind)

# Create MCIndex object
mci.object <- MCIndex(res.ind)

# Compute ANOVA stats
aov.mci(mci.object)