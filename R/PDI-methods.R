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

#' Extracts XY coordinates from the Individuals object
#' @param x - Individual object
#' @export
#' @rdname PDI-methods
as.matrix.extractPointsXY <- function(x, ...){
 
    this.df <- x
    spatial.points <- SpatialPoints(this.df)
    matrix.points <- as.matrix(spatial.points@coords)
    
    return(matrix.points)
    
}

#' Extracts XY coordinates from the Spatial Polygon of the Individual object
#' @param x - Spatial Polygon
#' @export
#' @rdname PDI-methods
as.matrix.extractPolygonPointsXY <- function(x, ...){
    
    this.polygon <- x
    polygon.xy <- this.polygon@polygons[[1]]@Polygons[[1]]@coords
              
    return (polygon.xy)
    
}

#' Computes biviariate function for a single animal constructed as the Individual object
#' @param df1 - data frame of coordinates of this animal id
#' @param df2 - data frame of coordinates of other animals from the same population
#' @export
#' @rdname PDI-methods
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

#' Computes PDIndex for a single animal constructed as the Individual object
#' @param id - animal id
#' @param df - data frame of the Individuals of the same population
#' @export
#' @rdname PDI-methods
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

#' Computes Population Dispersion Index for the population
#' @param object An Individual object that contains species from the same population

#' @exportMethod
setGeneric("pdi.index", function(object, scale, percent = 95, unin=c("m", "km"),
                                 unout=c("ha", "km2", "m2"), ...) {
    standardGeneric("pdi.index")
})

#' Computes Population Dispersion Index for the population
#' @param object An Individual object that contains species from the same population
#' @rdname PCI-methods
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

#' Prints Summary for the Population Dispersion Index
#' @param object - PDIndex
summary.PDIndex <- function(object, ...){
  if (!inherits(object, "PDIndex")){
    stop("Invalid object type. Expected PDIndex.")
  }
  summary.pdi(object)
}

#' Prints Summary for the Population Dispersion Index
#' @param object Population Dispersion Index 
#'@exportMethod summary PDIndex
setGeneric("summary.pdi", function(object, ...) {
    standardGeneric("summary.pdi")
})


setMethod("summary.pdi", signature(object = "PDIndex"),
          function(object, ...) {
              
              rowid <- NULL
              .SD   <- NULL
              pop.type <- NULL
              
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

#' Transforms to a data frame from the PDIndex object
#' @export
as.data.frame.PDIndex = function(x, ...)  {
    data.frame(x@data)
}

#' @exportMethod
setAs("PDIndex", "data.frame", function(from)
    as.data.frame.PDIndex(from))


setMethod("plot", signature(x="PDIndex", y="missing"),
          function(x,y, ...){
        
              summary.object <- summary.pdi(x)
              .plot.PDIndex(summary.object, ...)
          }
)


.plot.PDIndex <- function(object, xlim = NULL, ylim = NULL, ylab = "Population Dispersion Index", xlab = "lag (km)",  border= NA, col=NULL , linecol = NULL, cex.lab = 2, cex.axis = 2, cex = 2, axes = F, title = NULL, baseline = 100000, lwd = 2, lty = 1, addAxes = T, at.x = NULL, at.y = NULL, xlabels = NULL, ylabels = NULL ){
    
    x.coord <- c(object$scale, rev(object$scale))
    y.coord <- c(object$mean.pdi + object$se.pdi, rev(object$mean.pdi - object$se.pdi))
    
    scale <- object$scale
    
    min.y <- min(y.coord)
    max.y <- max(y.coord)
    
    min.x <- min(x.coord)
    max.x <- max(x.coord)
    
    # Calculate range of y axes from min y coordinate to max value of y axis
    ylim <- range(min.y, max.y)
                  
    # Calculate range of x axes from min x coordinate to max value of x axis
    xlim <- range(min.x, max.x)
    
    # draw empty plot with empty axes
    plot(scale, object$mean.pdi, ylim = ylim, xlim = xlim, col = NA,  
         ylab = ylab, xlab = xlab,
         cex.lab = cex.lab, cex.axis = cex.lab,cex = cex, axes = axes)
    
    color <- col
    lineCol <- linecol
    
    title <- title(main = title)
    
    # Plot Confidence Interval as polygon
    polygon(x.coord, y.coord, col = color, border = border)
    
    # Plot PDIndex as lines
    lines(object$scale,object$mean.pdi,col = linecol, lwd = lwd) 
    
    lines(c(0,baseline),c(0,0),lwd = lwd, lty = lty) # add baseline
    
    #Add axes
    if (addAxes){
        
        if (is.null(at.y)){
            by = 10000
            
            if (abs(min.y)< 1000 | abs(max.y)< 1000) {
                by = 1000
            }
            
            at.y = seq(round(min.y, -3), round(max.y + 1000, -3), by)
        }
        
        if (is.null(at.x)){
            
            at.x = seq(0,trunc(max.x),10000)
            xlabels = seq(0,(trunc(max.x)/1000),10)
        }
        
        axis(1, at= at.x, labels = xlabels, cex.axis = cex.axis)
        axis(2, at = at.y, labels = ylabels, cex.axis= cex.axis)
    }
    
}

#' Plots Population Dispersion Index Object
#' @exportMethod
setMethod("polygon", signature(x="PDIndex", y="missing"),
          function(x,y, ...){
              
              summary.object <- summary.pdi(x)
              .polygon.PDIndex(summary.object, ...)
          }
)

.polygon.PDIndex <- function(object, y = NULL, density = NULL, angle = 45,
                 border = NULL, col = NULL, lty = par("lty"),
                 ..., fillOddEven = FALSE,  color = NA, linecol = NULL, cex.lab = 2, cex.axis = 2, cex = 2, axes = F, title = NULL){
    
    x.coord <- c(object$scale, rev(object$scale))
    y.coord <- c(object$mean.pdi + object$se.pdi, rev(object$mean.pdi - object$se.pdi))
       
    linecol <- linecol
    
        
    if (is.null(linecol)){
        
        bg.pal <- color.palette(1, palette = c("Dark2"))  
        linecol <- bg.pal[1]

    }
    
    scale <- object$scale
    
    min.y <- min(y.coord)
    max.y <- max(y.coord)
    
    min.x <- min(x.coord)
    max.x <- max(x.coord)
    
    title <- title(main = NA)
    
    x.coord <- c(object$scale, rev(object$scale))
    y.coord <- c(object$mean.pdi + object$se.pdi, rev(object$mean.pdi - object$se.pdi))
    
    scale <- object$scale
    
    min.y <- min(y.coord)
    max.y <- max(y.coord)
    
    min.x <- min(x.coord)
    max.x <- max(x.coord)
    
    plot(scale, object$mean.pdi, ylim = c(min.y,max.y), xlim = c(min.x,max.x), col = NA,  
         ylab = ylab, xlab = xlab,
         cex.lab = cex.lab, cex.axis = cex.lab,cex = cex, axes = axes)
        
    polygon(x.coord, y.coord, col = color, border = NA) # plots CI's
    lines(object$scale,object$mean.pdi,col = linecol, lwd = 2) # plots PDI
    
}


