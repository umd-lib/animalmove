library(animalmove)
data(puechabonsp)

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
res<- mci.index(df, group.by = c("Name"), time.lag = c("time.lag"))

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

pop.data

group.by = colnames(populations(pop.data))
index.group.by = grep(group.by, colnames(pop.data@data))

# test - call using generic method
res.ind <- mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

# display data
head(res.ind)

# test - call using internal function
#res.ind <- .mci.spatial.index.InduvidualsDataFrame(pop.data,  time.lag = c("time.lag"))
# display data
#head(res.ind)

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

kruskalmc(mci.object)

summary.MCIndex(mci.object)

# test plot MCI

df <- as.data.frame(mci.object@data)

dt <- as.data.table(df)
dt[,tmp.rank:=max(mci.index),by=pop.type]
dt[,pop.rank:=rank(tmp.rank)][order(pop.rank)]

df <- as.data.frame(dt)
df <- within(df,pop.type <- factor(pop.type, levels=names(sort(table(pop.type), decreasing = TRUE))))
df$pop.type <- reorder(df$pop.type, -df$pop.rank)

par(mar = c(5, 5, 2, 1))
cexValue = 2

index <- as.integer(factor(as.integer(factor(df$pop.type))))

fg.pal <- color.palette(length(unique(df$pop.type)))
bg.pal <- color.palette(length(unique(df$pop.type)), palette = c("Dark2"))  

df$color <- fg.pal[index]
df$bgcolor <- bg.pal[index]

boxplot(mci.index~factor(pop.type), data = df, 
        col= df$color, 
        border = df$bgcolor,
        outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
        cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)

