color.palette <- function(colourCount = 3, palette = c("Pastel2")){
    
    colourCount <- max(colourCount, 3)
    pallete     <- palette
    
    this.palette <- colorRampPalette(brewer.pal(colourCount, palette))
    
    return (this.palette(colourCount))
    
}

.color.vector <- function(f) {
    
    
}