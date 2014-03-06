#' The Individuals class
#'
#' The \code{Individuals} object contains at least animal id, population type and xy coordinates of an animal. In order to analyze the temporal #' # #population patterns it should also have time lag attribute. It can contain further attribute data such as sex or age. These data are stored in the attribute #'data data.frame. 
#'
#' This line and the next ones go into the details.
#' This line thus appears in the details as well.
#'
#'@section Slots: 
#'  \describe{
#'    \item{\code{group.by}:}{Object of class \code{"character"}, column name in the attribute data.frame that contains population type of the animal belongs to;}
#'    \item{\code{data}:}{Object of class \code{"data.frame"}, additional data of that object that is stored in the SpatialPointsDataFrame}
#'  }
#'
#'  
#' @note Initial implementation of the package does not include export of this object to other packages to program against
#' @name Individuals 
#' @rdname Individuals
#' @aliases Individuals-class
#' @exportClass Individuals
#' @author Irina Belyaeva
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
