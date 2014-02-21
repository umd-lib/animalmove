setClass("RMI",
         representation=representation(data="data.frame"),
         prototype = list( data = data.frame()),
         contains = "Individuals")


setValidity("RMI",
            function(object){
                return(TRUE)
            }
) 

