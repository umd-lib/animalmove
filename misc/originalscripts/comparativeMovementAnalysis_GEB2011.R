################################################################################################
#Reference: 
#Mueller T., K. A. Olson, G. Dressler, P. Leimgruber, T. K. Fuller, C. Nicolson, A. J. Novaro,
#M. J. Bolgeri, D. Wattles, S. DeStefano, and W. F. Fagan. 
#2011. 
#How landscape dynamics link individual- to population-level movement patterns: 
#a multispecies comparison of ungulate relocation data. 
#Global Ecology and Biogeography, 20, 683–694.
#
# original version by Thomas Mueller, modified and commented by: Ellen Aikens
################################################################################################




################################################################################################
################################################################################################
#
# Part one: Install and load packages
#
################################################################################################
################################################################################################

# The line of code below creates a function, which checks if a package is already installed
# If it is not installed, the function installs the package and loads it, 
# If it is already installed, it just loads the package
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
setwd("/apps/git/animalmove/misc/originaldata")
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
# Part 3: Annual Movement
#
################################################################################################
################################################################################################

#########################################
# Step 1:
# Data Prep and formatting

#Note that daysToFind goes over 365 days, meaning that data spands more then one year
summary(caribouPure)  

#The line of code below deals with this,
#If daysToFind is greater then 365, subtract 365
#If not, don't change the value
#then this is organized into a data frame containing: 
#the animal's ID, distance between relocations and days of the year (1-365)
distC = with(caribouPure, as.data.frame(cbind(uniqueID, dist, 
        ifelse(daysToFind>365, daysToFind-365, daysToFind))))
names(distC) = c("id","dist", "dayOfYear") #change names of column labels
distC = distC[is.na(distC$id)==F,] #remove rows with missing values
summary(distC)

#repeat for guanacos
distGu = with(guanacoPure, as.data.frame(cbind(uniqueID, dist, 
         ifelse(daysToFind>365, daysToFind-365, daysToFind))))
names(distGu) = c("id","dist", "dayOfYear")
distGu = distGu[is.na(distGu$id)==F,]
head(distGu)

#repeat for gazelles
distG = with(gazellePure, as.data.frame(cbind(id, dist, 
        ifelse(daysToFind>365, daysToFind-365, daysToFind))))
names(distG) = c("id","dist", "dayOfYear")
distG = distG[is.na(distG$id)==F,]
head(distG)

#repeat for moose
distM = with(moosePure, as.data.frame(cbind(uniqueID, dist, 
        ifelse(daysToFind>365, daysToFind-365, daysToFind))))
names(distM) = c("id","dist", "dayOfYear")
distM = distM[is.na(distM$id)==F,]
head(distM)


##############################################
# Step 2: 
# Bootstrap distances moved  
# (data for different species calculated at differnt temporal scales)

i = 23 #set sample size

# For each of the animal id's, get a sample 23 distances moved, calculate the sum 
# And then replicate this process 1000 times (bootstrapping)
distGSample = replicate(1000, apply(do.call(rbind,
              as.list(tapply(distG$dist, distG$id, sample, size = i, replace = T ))), 1, sum))
distGuSample = replicate(1000, apply(do.call(rbind,
               as.list(tapply(distGu$dist, distGu$id, sample, size = i, replace = T ))), 1, sum))
distMSample = replicate(1000, apply(do.call(rbind,
              as.list(tapply(distM$dist, distM$id, sample, size = i, replace = T ))), 1, sum))
distCSample = replicate(1000, apply(do.call(rbind,
              as.list(tapply(distC$dist, distC$id, sample, size = i, replace = T ))), 1, sum))

head(distGSample) #look at results

#############################################
# Step 3: 
# Summarize results

summary(apply(distCSample, 1, mean))
summary(apply(distGSample, 1, mean))
summary(apply(distGuSample, 1, mean))
summary(apply(distMSample, 1, mean))


#############################################
# Step 4: 
# Display data

#Y values are the mean of the bootstrap for each individual
y = c(apply(distCSample, 1, mean),
      apply(distGSample, 1, mean),
      apply(distGuSample, 1, mean),
      apply(distMSample, 1, mean))
names(y)= rep(c("gazelle", "caribou","guanaco","moose"),each = 5)

#X - a numeric value for each species (i.e 1 for caribou, 2 for gazelle, etc) 
x = rep(c(1,2,3,4), each = 5)

#plot axes
stripchart(y~x, col = NA,xlim = c(.8,5),  group.names = c("Caribou","Gazelle","Guanaco","Moose"),
          cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
          vertical = T, ylab = "Annual movement (km)", xlab = "Species")
#plot points
points(jitter(x,ifelse(names(y)=="moose",2,.3)),y,
      col= rep(c(colorCaribou2,colorGazelle2,colorGuanaco2,colorMoose2),each = 5),
      bg=  rep(c(colorCaribou,colorGazelle,colorGuanaco,colorMoose),each = 5),
      pch = 25,cex = cexValue+2,lwd = 2)

# Which species moves the most? 
# Does this make sense from what we know about the movement strategies of each species? 
# Would you expect annual movements of these species to vary significantly between years? why or why not?

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

# Are there certain species that have consisent RMI between individuals?
# Are there other species that have more variable RMI between individuals? 
# What might be responsible for these differences? 

################################################################################################
################################################################################################
#
# Part5: Movement Coordination Index
#
################################################################################################
################################################################################################

#############################################
# Step 1: 
# Define a function that calculates the standardized absolute distance from the mean
# i.e.  sum((observation - mean)/observation ) 
ADM = function(x)
  {
    absoluteDistanceOfMean = 0
    for(i in 1:length(x))
      {
        absoluteDistanceOfMean = absoluteDistanceOfMean+abs(x[i] - mean(x))
      }
    absoluteDistanceOfMean = absoluteDistanceOfMean/length(x)
    standardizedAbsoluteDistanceOfMean = absoluteDistanceOfMean/mean(abs(x))
    return(standardizedAbsoluteDistanceOfMean)
  }

#############################################
# Step 2: 
# Calculate movement coordination index 

#Find absolute distance from mean in the X and Y directions for each individual
coefMadXG = with(gazellePure5,(tapply(dist2X,daysToFind,ADM)))
coefMadXC = with(caribouPure5,(tapply(dist2X,daysToFind,ADM)))
coefMadXM = with(moosePure5,(tapply(dist2X,daysToFind,ADM))) 
coefMadYG = with(gazellePure5,(tapply(dist2Y,daysToFind,ADM)))
coefMadYC = with(caribouPure5,(tapply(dist2Y,daysToFind,ADM)))
coefMadYM = with(moosePure5,(tapply(dist2Y,daysToFind,ADM)))

#Calculate movement coordination index for Gazelle, Caribou and Moose
madG = 1- ((coefMadXG  + coefMadYG)/2) 
madC = 1- ((coefMadXC  + coefMadYC)/2)
madM = 1- ((coefMadXM  + coefMadYM)/2)

#Combine species/individual MCI data in a data frame
datsCoordination = as.data.frame(cbind(c(madC, madG, madM), c(rep("Caribou",length(madC)), rep("M. gazelle",length(madG)), rep("Moose",length(madM)))))
names(datsCoordination) = c("index","species")
datsCoordination = datsCoordination[is.na(datsCoordination$index) == F, ]
datsCoordination$index = as.numeric(as.character(datsCoordination$index ))


#################################################
# Step 3:
# Display results

#Change plotting margins
par(mar = c(5, 5, 2, 1))

boxplot(index~species, names = c("Caribou","Gazelle","Moose"), data = datsCoordination, 
        col = c(colorCaribou,colorGazelle,colorMoose), 
        border =c(colorCaribou2,colorGazelle2,colorMoose2),
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)

#Add baseline 
lines(c(.7,3.3), c(0,0), lwd = 2, lty = 1, col = 1) 

# Which species show the highest movement coordination?  


###############################################
# Step 4: 
# Statistical analysis of MCI 

#Analysis of variance
m1= aov(index~species, data = datsCoordination)
summary(m1)

#Tukey honest significant difference test
TukeyHSD(m1)

#Kruskal-Wallis Rank Sum Test
kruskal.test(index~species, data = datsCoordination)
#Multiple comparison test
kruskalmc(datsCoordination$index,datsCoordination$species)

# Which species are significantly different in their movement coordination? 
# What might explain these differences? 
# Does this make sense in terms of what we know about each species movement strategies? 


################################################################################################
################################################################################################
#
# Part 6: Population Dispersion Index (PDI)
#
################################################################################################
################################################################################################

#############################################
# Step 1: 
# Calculate minimum covex polygon for each species

par(mfrow=c(2,2)) #change number of panels in the plotting window (2X2, so 4 panels total)

caribouPoly = with(caribou, mcp(as.data.frame(cbind(xAlaskaAlb*1000,yAlaskaAlb*1000)),
              as.factor(rep(1,nrow(caribou))), percent = 100))
plot(caribouPoly)
caribouPoly = cbind(caribouPoly[,2],caribouPoly[,3])
head(caribouPoly)

gazellePoly = with(gazelle, mcp(as.data.frame(cbind(xm*1000,ym*1000)),
              as.factor(rep(1,nrow(gazelle))),percent = 100))
plot(gazellePoly)
gazellePoly = cbind(gazellePoly[,2],gazellePoly[,3])


guanacoPoly = with(guanaco, mcp(as.data.frame(cbind(xm*1000,ym*1000)),
              as.factor(rep(1,nrow(guanaco))),percent = 100))
plot(guanacoPoly)
guanacoPoly = cbind(guanacoPoly[,2],guanacoPoly[,3])


moosePoly = with(moose, mcp(as.data.frame(cbind(xm*1000,ym*1000)),
            as.factor(rep(1,nrow(moose))),percent = 100))
plot(moosePoly)
moosePoly = cbind(moosePoly[,2],moosePoly[,3])


##################################################################
# Step 2:
# Calculate population dispersion index for each species

# different sequences of spatial lag, depending on movement scale of species
s = seq(0,100000,5000) #caribou and gazelles
s2 = seq(0,10000,500) #moose
s3 = seq(0,15000,500) #guanaco

##########################
# Caribou

l = as.data.frame(cbind(s,s,s,s,s))
l=l*0

# This loop iterates through each caribou, 
# comparing the points of each caribou, to the points of all the remaining caribou, 
# with the bivariate K-function, then uses this to calculate the PDI
counter = 1
for(i in unique(as.character(caribou$uniqueID)))
  {
  	# Points of one caribou
    pC1 = as.points(caribou[as.character(caribou$uniqueID) ==i,]$xAlaskaAlb*1000, 
          caribou[as.character(caribou$uniqueID) ==i,]$yAlaskaAlb*1000)
    
    #points of all other caribou
    pC2 = as.points(caribou[as.character(caribou$uniqueID) !=i,]$xAlaskaAlb*1000, 
          caribou[as.character(caribou$uniqueID) !=i,]$yAlaskaAlb*1000)
  	
    #calculate bivariate k-function
    k = k12hat(pC1,pC2, caribouPoly, s)
  
    #populates a column of the l dataframe with population dispersion index for selected caribou
    l[,counter] = s - sqrt(k/pi)
  	
    counter = counter +1
	}

l
maxC = apply(l,1,max) #out of all five caribou, get max value for each row (spatial lag)
minC = apply(l,1,min) #out of all five caribou, get min value for each row (spatial lag)
meanC = apply(l,1,mean)	#for all five caribou, get mean for each row (spatial lag])
seC =apply(l,1,se) #for all five caribou, get standard deviation for each row (spatial lag)	 

##########################################
# Reapeat steps above for the gazelles

# Create empty dataframe, which is populated in the loop below
l = as.data.frame(cbind(s,s,s,s,s))
l=l*0
counter = 1

#Iterate through each Gazelle, to calcualte PDI 
for(i in unique(as.character(gazelle$id)))
  {
  	pG1 = as.points(gazelle[as.character(gazelle$id) ==i,]$xm*1000, 
          gazelle[as.character(gazelle$id) ==i,]$ym*1000)
  	pG2 = as.points(gazelle[as.character(gazelle$id) !=i,]$xm*1000, 
          gazelle[as.character(gazelle$id) !=i,]$ym*1000)
  	k = k12hat(pG1,pG2, gazellePoly, s)
  	l[,counter] = s - sqrt(k/pi)
  	counter = counter +1
	}

#Calcualte max, min, mean and standard devation for all gazelle's PDI at different spatial lags
maxG = apply(l,1,max)
minG = apply(l,1,min)
meanG = apply(l,1,mean)	
seG =apply(l,1,se)	 

#########################################
# Reapeat for guanacos

# Create empty dataframe, which is populated in the loop
l = as.data.frame(cbind(s3,s3,s3,s3,s3))
l=l*0
counter = 1

#Iterate through each guanaco, to calcualte PDI 
for(i in unique(as.character(guanaco$uniqueID)))
  {
  	pG1 = as.points(guanaco[as.character(guanaco$uniqueID) ==i,]$xm*1000, 
          guanaco[as.character(guanaco$uniqueID) ==i,]$ym*1000)
  	pG2 = as.points(guanaco[as.character(guanaco$uniqueID) !=i,]$xm*1000, 
          guanaco[as.character(guanaco$uniqueID) !=i,]$ym*1000)
  	k = k12hat(pG1,pG2, guanacoPoly, s3)
  	l[,counter] = s3 - sqrt(k/pi)
  	counter = counter +1
	}

#Calcualte max, min, mean and standard devation for all guanaco's PDI at different spatial lags
maxGu = apply(l,1,max)
minGu = apply(l,1,min)
meanGu = apply(l,1,mean)	
seGu =apply(l,1,se)	 

######################################
# Reapeat for moose

# Create empty dataframe, which is populated in the loop
l = as.data.frame(cbind(s2,s2,s2,s2,s2))
l=l*0
counter = 1
for(i in unique(as.character(moose$uniqueID)))
  {
  	pG1 = as.points(moose[as.character(moose$uniqueID) ==i,]$xm*1000, 
          moose[as.character(moose$uniqueID) ==i,]$ym*1000)
  	pG2 = as.points(moose[as.character(moose$uniqueID) !=i,]$xm*1000, 
          moose[as.character(moose$uniqueID) !=i,]$ym*1000)
  	k = k12hat(pG1,pG2, moosePoly, s2)
  	l[,counter] = s2 - sqrt(k/pi)
  	counter = counter +1
	}

#Calcualte max, min, mean and standard devation for all moose's PDI at different spatial lags
maxM = apply(l,1,max)
minM = apply(l,1,min)
meanM = apply(l,1,mean)	
seM =apply(l,1,se)	 

###############################################
# Step 3:
# Display Results

# Change number of panels in the plotting window back to a single panel
par(mfrow=c(1,1))

# Change margin size 
par(mar = c(5, 5, 2, 1)) 

#For plotting purposes, we need to reverse some of our vectors, using rev() command
Rs = rev(s)
X = c(s,Rs)
Rs2 =  rev(s2)
Rs3 =  rev(s3)
X2 = c(s2,Rs2)
X3 = c(s3,Rs3)
RSe = rev(meanC-seC)
Y = c(meanC+seC,RSe)

# Create empty plot, with axes labels
plot(s, meanG, ylim = c(-25000,5000), xlim = c(0,50000), col = NA,  
     ylab = "Population dispersion index", xlab = "lag (km)",
     cex.lab = cexValue, cex.axis = cexValue,cex = cexValue, axes = F)

#Add caribou data
polygon(X, Y, col = colorCaribou, border = NA) # plots CI's
lines(s,meanC,col = colorCaribou2, lwd = 2) # plots PDI

#Add gazelle data
RSe = rev(meanG-seG)
Y = c(meanG+seG,RSe)
polygon(X, Y, col = colorGazelle, border = NA) # plots CI's
lines(s,meanG,col = colorGazelle2, lwd = 2) # plots PDI

# Add Moose data
RSe = rev(meanM-seM)
Y = c(meanM+seM,RSe)
polygon(X2, Y, col = colorMoose, border = NA)# plots CI's
lines(s2,meanM,col = colorMoose2, lwd = 2) #plots PDI

# Add guanaco data
RSe = rev(meanGu-seGu)
Y = c(meanGu+seGu,RSe)
polygon(X3, Y, col = colorGuanaco, border = NA)# plots CI's
lines(s3,meanGu,col = colorGuanaco2, lwd = 2) #plots PDI

lines(c(0,100000),c(0,0),lwd = 2, lty = 1) # add baseline
lines(s,meanC,col = colorCaribou2, lwd = 2)# re-add caribou PDI (got covered up by guanaco CIs)
lines(s,meanG,col = colorGazelle2, lwd = 2)# re-add gazelle PDI 

#Add axes
axis(1, at=seq(0,50000,10000),labels = seq(0,50,10), cex.axis = cexValue)
axis(2,at = seq(-25000,5000,10000), cex.axis= cexValue)

#Add legend
legend(-1000,-18000, legend = c("Caribou (C)", "M. gazelle (MG)", "Guanaco (G)","Moose (M)"), col = c( colorCaribou2,colorGazelle2, colorGuanaco2,colorMoose2), 
       box.lty= 0,lty = 1, lwd = 3, cex = cexValue, bg = NA)

#PDI close to 0 indicated randomness
#PDI above zero indicate dispersion
#PDI below zero indicate clustering 
#Interpret the PDI figure and discuss what factor might be responsible for the differences between species?

