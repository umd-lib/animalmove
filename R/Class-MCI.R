setClass("MCI",
    representation=representation(mci="numeric"),
    contains = "Individuals",
    )

setValidity("MCI",
            function(object){
                return(TRUE)
            }
) 

#setMethod("plot", "MCI",
#          function(this) {
#              plot(this)
#          }
#)

#setMethod("boxplot", "MCI",
 #         function(this) {
  #            boxplot(this)
   #       }
#)