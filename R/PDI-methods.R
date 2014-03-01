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

compute.k12hat1 <- function(df1, df2, polygon){
    
    this.df1 <- df1
    this.df2 <- df2
    this.polygon <- polygon
    this.polyscale <- caribou.scale
    
    xycoord1 <- as.matrix.extractPointsXY(this.df1)
    xycoord2 <- as.matrix.extractPointsXY(this.df2)
    
    polygonXY <- as.matrix.extractPolygonPointsXY(this.polygon)
        
    result <- k12hat(xycoord1, xycoord2, polygonXY, this.polyscale)
    
    return (result)
    
}

compute.Individual.PDI <- function(id, df, polygon, polyscale){
    
    df.data <- getData(id, df)
    head(df.data)
    nrow(df.data)
    
    df.complementdata <- getComplementData(id, df)
    head(df.complementdata)
    
    this.polygon <- polygon
    this.polyscale <- polyscale
    
    res.k12hat <- compute.k12hat(df.data, df.complementdata, this.polygon, this.polyscale)
    
    result <- this.polyscale - sqrt(res.k12hat/pi)
    
    return (result)
    
}

