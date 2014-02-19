setClass("MCI",
    representation=representation(mci="numeric"),
    contains = "Individuals",
    )

setValidity("MCI",
            function(object){

                return(TRUE)
            }
) 
