setClass("MCIndex",
         representation=representation(data="data.frame"),
         prototype = list( data = data.frame(time.lag = character(0),
                                             pop.type = character(0),
                                             rmi.index = numeric(0)
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


#as.data.frame.MCIndex = function(x, ...)  {
 #   data.frame(x@data)
#}

#setAs("MCIndex", "data.frame", function(from)
 #   as.data.frame.MCIndex(from))




