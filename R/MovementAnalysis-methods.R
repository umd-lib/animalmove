mcp.area.population <- function(xy, percent = seq(20,100, by=5),
                                unin=c("m", "km"),
                                unout=c("ha", "km2", "m2"), plotit = TRUE){
    
    ## Verifications
    if (!inherits(xy, "SpatialPoints"))
        stop("xy should be of class SpatialPoints")
    if (ncol(coordinates(xy))>2)
        stop("xy should be defined in two dimensions")
    pfs <- proj4string(xy)
    
    if (length(percent)>1)
        stop("only one value is required for percent")
    if (percent>100) {
        warning("The MCP is estimated using all relocations (percent>100)")
        percent<-100
    }
    unin <- match.arg(unin)
    unout <- match.arg(unout)
  
    if ((inherits(xy, "Individuals"))){
        if ((length(group.by(xy))!=1) | is.na(group.by(xy))) {
            warning("xy should contain only one column (the population group of the animals), population ignored")
            id <- factor(rep("a", nrow(as.data.frame(xy))))
        } else {
            columnName = colnames(populations(xy))
            index = grep(columnName, colnames(xy@data))
            id <- index
        }
    }else if (inherits(xy, "SpatialPointsDataFrame")){
        if (ncol(xy)!=1) {
            warning("xy should contain only one column (the id of the animals), id ignored")
            id <- factor(rep("a", nrow(as.data.frame(xy))))
        } else {
            id <- xy[[1]]
        }
    } else {
        id <- factor(rep("a", nrow(as.data.frame(xy))))
    }
   
    res <- mcp.area(xy[,id], percent = percent,
               unin=unin,
               unout=unout, plotit)
    
    return(res)
    
}


mcp.population <- function(xy, percent = 95,
                           unin=c("m", "km"),
                           unout=c("ha", "km2", "m2")){
    unin <- match.arg(unin)
    unout <- match.arg(unout)
    
    if ((inherits(xy, "Individuals"))){
        if ((length(group.by(xy))!=1) | is.na(group.by(xy))) {
            warning("xy should contain only one column (the population group of the animals), population ignored")
            id <- factor(rep("a", nrow(as.data.frame(xy))))
        } else {
            columnName = colnames(populations(xy))
            index = grep(columnName, colnames(xy@data))
            id <- index
        }
    }else if (inherits(xy, "SpatialPointsDataFrame")){
        if (ncol(xy)!=1) {
            warning("xy should contain only one column (the id of the animals), id ignored")
            id <- factor(rep("a", nrow(as.data.frame(xy))))
        } else {
            id <- xy[[1]]
        }
    } else {
        id <- factor(rep("a", nrow(as.data.frame(xy))))
    }
  
    res <- mcp(xy[,id], percent = percent,
                    unin=unin,
                    unout=unout)
    
    return(res)
    
}