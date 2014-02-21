setGeneric("summary", function(this) {
    standardGeneric("summary")
})

setMethod("summary", "PDI",
          function(this) {
              summary()
          }
)


setGeneric("plot", function(this) {
    standardGeneric("plot")
})

setMethod("polygon", "PDI",
          function(this) {
              polygon(this)
          }
)

setMethod("polygon", "PDI",
          function(this) {
              polygon(this)
          }
)