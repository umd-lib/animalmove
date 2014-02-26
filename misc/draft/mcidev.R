abs.std.mean <- function(x, ... ){
    
    # x should be a numerical vector
    # add check for that
    
    len <- length(x)
    x <- data.table(x)
    abs.dist.mean <- x[,list (vector.mean=sum(abs(x - mean(x))), mean = mean(x))]
    sum.abs.vector.mean <- abs.dist.mean[,1, with = FALSE]
    abs.mean <- abs.dist.mean[,2, with = FALSE]
    sum.abs.vector.mean <- sum.abs.vector.mean[1]/len
    abs.std.mean <- sum.abs.vector.mean/abs.mean
      
    return (abs.std.mean)
    
}

#gg <- data.table(xx$x)[,vector.mean:=sum(abs(x - mean(x)))]

gg <- abs.std.mean(x)
gg

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
mci.index(pop.data, group.by = c("type"), time.lag = c("time.lag"))

.mci.spatial.index.InduvidualsDataFrame(pop.data, group.by = c("type"), time.lag = c("time.lag"))
