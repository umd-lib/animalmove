install.packages("sqldf")
require(sqldf)
require(adehabitatHR)
require(sp)

library(adehabitatHR)
library(sp)
library(sqldf)
data(puechabonsp)

source('/apps/git/animalmove/R/Class-Individuals.R', echo=TRUE)
source('/apps/git/animalmove/R/Individuals-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/MovementAnalysis-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/RMI-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/Class-RMI.R', echo=TRUE)

.populationType <- function(x1){
    type <- subset(x1, id == id, select = c("type"))[1,1]
    return(type)
}

sampleds <- puechabonsp
reloc <- sampleds$relocs
reloc@data$type <- "type1"
reloc@data[1:50,5] <- "type2"
head(reloc, 53)
dataIn <- reloc

pop.data <- Individuals(dataIn, group.by = c("type"))
str(pop.data)

# compute individual mcp
individual.mcp <- mcp(pop.data[,1], percent = 100)

# display mcp
individual.mcp

# compute population mcp
population.mcp <- mcp.population(pop.data, percent = 100)

# display mcp
population.mcp

# compute RMIndex object that is a data.frame

rmi.df <- compute.RealizedMobilityIndex(pop.data, percent = 100,
                                           id="Name")

# display rmi.df
rmi.df

# compute RMIndex from Individuals class 
rmi.index.pop <- rmi.index(pop.data, percent = 100, id = "Name")
# display rmi index for the Individuals class
# The numbers should match to the rmi.df

rmi.index.pop


#colnames(df)[colnames(df)=="Name"] <- "id"

# construct RMIndex from rmi.index data frame

rmiData <- as.data.frame(rmi.index.pop) # analog to the RMIdata

str(rmiData)

# factor for the RMIndex is a population labels

rmi.factor <- as.factor(rmiData$pop.type)

# display rmi factor
rmi.factor

# get summary of the rmi.index by the population type
# analog is tapply(RMImatrix, rmiData$pop.type, summary)

tapply(rmiData$rmi.index, rmiData$pop.type, summary)

rmi.object <- RMIndex(rmi.index.pop)

summary.rmi(rmi.object)

summary.rmi(rmi.index.pop)

par(mar = c(5,5, 2,0))
x = 1:4

xx= c(2,1,3,4)
#Plot axes
stripchart(as.numeric(rmiData$rmi.index)~rmiData$id
           , col = NA,xlim = c(.8,5), 
           cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
           vertical = T,ylab = "Realized mobility index", xlab = "Species",
           group.names = as.character(rmiData$pop.type),
           ylim = c(0,0.8))

#Plot Points

points(jitter(as.numeric(rmiData$id),.3), rmiData$rmi.index,col= rep(c(colorGazelle2,colorCaribou2,colorGuanaco2,colorMoose2),
                                     each = 5),bg=  rep(c(colorGazelle,colorCaribou,colorGuanaco,colorMoose),each = 5),
       pch = 25,cex = cexValue+2,lwd = 2)

#points(jitter(rmiData$rmi.index, 0.5)~factor(pop.type), data = rmiData,col= rep(c(colorGazelle2,colorCaribou2,colorGuanaco2,colorMoose2),
 #                                                                    each = 5),bg=  rep(c(colorGazelle,colorCaribou,colorGuanaco,colorMoose),each = 5),
  #     pch = 25,cex = cexValue+2,lwd = 2)

