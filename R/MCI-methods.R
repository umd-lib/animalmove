setGeneric("summary", function(this) {
    standardGeneric("summary")
})

setMethod("summary", "MCI",
          function(this) {
              this@group.names
          }
)

setGeneric("plot", function(this) {
    standardGeneric("plot")
})

setMethod("plot", "MCI",
          function(this) {
              plot(this)
          }
)

setGeneric("boxplot", function(this) {
    standardGeneric("boxplot")
})

setMethod("boxplot", "MCI",
          function(this) {
              boxplot(this)
          }
)