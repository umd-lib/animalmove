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