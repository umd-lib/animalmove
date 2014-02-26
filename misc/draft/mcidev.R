
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

sampleds <- puechabonsp
reloc <- sampleds$relocs
reloc@data$time.lag <- 365
reloc@data[1:50,5] <- 200

df <- reloc
str(df)

# test Spatial Point  Data.Frame
res <- .mci.spatial.index.SpatialPointsDataFrame(df, group.by = c("Name"), time.lag = c("time.lag"))
# display result
head(res)

# call using generic method
mci.index(df, group.by = c("Name"), time.lag = c("time.lag"))

sampleds <- puechabonsp
reloc <- sampleds$relocs
reloc@data$type <- "type1"
reloc@data[1:50,5] <- "type2"
head(reloc, 53)
dataIn <- reloc

pop.data <- Individuals(dataIn, group.by = c("type"))

pop.data@data$time.lag <- 365
pop.data@data[1:50,6] <- 200

str(pop.data)

as.data.frame(pop.data)

group.by = colnames(populations(pop.data))
index.group.by = grep(group.by, colnames(pop.data@data))

# call using generic method
#mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

#.mci.spatial.index.InduvidualsDataFrame(pop.data, group.by = c("type"), time.lag = c("time.lag"))
