loadandinstall <- function(mypkg) {if (!is.element(mypkg, installed.packages()[,1])){install.packages(mypkg)}; library(mypkg, character.only=TRUE)  }

loadandinstall("chron") #Don't worry about warning message, saying that this package was bulit for a older version of R
loadandinstall("splancs")
loadandinstall("adehabitat")
loadandinstall("pgirmess")
loadandinstall("sciplot")
loadandinstall("maptools")
loadandinstall("sp")
loadandinstall("lme4")
loadandinstall("languageR")
loadandinstall("MASS")
loadandinstall("Hmisc")

################################################################################################
################################################################################################
#
# Part two: Set working directory 
#           Read in data
#           Define plotting defaults
#          
################################################################################################
################################################################################################


###################################################
# Step 1: Set the working directory 
setwd("/apps/animalmv/data")
setwd("/apps/animalmv/data")
list.files() #look at the files in your current directory

###################################################
# Step 2: Read in the data

# DATA SET 1
# This data set has been preprocessed to include intervals that are mulitples of 16 days, 
# most intervals are 16 days, by there may be some 32 day intervals included too.
# It included the five individuals for each species. 
# This data set wil be used to calculate RMI and PDI
caribou<-read.csv("16_day_5_individuals_data_Caribou.csv")
gazelle<-read.csv("16_day_5_individuals_data_Gazelle.csv")
moose<-read.csv("16_day_5_individuals_data_Moose.csv")
guanaco<-read.csv("16_day_5_individuals_data_Gaunaco.csv")
head(guanaco)#look at data, to see if it displays correctly

# DATA SET 2
# This data set has been preprocessed to include equally spaced 16 day intervals, 
# for the same five individuals, but for a one year period only
# This data set is used to calculate individual annual movement
caribouPure <- read.csv("16_dayPure_Caribou.csv")
gazellePure <- read.csv("16_dayPure_Gazelle.csv")
guanacoPure <- read.csv("16_dayPure_Gaunaco.csv")
moosePure <- read.csv("16_dayPure_Moose.csv")


# DATA SET 3
# This dataset is similar to data set 2, 
# But has the same start and end date for each individual
# This data set is used to calculate the movement coordination index (MCI)  
# Since the sample size for guanacos is too small, guanacos are excluded in MCI analysis
caribouPure5<-read.csv("16_dayPure_5_Caribou.csv")
gazellePure5<-read.csv("16_dayPure_5_Gazelle.csv")
moosePure5<-read.csv("16_dayPure_5_Moose.csv")

#############################################
# Step 3: 
# Setting default values

#Choose default colors
colorCaribou = "pink" 
colorGazelle = "lightblue"
colorGuanaco = "khaki1"#"#FFFF99"
colorMoose = "lightgreen"
colorCaribou2 = "red" 
colorGazelle2 = "blue"
colorGuanaco2 =  "darkorange"
colorMoose2 = "darkgreen"

#Choose magnification size (can be used to change font size, axis width, line length, etc)
cexValue = 2

#Default margin size
par(mar = c(5, 7, 2, 0))

#Default number of panels in plotting window
par(mfrow = c(1,1))


################################################################################################
################################################################################################
#
# Part 4: Calculate Realized Mobility Index 
#
################################################################################################
################################################################################################

#############################################
# Step 1:
# Calculate area of the population-wide Minimum convex polygon (MCP) for each species

allCaribouMCP = with(caribou, mcp.area(as.data.frame(cbind(xAlaskaAlb*1000,yAlaskaAlb*1000)),
                                       as.factor(rep(1,nrow(caribou))),
                                       unin = "m", unout = "km2",percent = 100, plotit = F))
allGazelleMCP = with(gazelle, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                                       as.factor(rep(1,nrow(gazelle))),
                                       unin = "m", unout = "km2",percent = 100, plotit = F))
allGuanacoMCP = with(guanaco, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                                       as.factor(rep(1,nrow(guanaco))),
                                       unin = "m", unout = "km2",percent = 100, plotit = F))
allMooseMCP = with(moose, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                                   as.factor(rep(1,nrow(moose))),
                                   unin = "m", unout = "km2",percent = 100, plotit = F))

# Now lets compare the Minimum Convex Polygon areas of these species
barplot(as.numeric(c(allCaribouMCP[1], allGazelleMCP, allGuanacoMCP, allMooseMCP)), names.arg=c("Caribou", "Gazelle", "Guanaco", "Moose"), col=c(colorCaribou,colorGazelle,colorGuanaco,colorMoose))

# Which population uses the most space? 
# Compare this to Annual movements of individuals (see Part 3), do these results make sense to you?

###############################################
# Step 2: 
# Calculate the areas of individual animal MCPs

cMCP = with(caribou, mcp.area(as.data.frame(cbind(xAlaskaAlb*1000,yAlaskaAlb*1000)),
                              as.factor(as.character(uniqueID)),unin = "m", unout = "km2",percent = 100, plotit = F))
gMCP = with(gazelle, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                              as.factor(as.character(id_argos)),unin = "m", unout = "km2",percent = 100, plotit = F))
guMCP = with(guanaco, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                               as.factor(as.character(uniqueID)),unin = "m", unout = "km2",percent = 100, plotit = F))
mMCP = with(moose, mcp.area(as.data.frame(cbind(xm*1000,ym*1000)),
                            as.factor(as.character(uniqueID)),unin = "m", unout = "km2",percent = 100, plotit = F))

##############################################
# Step 3:
# Putting it altogether to calculate Realized Mobility Index (RMI)

# Get RMI for each individual animal
RMI = c(as.matrix(gMCP/allGazelleMCP[1,1])[1,], as.matrix(cMCP/allCaribouMCP[1,1])[1,], 
        as.matrix(guMCP/allGuanacoMCP[1,1])[1,], as.matrix(mMCP/allMooseMCP[1,1])[1,])

# Combine these values with species labels
RMIx = c(rep("M. gazelle",5), rep("Caribou",5), rep("Guanaco",5),rep("Moose",5))
RMIdata=as.data.frame(cbind(RMI, RMIx))

# Data summary
tapply(RMI,RMIx,summary)

##############################################
# Step 4: 
# Displaying the data

#change plotting margins
par(mar = c(5, 5, 2, 0))
x = 1:4
RMIx = rep(c(2,1,3,4), each = 5)

#Plot axes
stripchart(RMI~RMIx, col = NA,xlim = c(.8,5), 
           cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
           vertical = T,ylab = "Realized mobility index", xlab = "Species",
           group.names = c("Caribou","Gazelle","Guanaco","Moose"), ylim = c(0,0.8))

#Plot Points
points(jitter(RMIx,.3), RMI,col= rep(c(colorGazelle2,colorCaribou2,colorGuanaco2,colorMoose2),
                                     each = 5),bg=  rep(c(colorGazelle,colorCaribou,colorGuanaco,colorMoose),each = 5),
       pch = 25,cex = cexValue+2,lwd = 2)

