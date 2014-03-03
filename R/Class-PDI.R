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


