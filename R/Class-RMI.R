#' The RMIndex class
#'
#' The \code{RMIndex} object contains Realized Mobility Index data frame, which is computed for the populations of Inidividuals. 
#'
#' 
#' 
#'@section Slots: 
#'  \describe{
#'    \item{\code{data}:}{Object of class \code{"data.frame"}, columns: id - animalId, pop.type - population type, ind.home.range - individual home range, pop.home.range - population home range, rmi.index - RMI value}
#'  }
#'
#'  
#' @note Object is constructed as a result of rmi.index method call on the data frame of the Individuals
#' @name RMIndex 
#' @rdname RMIndex
#' @aliases RMIndex-class
#' @exportClass RMIndex
#' @author Irina Belyaeva
setClass("RMIndex",
             representation=representation(data="data.frame"),
             prototype = list( data = data.frame(id = character(0),
                                             pop.type = character(0),
                                             ind.home.range = character(0),
                                             pop.home.range = character(0),
                                             rmi.index = numeric(0)
                                             ))
         )

setValidity("RMIndex",
            function(object){
                return(TRUE)
            }
) 


