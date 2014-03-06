#' The MCIndex class
#'
#' The \code{MCIndex} object contains Movement Coordination Index data frame, which is computed for the populations of Inidividuals. 
#'
#' 
#' 
#'@section Slots: 
#'  \describe{
#'    \item{\code{data}:}{Object of class \code{"data.frame"}, columns: id - time lag, pop.type - population type, mci.index - MCI value}
#'  }
#'
#'  
#' @note Object is constructed as a result of mci.index method call on the data frame of the Individuals
#' @name MCIndex 
#' @rdname MCIndex
#' @aliases MCIndex-class
#' @exportClass MCIndex
#' @author Irina Belyaeva
setClass("MCIndex",
         representation=representation(data="data.frame"),
         prototype = list( data = data.frame(time.lag = character(0),
                                             pop.type = character(0),
                                             mci.index = numeric(0)
         ))
)

setValidity("MCIndex",
            function(object){
                return(TRUE)
            }
) 


"MCIndex" =  function(data) {
    
    if (is.data.frame(data)){
        
        this.data <- data
        has.time.lag = grepl("time.lag", colnames(data))
        has.pop.type = grepl("pop.type", colnames(data))
        has.mci.index = grepl("mci.index", colnames(data))
        
    }
    
    new ("MCIndex",  data = this.data)
}




