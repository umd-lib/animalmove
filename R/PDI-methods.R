"PDIndex" =  function(pop.type, scale, data) {
    
    if (!is.data.frame(data)){
        
        stop("The third argument should be a data frame.")
        
    }
    else{
        
    pop.type=pop.type 
    scale=scale
    data=data
}
    
    new ("PDIndex",  pop.type=pop.type, scale=scale, data = data)
}


getData <- function(id, df){
    
    this.id <- id
    this.df <- df
    result <- subset(this.df, df@data$id == this.id)
    
    return (result)
    
}

getComplementData <- function(id, df){
    
    this.id <- id
    this.df <- df
    
    result <- subset(this.df, df@data$id != this.id)
    
    return (result)
    
}

as.matrix.extractPointsXY <- function(df){
 
    this.df <- df
    spatial.points <- SpatialPoints(this.df)
    matrix.points <- as.matrix(spatial.points@coords)
    
    return(matrix.points)
    
}

as.matrix.extractPolygonPointsXY <- function(polygon){
    
    this.polygon <- polygon
    polygon.xy <- this.polygon@polygons[[1]]@Polygons[[1]]@coords
              
    return (polygon.xy)
    
}

 compute.k12hat <- function(df1, df2, polygon, polyscale){
    
    this.df1 <- df1
    this.df2 <- df2
    this.polygon <- polygon
    this.polyscale <- polyscale
   
    xycoord1 <- as.matrix.extractPointsXY(this.df1)
    xycoord2 <- as.matrix.extractPointsXY(this.df2)
    
    polygonXY <- as.matrix.extractPolygonPointsXY(this.polygon)
        
    result <- k12hat(xycoord1, xycoord2, polygonXY, this.polyscale)
    
    return (result)
    
}

compute.Individual.PDI <- function(id, df, polygon, polyscale){
    
    df.data <- getData(id, df)
    df.complementdata <- getComplementData(id, df)
        
    this.polygon <- polygon
    this.polyscale <- polyscale
    
    res.k12hat <- compute.k12hat(df.data, df.complementdata, this.polygon, this.polyscale)
    
    result <- this.polyscale - sqrt(res.k12hat/pi)
    
    return (result)
    
}

.computePopulationIndex <-function(df, scale, percent = 95,
                                  unin , unout) {
    
    this.scale <- scale
    this.df <- df
    tmpdf <-data.frame(data.frame(row.names=1:length(this.scale)))
    
    
    this.poly <- mcp.population(this.df, percent = percent,
                                unin = unin, unout = unout)
    
    
    for (id in unique(as.character(df@data$id))) {
        
        tmp = as.numeric(compute.Individual.PDI(id, this.df, this.poly, scale))
        tmpdf <- cbind(tmpdf, id = tmp)
        
    }
    
    colnames(tmpdf) <- c(unique(as.character(df@data$id)))
                        
    return (tmpdf)
}

setGeneric("pdi.index", function(object, scale, percent = 95, unin=c("m", "km"),
                                 unout=c("ha", "km2", "m2"), ...) {
    standardGeneric("pdi.index")
})

setMethod("pdi.index", signature(object = "Individuals"),
          function(object, scale, percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), ...) {
              
              # TODO - Add code for validity of the computations: pop.type & scale
              
              pdi.index <- .computePopulationIndex (object , scale , percent,
                                                   unin , unout , ... )
              
              pop.type <- as.character(populations(object))
              pdi.index$pop.type <- pop.type
              this.scale <- scale
                          
              # Create PDIndex object
              pdi.index<- PDIndex(pop.type, this.scale, pdi.index)
              
              return (pdi.index)
          }          
)


setGeneric("summary.pdi", function(object) {
    standardGeneric("summary.pdi")
})

setMethod("summary.pdi", signature(object = "PDIndex"),
          function(object) {
              
              dt <- data.table(object@data)
              dt[, rowid := 1:nrow(dt)]
              
              dt.tmp <- dt
              setkey(dt.tmp, rowid)
              dt.tmp
              
              dt.tmp$pop.type = NULL
              
              dt.tmp <-dt.tmp[, list( max.pdi=apply(.SD,1, max), min.pdi=apply(.SD,1, min), mean.pdi=apply(.SD, 1, mean), se.pdi=apply(.SD, 1, se)), by = rowid]
              
              dt <- dt[, list(rowid,pop.type)]
              setkey(dt, rowid)
              
              df <- as.data.frame(dt[dt.tmp])
              
              df$scale <- object@scale
              
              return (df)
          }          
)

as.data.frame.PDIndex = function(x, ...)  {
    data.frame(x@data)
}

setAs("PDIndex", "data.frame", function(from)
    as.data.frame.PDIndex(from))




