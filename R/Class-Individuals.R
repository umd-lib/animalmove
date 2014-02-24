setClass("Individuals",
    representation=representation(group.by="character"),
    contains = "SpatialPointsDataFrame",
    prototype = list(group.by = as.character(NA))
    )

setValidity("Individuals",
            function(object){
                
               if ((length(object@group.by) >1) | (is.na(object@group.by))) {
                   stop("number of designated columns for population groups should be exactly 1")
               }
                else
                    TRUE
            }
) 
