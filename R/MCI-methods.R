#' Computing the standartizied distance from the mean
#' @param x - numeric vector
#' @export
#' @rdname MCI-methods
#' @return standartizied distance from the mean
abs.std.mean <- function(x){
    
    # x should be a numerical vector
    # add check for that
    
    len <- length(x)
    mean.abs <- mean(abs(x))
    abs.mean.diff.x <- sum(abs(x - mean(x)))
    sum.abs.vector.mean <- abs.mean.diff.x/len
    abs.std.mean <- sum.abs.vector.mean/mean.abs
    
    return (abs.std.mean)
    
}
#' Movement Coordination Index
#' @param object An Individuals object
#' @exportMethod
setGeneric("mci.index", function(object, group.by="missing", time.lag, ...) {
    standardGeneric("mci.index")
})

#' Movement Coordination Index
#' @param object An Individuals object
#' @rdname MCI-methods
setMethod("mci.index", signature(object = c("SpatialPointsDataFrame")),
          function(object, group.by, time.lag, ...) {
              
              mci.index <- .mci.spatial.index.SpatialPointsDataFrame (object, group.by, time.lag, ... )
              
              return(MCIndex(mci.index))
              
       }          
)

#' Movement Coordination Index
#' @param object An Individuals object
#' @rdname MCI-methods
setMethod("mci.index", signature(object = "Individuals"),
          function(object, time.lag, ...) {
              
              mci.index <- .mci.spatial.index.IndividualsDataFrame (object, time.lag, ... )
              
              return(MCIndex(mci.index))
        
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
    
    #index.group.by = grep(group.by, colnames(xy@data))
    #colnames(xy@data)[index.group.by] <- "pop.type"
        
    #index.time.lag = grep(time.lag, colnames(xy@data))
    #colnames(xy@data)[index.time.lag] <- "time.lag"
    
    #if (is.na(group.by) | length(group.by) == 0 | is.na(index.group.by)) {
     #   stop("Invalid column mapping for the population type. The data frame should have a column mapped to the population type.")
    #}
    
    #if (is.na(time.lag) | length(time.lag) == 0 | is.na(index.time.lag)) {
     #   stop("Invalid column mapping for the time lag. The data frame should have a column mapped to the time lag.")
    #}
    
    # save data frame
    df <- as.data.frame(xy)
    
    dt <- data.table(df)
    dt[, abs.distX:= abs.std.mean(x), by= list(id)]
    dt[, abs.distY:= abs.std.mean(y), by= list(id)]
    dt[, mci.index:= (1.0 - ((abs.distX + abs.distY)/2)), by= list(id)]
    dt[,  c("id" ,"pop.type", "mci.index")]
    
    df <- as.data.frame(dt)
    df <- df[,c("scantimes", "id", "pop.type", "mci.index")]
    
    return (df)
}

.mci.spatial.index.IndividualsDataFrame <- function(xy, time.lag){
    
    ## Verifications
    if (!inherits(xy, "SpatialPoints"))
        stop("xy should be of class SpatialPoints")
    
    if (!inherits(xy, "SpatialPointsDataFrame"))
        stop("xy should be of class SpatialPointsDataFrame")
    
    if (ncol(coordinates(xy))>2)
        stop("xy should be defined in two dimensions")
    
    #group.by = colnames(populations(xy))
    #index.group.by = grep(group.by, colnames(xy@data))
    #colnames(xy@data)[index.group.by] <- "pop.type"
    
    #index.time.lag = grep(time.lag, colnames(xy@data))
    #colnames(xy@data)[index.time.lag] <- "time.lag"
    
    #if (is.na(group.by) | length(group.by) == 0 | is.na(index.group.by)) {
     #   stop("Invalid column mapping for the population type. The data frame should have a column mapped to the population type.")
    #}
    
#    if (is.na(time.lag) | length(time.lag) == 0 | is.na(index.time.lag)) {
 #       stop("Invalid column mapping for the time lag. The data frame should have a column mapped to the time lag.")
  #  }
    
    
    # save data frame
    df <- as.data.frame(xy)
    
    dt <- data.table(df)
    dt[, abs.distX:= abs.std.mean(x), by= list(id)]
    dt[, abs.distY:= abs.std.mean(y), by= list(id)]
    dt[, mci.index:= (1.0 - ((abs.distX + abs.distY)/2)), by= list(id)]
    dt[,  c("id" ,"pop.type", "mci.index")]
    
    df <- as.data.frame(dt)
    df <- df[,c("scantimes", "id", "pop.type", "mci.index")]
    
    return (df)
}

#' ANOVA object computed for Movement Coordination Index object
#' @param object An MCIndex object
#' @rdname MCI-methods
#' @exportMethod
setMethod("aov", signature(formula = "MCIndex", data = "missing", projections = "missing", qr="missing", contrasts = "missing"),
          function(formula, data, projections, qr, contrasts, ...){
              
              aov.mci(formula, ...)
              
          }
)

#' Helper method to compute MCIndex
#' @param object An MCIndex object
#' @rdname MCI-methods
aov.mci <- function (formula, data = NULL, projections = FALSE, qr = TRUE,
    contrasts = NULL, print = FALSE){
    
    if (!.isMultiPopulation(formula)){
        stop("Cannot perform ANOVA test on a single population. Number of populations should be greater than 0.")
    }
    
    print <- print
    object <- formula
    data <- object@data
    species <- object@data$pop.type
    model <- aov(mci.index ~ species, data = data)
    
    if (print) {
        summary(model)
    }
    
    return (model)
    
}

#' TukeyHSD object computed for Movement Coordination Index object
#' @param object An MCIndex object
#' @rdname MCI-methods
#' @exportMethod
setMethod("TukeyHSD", signature(x = "MCIndex", which = "missing"),
          function(x, which, ...){
              
              if (!.isMultiPopulation(x)){
                  stop("Cannot perform TukeyHSD test on a single population. Number of populations should be greater than 0.")
              }
              
              model <- aov(x)
              result <- TukeyHSD(model)
              
              return (result)
              
          }
)

#' Kruskal Test object computed for Movement Coordination Index object
#' @param object An MCIndex object
#' @rdname MCI-methods
#' @exportMethod
setMethod("kruskal.test", signature(x = "MCIndex"),
          function(x, ...){
              
              if (!.isMultiPopulation(x)){
                  stop("Cannot perform Kruskal test on a single population. Number of populations should be greater than 0.")
              }
              
              object <- x
              species <- as.factor(object@data$pop.type)
              df <- object@data
              kruskal.model <- kruskal.test(df$mci.index ~ species)
              
              result <- kruskal.model
              
              return (result)
              
          }
)

#' KruskalMC  object computed for Movement Coordination Index object
#' @param object An MCIndex object
#' @rdname MCI-methods
#' @exportMethod
setMethod("kruskalmc", signature(resp = "MCIndex"),
          function(resp, ...){
              
              if (!.isMultiPopulation(resp)){
                  stop("Cannot perform Kruskal Multiple Comaprison on a single population. Number of populations should be greater than 0.")
              }
              
              object <- resp
              species <- as.factor(object@data$pop.type)
              df <- object@data
              kruskal.model <- kruskalmc(df$mci.index , species)
              
              result <- kruskal.model
              
              return (result)
              
          }
)


summary.MCIndex <- function(object, ...){
    
    if (!inherits(object, "MCIndex")){
        stop("Invalid object type. Expected MCIndex.")
    }
    
    if (!.isMultiPopulation(object)){
        stop("Cannot perform multiple comparison tests on a single population. Number of populations should be greater than 0.")
    }
    
    print(summary(aov(object)))
    
    print(TukeyHSD(object))
    
    print(kruskal.test(object))
    
    print(kruskalmc(object))
    
    class(object) = "summary.MCIndex"
    object
    
}

#'@exportMethod summary
setMethod("summary", "MCIndex", function(object, ...) {
    if (!inherits(object, "MCIndex")){
        stop("Invalid object type. Expected MCIndex.")
    }
    
    if (!.isMultiPopulation(object)){
        stop("Cannot perform multiple comparison tests on a single population. Number of populations should be greater than 0.")
    }
    
    print(summary(aov(object)))
    
    print(TukeyHSD(object))
    
    print(kruskal.test(object))
    
    print(kruskalmc(object))
      
}  )

.plot.MCIndex <- function(x, ..., range = 1.5, width = NULL, varwidth = FALSE,
                          notch = FALSE, outline = TRUE, names, plot = TRUE,
                          border = NULL, col = NULL, log = "",
                          pars = list(boxwex = 0.8, staplewex = 0.5, outwex = 0.5),
                          horizontal = FALSE, add = FALSE, at = NULL, cexValue = 2) {
    

    if (!inherits(x, "MCIndex")){
        stop("Object should be type of MCIndex")    
    }
    
    col <- col
    border <- border
    cexValue <- cexValue
        
    df <- as.data.frame(x@data)
    
    #pop.rank <- NULL
    #tmp.rank <- NULL
    
    dt <- as.data.table(df)
    dt[,tmp.rank:=max(mci.index),by=pop.type]
    dt[,pop.rank:=rank(tmp.rank)][order(pop.rank)]
    
    df <- as.data.frame(dt)
    df <- within(df,pop.type <- factor(pop.type))
    df$pop.type <- reorder(df$pop.type, -df$pop.rank)
    
    par(mar = c(5, 5, 2, 1))
    
    index <- as.integer(factor(as.integer(factor(df$pop.type))))
    
    if (is.null(col)){
        fg.pal <- color.palette(length(unique(df$pop.type)))
        df$color <- fg.pal[index]
        col <- df$color
     }

    if (is.null(border)){
        bg.pal <- color.palette(length(unique(df$pop.type)), palette = c("Dark2"))  
        df$bgcolor <- bg.pal[index]
        border <- df$bgcolor
    }
    
    boxplot(mci.index ~ factor(pop.type), data = df, 
            col= col, 
            border = border,
            outline = F, lwd=2, boxwex = .5, cex = cexValue, cex.lab = cexValue,
            cex.axis= cexValue,   frame = F, ylab = "Movement coordination index", xlab = NULL)
    
    #Add baseline 
    lines(c(.7,3.3), c(0,0), lwd = 2, lty = 1, col = 1) 
    
}


#' Plots Movement Coordination Index Object
#' @exportMethod
setMethod("plot", signature(x="MCIndex", y="missing"),
         function(x,y, ...){
               .plot.MCIndex(x, ...)
          }
)

#' Transforms to a data frame from the MCIndex object
#' @export
as.data.frame.MCIndex = function(x, ...)  {
    data.frame(x@data)
}

#' @exportMethod
setAs("MCIndex", "data.frame", function(from)
    as.data.frame.MCIndex(from))


.isMultiPopulation <- function(object){
    
    if (!length(unique(object@data$pop.type)) == 1){
       return (TRUE)
    }else{
        return (FALSE)
    }
}