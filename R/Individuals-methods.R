"Individuals" =  function(spdf, group.names = as.character(NA),... ) {
    
    if (is(spdf, "SpatialPointsDataFrame")){
        coords = spdf@coords
        coords.nrs = spdf@coords.nrs
        data = spdf@data
        bbox = spdf@bbox
        proj4string = spdf@proj4string
    }

    new ("Individuals", SpatialPointsDataFrame(coords = coords, data = data, coords.nrs = coords.nrs, 
                                                                       proj4string = proj4string, match.ID = TRUE,
                                                                                  bbox = bbox), group.names = group.names, ...)
}

setGeneric("group.names", function(this) {
    standardGeneric("group.names")
})

setMethod("group.names", "Individuals",
          function(this) {
              this@group.names
          }
)

setGeneric("populations", function(this) {
    standardGeneric("populations")
})

setMethod("populations", "Individuals",
          function(this) {
              unique(this@data[this@group.names])
          }
)

setGeneric("rmi.index", function(this, percent, unin=c("m", "km"),
                           unout=c("ha", "km2", "m2"), id) {
    standardGeneric("rmi.index")
})

setMethod("rmi.index", "Individuals",
          function(this, percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), id) {
              
              unin <- match.arg(unin)
              unout <- match.arg(unout)
              compute.RealizedMobilityIndex(this, percent,
                                             unin = unin,
                                             unout = unout, id)
          }
)