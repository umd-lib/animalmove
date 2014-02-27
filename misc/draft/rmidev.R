install.packages("sqldf")
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

data(puechabonsp)

source('/apps/git/animalmove/R/Class-Individuals.R', echo=TRUE)
source('/apps/git/animalmove/R/Individuals-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/MovementAnalysis-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/RMI-methods.R', echo=TRUE)
source('/apps/git/animalmove/R/Class-RMI.R', echo=TRUE)


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

# Default plot values

#Choose default colors
colorCaribou = "pink" 
colorGazelle = "lightblue"
colorGuanaco = "khaki1"#"#FFFF99"
colorMoose = "lightgreen"
colorCaribou2 = "red" 
colorGazelle2 = "blue"
colorGuanaco2 =  "darkorange"
colorMoose2 = "darkgreen"

par(mar = c(5,5, 2,0))
x = 1:4

cexValue = 2
xx= c(2,1,3,4)
#Plot axes
stripchart(as.numeric(rmiData$rmi.index)~rmiData$id
           , col = NA,xlim = c(.8,5), 
           cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
           vertical = T,ylab = "Realized mobility index", xlab = "Species",
           group.names = as.character(rmiData$pop.type),
           ylim = c(0,0.8))

# display stripchart in decreasing order by population home range
rmiDataSorted <- rmiData[with(rmiData, order(-rmi.index)),]
rmiDataSorted <- within(rmiDataSorted,pop.type <- factor(pop.type, levels=names(sort(table(pop.type), decreasing = TRUE))))
rmiDataSorted$pop.type <- reorder(rmiDataSorted$pop.type, -rmiDataSorted$rmi.index)

dt <- as.data.table(rmiDataSorted)
dt[,tmp.rank:=max(rmi.index),by=pop.type]

dt[,pop.rank:=rank(-tmp.rank)]

stripchart(rmi.index ~ factor(pop.type)
           , data = rmiDataSorted, col = NA,xlim = c(.8,5), 
           cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
           vertical = T,ylab = "Realized mobility index", xlab = "Species",
           ylim = c(0,0.8))

df <- as.data.frame(dt)
df <- within(df,pop.type <- factor(pop.type, levels=names(sort(table(pop.type), decreasing = TRUE))))
df$pop.type <- reorder(df$pop.type, df$pop.rank)

# strip chart again
stripchart(rmi.index ~ factor(pop.type)
           , data = df, col = NA,xlim = c(.8,5), 
           cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
           vertical = T,ylab = "Realized mobility index", xlab = "Species",
           ylim = c(0,0.8))

x <- jitter(as.integer(factor(as.integer(factor(df$pop.type)))),.3)
y <- df$rmi.index

index <- as.integer(factor(as.integer(factor(df$pop.type))))


fg.pal <- color.palette(length(unique(df$pop.type)))
bg.pal <- color.palette(length(unique(df$pop.type)), palette = c("Dark2"))  
df$color <- fg.pal[index]
df$bgcolor <- bg.pal[index]

# plot points
points(x, y ,col= df$color, bg =  df$bgcolor,
       pch = 25,cex = cexValue+2,lwd = 2)


