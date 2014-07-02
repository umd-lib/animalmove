"Individuals" =  function(data, id, time, x, y, group.by, proj4string=NULL... ) {
    
    result <- FALSE
    
    if (is.data.frame(data)){
        
        if (missing(id) || missing(x) || missing(y) || missing (time) || missing (group.by)){
            stop("Incorrect columns supplied. Required columns are: data, id (individual Id), x and coordinates")
        }
        
        if (!isColumnExists(as.character(id), data)){
            stop("Column id does not exist in the data frame.")
        }
        
        if (!isColumnExists(as.character(x), data)){
            stop("Column x does not exist in the data frame.")
        }
        
        if (!isColumnExists(as.character(y),data)){
            stop("Column x does not exist in the data frame.")
        }
        
        if (!isColumnExists(as.character(time),data)){
            stop("Column time does not exist in the data frame.")
        }
        
    } else{
        stop("incorrect data frame supplied. Parameter data should be a data frame with number of rows greater than zero.")
    }
    
    # Create spatial points
    
    data.xy <- data[, c(x=x,y=y)]
    attr.columns <- setdiff(colnames(data),colnames(data.xy))
    data.attr  <- data[,attr.columns]
    
    spatial.points <- SpatialPoints(data.xy)
    spatial.df <- SpatialPointsDataFrame(coords = spatial.points, data = data.attr, 
                                         proj4string = proj4string, match.ID = TRUE)
    
    new ("Individuals", spatial.df, group.by = group.by)
    
}

setGeneric("group.by", function(this) {
    standardGeneric("group.by")
})

setMethod("group.by", "Individuals",
          function(this) {
              this@group.by
          }
)

setGeneric("populations", function(this) {
    standardGeneric("populations")
})

setMethod("populations", "Individuals",
          function(this) {
              unique(this@data[this@group.by])
          }
)

setGeneric("rmi.index", function(this, percent = 95, unin=c("m", "km"),
                                 unout=c("ha", "km2", "m2"), id) {
    standardGeneric("rmi.index")
})

setMethod("rmi.index", "Individuals",
          function(this, percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), id) {
              
              unin <- match.arg(unin)
              unout <- match.arg(unout)
              
              index <- compute.rmi.index(this, percent,
                                         unin = unin,
                                         unout = unout, id=id)
              RMIndex(index)
          }
)

as.data.frame.IndividualsDataFrame = function(x, ...)  {
    if (length(x@coords.nrs) > 0) {
        maxi = max(x@coords.nrs, (ncol(x@data) + ncol(x@coords)))
        ret = list()
        for (i in 1:ncol(x@coords))
            ret[[x@coords.nrs[i]]] = x@coords[,i]
        names(ret)[x@coords.nrs] = dimnames(x@coords)[[2]]
        idx.new = (1:maxi)[-(x@coords.nrs)]
        for (i in 1:ncol(x@data))
            ret[[idx.new[i]]] = x@data[,i]
        names(ret)[idx.new] = names(x@data)
        ret = ret[unlist(lapply(ret, function(x) !is.null(x)))]
        data.frame(ret)
    } else
        data.frame(x@data, x@coords)
}

setAs("Individuals", "data.frame", function(from)
    as.data.frame.IndividualsDataFrame(from))

.print.Individuals <- function(x, ...){
    if (!inherits(x, "Individuals")) #1
        stop("Object must be of class 'Individuals'")
    
    print("coordinates names:")
    cat(coordnames(x), "\n")
    cat("...........", "\n")
    print("bbox:")
    bbox(x)
}

setGeneric("show.mcp", function(x, percent = 95, unin=c("m", "km"),
                                unout=c("ha", "km2", "m2"), id) {
    standardGeneric("show.mcp")
})

setMethod("show.mcp", "Individuals",
          function(x, percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), id) {
              
              unin <- match.arg(unin)
              unout <- match.arg(unout)
              
              .show.mcp(x, percent = percent,
                        unin=unin, unout=unout, id)
          }
)

.show.mcp <- function(x, percent = 95, unin=c("m", "km"),
                      unout=c("ha", "km2", "m2"), id){
    if (!inherits(x, "Individuals")) #1
        stop("Object must be of class 'Individuals'")
    
    individual.mcp <- mcp(x[,id], percent = percent,
                          unin=unin, unout=unout)
    
    print("Individual MCPs:")
    print(individual.mcp)
    
    print("Population MCPs:")
    population.mcp <- mcp.area.population(x, percent = percent,
                                          unin=unin,
                                          unout=unout)
    print(population.mcp)
    
}

setMethod("print", signature(x="Individuals"),
          function(x){
              .print.Individuals(x)
          }
)

setGeneric("subsample.reloc", function(data, startTime, endTime, interval=c("24 hours","48 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL, completeSetsOnly=TRUE, index.type) {
    standardGeneric("subsample.reloc")
})

setMethod("subsample.reloc", "Individuals",
          function(data, startTime, endTime, interval=c("24 hours","48 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL, completeSetsOnly=TRUE, index.type) {
              
              proj4string <- buffalo.indiv@proj4string
              subsapmpled.data <- subsample(dat=as.data.frame(data), start=startTime,end=endTime,interval=interval,accuracy=accuracy,minIndiv=minIndiv,maxIndiv=maxIndiv,mustIndiv=NULL,index.type=index.type)
              
              str(subsapmpled.data)
              result <- importMoveTracks(subsapmpled.data,,,,proj4string)
              return(result)
            
          }
)

setMethod("summary", "Individuals", function(object, ...) {
    getMethod("print","Spatial")(object) 
    time.range <- time.range(object)
    cat("Time range:",paste(time.range, collapse=" ... "),capture.output(round(difftime(time.range[2],time.range[1]))), " (start ... end, duration) \n")  
    cat("Average Duration between relocations:",  paste(durationSummary(object), "\n"), hours)
    cat("Specie Populations:", paste(collapse=", ", populations(object)),"\n")
})

