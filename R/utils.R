#' @author Irina Belyaeva
color.palette <- function(colourCount = 3, palette = c("Pastel2")){
    
    colourCount <- colourCount
    colourCount <- max(colourCount, 3)
    pallete     <- palette
    
    this.palette <- colorRampPalette(brewer.pal(colourCount, palette))
    
    return (this.palette(colourCount))
    
}

#' @author Irina Belyaeva
isColumnExists <- function (column, data){
    
    result <- FALSE
    
    if (is.data.frame(data)){
        if (length(which(colnames(data)==column))> 0) {
            result <- TRUE
        }         
     }
    
    result 
}

#' @author Irina Belyaeva
checkColumns <- function (columns, data){
    resultlist <- unlist(lapply(columns, isColumnExists, data = data))
    return (all(resultlist))
}

