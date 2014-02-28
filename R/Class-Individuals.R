setClass("Individuals",
    representation=representation(group.by="character"),
    contains = "SpatialPointsDataFrame",
    prototype = list(group.by = as.character(NA))
    )

setValidity("Individuals",
            function(object){
                
               if ((length(object@group.by) >1) | (is.na(object@group.by))) {
                   stop("number of designated columns for population groups should be exactly 1")
               }else if(!is.element(object@group.by, names(object))){
                    stop("group.by must refer to a column name found in the population data")
               }   
                else
                    TRUE
            }
) 
