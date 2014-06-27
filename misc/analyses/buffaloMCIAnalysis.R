library(lubridate)
library(animalmove)
library(plyr)
library(ggplot2)

buffalodata <- read.csv("./data/buffalo.csv", stringsAsFactors = FALSE, header =TRUE)

str(buffalodata)
head(buffalodata)
nrow(buffalodata)

names(buffalodata)[names(buffalodata)=="timestamp"] <- "time"
names(buffalodata)[names(buffalodata)=="utm.easting"] <- "x"
names(buffalodata)[names(buffalodata)=="utm.northing"] <- "y"
names(buffalodata)[names(buffalodata)=="tag.local.identifier"] <- "id"
names(buffalodata)[names(buffalodata)=="individual.taxon.canonical.name"] <- "pop.type"

# Data Conversion
buffalodata$time <- as.POSIXct(strptime(buffalodata$time,format="%Y-%m-%d %H:%M",tz="GMT"))


mci.subsample.data <- subsample(dat=buffalodata, start=c("2005-02-17 00:00:00"),end="2006-12-31 00:00:00",interval=c("50 hours"),accuracy=c("3 hours"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="mci")

buffalo.indiv <- Individuals(mci.subsample.data, id="id", time="time", x="x", y="y", group.by="pop.type", proj4string= CRS("+proj=utm +zone=28 +datum=WGS84"))
                        
### Compute MCI 

mci.buffalo <- mci.index(buffalo.indiv, group.by = c("pop.type"), time.lag = c("time.lag"))

mci.buffalo

#plot(mci.buffalo)

cexValue = 2
boxplot(mci.index ~ factor(pop.type), data = mci.buffalo, 
        col= "green", 
        border = NULL,
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)


### Compute ANOVA

anova.model <- aov.mci(mci.buffalo)
anova.model

### Tukey Test

TukeyHSD(anova.model)
TukeyHSD(mci.buffalo)


### Kruskal Test

kruskal.test(mci.buffalo)
kruskalmc(mci.buffalo)

### Summary

summary.MCIndex(mci.buffalo)

summary(mci.buffalo)

cexValue = 2

# Extra Plotting

library(RColorBrewer)
g = 11
my.cols <- rev(brewer.pal(g, "RdYlBu"))

# smooth scatter 
require(KernSmooth)
smoothScatter(mci.subsample.data$location.long, mci.subsample.data$location.lat, nrpoints=.3*100000, colramp=colorRampPalette(my.cols), pch=19, cex=.3, col = "green1")


# kernel density using MASS 
library(MASS)
z <- kde2d(mci.subsample.data$location.long, mci.subsample.data$location.lat, n=50)
plot(mci.subsample.data$location.long, mci.subsample.data$location.lat, xlab="X", ylab="Y", pch=19, cex=.3, col = "gray60")
contour(z, drawlabels=FALSE, nlevels=g, col=my.cols, add=TRUE, lwd = 2)
abline(h=mean(mci.subsample.data$location.long), v=mean(mci.subsample.data$location.lat), lwd=2, col = "black")
legend("topleft", paste("r=", round(cor(mci.subsample.data$location.long, mci.subsample.data$location.lat),2)), bty="n")
