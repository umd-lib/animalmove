setClass("PDIndex",
         representation=representation(pop.type="character", 
                                       mean.pdi="numeric",
                                       max.pdi="numeric", 
                                       min.pdi = "numeric", 
                                       se.pdi = "numeric",
                                       data = "data.frame"
                                       )
    )

setValidity("PDIndex",
            function(object){
                
                return(TRUE)
            }
) 


