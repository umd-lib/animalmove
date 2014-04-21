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

mci.data <- subsample(khulan.test.data, start=c("2009-01-01 00:00"),end="2009-12-31 00:00",interval=c("50 hours"),accuracy=c("3 mins"),minIndiv=3,maxIndiv=6,mustIndiv=NULL,index.type="mci")

head(mci.data)

# Number of rows in subsampled data
nrow(mci.data)

#Prepare data for the analysis

# Create attribute data frame
dt.mci.data <- data.table(mci.data)

dt.mci.data.attr  <- dt.mci.data[,list(id=id, pop.type=pop.type, x=X,y=Y, time=time, time.lag=time.lag, age=age, elevation= elevation, behaviour = behaviour)]
str(dt.mci.data.attr)

# Create spatial coordinates
dt.mci.data.spatial <- dt.mci.data[, list(x=X,y=Y)]
str(dt.mci.data.spatial)

dt.mci.data.xy <- dt.mci.data.spatial[, list(x, y)]

str(dt.mci.data.xy)

#Create spatial points
xy.sp.mci.data <- SpatialPoints(dt.mci.data.xy)

# Create spatial points data frame with attributes
xy.mci.data.spdf <- SpatialPointsDataFrame(xy.sp.mci.data, dt.mci.data.attr)
str(xy.mci.data.spdf)

# Create Individuals data.frame - relocations of khulan data
khulan.reloc.spatial <- Individuals(xy.mci.data.spdf, group.by="pop.type")
str(khulan.reloc.spatial)

res.ind <- mci.index(khulan.reloc.spatial, group.by = c("pop.type"), time.lag = c("time.lag"))
mci.object1 <- MCIndex(res.ind)

aov(res.ind)
plot(mci.object1)

boxplot(mci.index~factor(pop.type), data =res.ind, 
        col = c(colorCaribou,colorGazelle,colorMoose), 
        border =c(colorCaribou2,colorGazelle2,colorMoose2),
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)


mci <-  mci.index(allpopulations.spatial, group.by = c("pop.type"), time.lag = c("time.lag"))
    
head(mci)

mci

# Create MCIndex object
mci.object <- MCIndex(mci)

mci.object

# Compute ANOVA stats

anova.model <- aov(mci)

# display anova
anova.model

# TukeyHSD from model
TukeyHSD(anova.model)

TukeyHSD(mci)

kruskal.test(mci)

kruskalmc(mci)

summary.MCIndex(mci.object)

plot(mci.object)

fg.pal <- color.palette(length(unique(df$pop.type)))
df$color <- fg.pal[index]

boxplot(mci.index ~ pop.type, data = mci, 
        col= col, 
        border = border,
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)

fg.pal <- color.palette(length(unique(mci$pop.type)))
bg.pal <- color.palette(length(unique(mci$pop.type)), palette = c("Dark2"))  

par(mar = c(5, 5, 2, 1))

mci$color <- fg.pal[index]
mci$bgcolor <- bg.pal[index]

colorCaribou = "pink" 
colorGazelle = "lightblue"
colorGuanaco = "khaki1"#"#FFFF99"
colorMoose = "lightgreen"
colorCaribou2 = "red" 
colorGazelle2 = "blue"
colorGuanaco2 =  "darkorange"
colorMoose2 = "darkgreen"

boxplot(mci.index~factor(pop.type), data =mci, 
        col = c(colorCaribou,colorGazelle,colorMoose), 
        border =c(colorCaribou2,colorGazelle2,colorMoose2),
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)

#Add baseline 
lines(c(.7,3.3), c(0,0), lwd = 2, lty = 1, col = 1) 


