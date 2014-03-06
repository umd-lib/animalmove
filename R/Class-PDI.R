#' The PDIndex class
#'
#' The \code{PDIndex} object contains Population Dispersion Index data frame, which is computed for the populations of Inidividuals. 
#'
#' 
#' 
#'@section Slots: 
#'  \describe{
#'  \item{\code{pop.type}:}{Object of class \code{"character"}, pop.type - population type}
#'   \item{\code{scale}:}{Object of class \code{"numeric"}, scale - scale is used to compute the PDI data matrix}
#'    \item{\code{data}:}{Object of class \code{"data.frame"}, PDI data frame, columns - animals id, rows - scale, intersection of row and column - is the value of the index for the animal and a given scale}
#'  }
#'
#'  
#' @note Object is constructed as a result of pdi.index method call on the data frame of the Individuals
#' @name PDIndex 
#' @rdname PDIndex
#' @aliases PDIndex-class
#' @exportClass PDIndex
#' @author Irina Belyaeva
setClass("PDIndex",
         representation=representation(
                                       pop.type = "character",
                                       scale = "numeric",
                                       data = "data.frame"
                                       )
    )

setValidity("PDIndex",
            function(object){
                
                # validity should include the population parameter not null, length >=1, character vector
                # it can have only single population
                # therefore check the pop.type data$pop.type length argument
                # scale should be  a numeric vector of length >=1
                
                return(TRUE)
            }
) 


