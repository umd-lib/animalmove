"Individuals" =  function(spdf, group.by = as.character(NA),... ) {
    
    if (is(spdf, "SpatialPointsDataFrame")){
        coords = spdf@coords
        coords.nrs = spdf@coords.nrs
        data = spdf@data
        bbox = spdf@bbox
        proj4string = spdf@proj4string
    }

    new ("Individuals", SpatialPointsDataFrame(coords = coords, data = data, coords.nrs = coords.nrs, 
                                                                       proj4string = proj4string, match.ID = TRUE,
                                                                                  bbox = bbox), group.by = group.by, ...)
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

as.data.frame.IndividualsDataFrame = function(x, ...)  {
     as.data.frame(x)
}

setAs("Individuals", "data.frame", function(from)
    as.data.frame.IndividualsDataFrame(from))
