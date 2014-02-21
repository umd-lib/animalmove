setClass("PDI",
         representation=representation(pdi="numeric"),
         contains = "Individuals",
)

setValidity("PDI",
            function(object){
                
                return(TRUE)
            }
) 


