setClass("Individuals",
    representation=representation(group.names="character"),
    contains = "SpatialPointsDataFrame",
    prototype = list(group.names = as.character(NA))
    )

setValidity("Individuals",
            function(object){
                
               if ((length(object@group.names) >1) | (is.na(object@group.names))) {
                   stop("number of designated columns for population groups should be exactly 1")
               }
                else
                    TRUE
            }
) 
