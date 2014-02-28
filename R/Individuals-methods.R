"Individuals" =  function(spdf, group.by,... ) {
    
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

setGeneric("rmi.index", function(this, percent = 95, unin=c("m", "km"),
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
