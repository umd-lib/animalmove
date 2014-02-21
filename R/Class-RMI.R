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

