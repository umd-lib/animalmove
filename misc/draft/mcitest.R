library(animalmove)
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

kruskalmc(mci.object)

summary.MCIndex(mci.object)


