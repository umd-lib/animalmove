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

setGeneric("mci.index", function(object, group.by="missing", time.lag, ...) {
    standardGeneric("mci.index")
})

setMethod("mci.index", signature(object = c("SpatialPointsDataFrame")),
          function(object, group.by, time.lag, ...) {
              
              .mci.spatial.index.SpatialPointsDataFrame (object, group.by, time.lag, ... )
      }          
)

setMethod("mci.index", signature(object = "Individuals"),
          function(object, time.lag, ...) {
              
              .mci.spatial.index.InduvidualsDataFrame (object, time.lag, ... )
          }          
)

.mci.spatial.index.SpatialPointsDataFrame <- function(xy, group.by, time.lag){
    
    ## Verifications
    if (!inherits(xy, "SpatialPoints"))
        stop("xy should be of class SpatialPoints")
    
    if (!inherits(xy, "SpatialPointsDataFrame"))
        stop("xy should be of class SpatialPointsDataFrame")
    
    if (ncol(coordinates(xy))>2)
        stop("xy should be defined in two dimensions")
    
    group.by <- group.by
    time.lag <- time.lag
    
    index.group.by = grep(group.by, colnames(xy@data))
    colnames(xy@data)[index.group.by] <- "pop.type"
    
    
    index.time.lag = grep(time.lag, colnames(xy@data))
    colnames(xy@data)[index.time.lag] <- "time.lag"
    
    if (is.na(group.by) | length(group.by) == 0 | is.na(index.group.by)) {
        stop("Invalid column mapping for the population type. The data frame should have a column mapped to the population type.")
    }
    
    if (is.na(time.lag) | length(time.lag) == 0 | is.na(index.time.lag)) {
        stop("Invalid column mapping for the time lag. The data frame should have a column mapped to the time lag.")
    }
    
    # save data frame
    df <- as.data.frame(xy)
            
    dt <- data.table(df)
    dt[, abs.distX:= abs.std.mean(X), by= list(pop.type,time.lag)]
    dt[, abs.distY:= abs.std.mean(Y), by= list(pop.type,time.lag)]
    dt[, mci.index:= (1.0 - ((abs.distX + abs.distY)/2)), by= list(pop.type,time.lag)]
    dt[,  c("time.lag", "pop.type", "mci.index")]
   
    df <- as.data.frame(dt)
    df <- df[,c("time.lag", "pop.type", "mci.index")]
    
    return (df)
}

.mci.spatial.index.InduvidualsDataFrame <- function(xy, time.lag){
    
    ## Verifications
    if (!inherits(xy, "SpatialPoints"))
        stop("xy should be of class SpatialPoints")
    
    if (!inherits(xy, "SpatialPointsDataFrame"))
        stop("xy should be of class SpatialPointsDataFrame")
    
    if (ncol(coordinates(xy))>2)
        stop("xy should be defined in two dimensions")
    
    group.by = colnames(populations(pop.data))
    index.group.by = grep(group.by, colnames(xy@data))
    colnames(xy@data)[index.group.by] <- "pop.type"
    
    index.time.lag = grep(time.lag, colnames(xy@data))
    colnames(xy@data)[index.time.lag] <- "time.lag"
    
    if (is.na(group.by) | length(group.by) == 0 | is.na(index.group.by)) {
        stop("Invalid column mapping for the population type. The data frame should have a column mapped to the population type.")
    }
    
    if (is.na(time.lag) | length(time.lag) == 0 | is.na(index.time.lag)) {
        stop("Invalid column mapping for the time lag. The data frame should have a column mapped to the time lag.")
    }
    
    
    # save data frame
    df <- as.data.frame(xy)
    
    dt <- data.table(df)
    dt[, abs.distX:= abs.std.mean(X), by= list(pop.type,time.lag)]
    dt[, abs.distY:= abs.std.mean(Y), by= list(pop.type,time.lag)]
    dt[, mci.index:= (1.0 - ((abs.distX + abs.distY)/2)), by= list(pop.type,time.lag)]
    dt[,  c("time.lag", "pop.type", "mci.index")]
    
    df <- as.data.frame(dt)
    df <- df[,c("time.lag", "pop.type", "mci.index")]
    
    return (df)
}