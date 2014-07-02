setGeneric("relocation.duration", function(x, units,...) {
    standardGeneric("relocation.duration")
})

setMethod("relocation.duration", "Individuals", function(x, units,...){
    if(missing(units)){
        warning('Units not specified this could lead to different units for the time differences between individuals')
        return(lapply(lapply(split(x$time, x$id), diff),as.numeric,...))
    }else{
        return(lapply(lapply(split(x$time, x$id), diff),as.numeric,units=units,...))
    }
})

setGeneric("durationSummary", function(x, units="hours"){standardGeneric("durationSummary")})

setMethod("durationSummary", 
          signature="Individuals", 
          definition=function(x, units){
              date <- x$time
              time.diff <- relocation.duration(x, units=units)
              print("Duration summary:")
              duration.matrix <- matrix(unlist(time.diff), ncol = 1, byrow = TRUE)
              cat(summary(duration.matrix), "\n")
              avg.dur <- ceil(mean(duration.matrix, na.rm = TRUE))
              sd.dur <- sd (duration.matrix, na.rm = TRUE)
              df <- data.frame(Avg.Duration=avg.dur, Std.Duration= sd.dur)
              return(df)
          })

setGeneric("time.range", function(x) standardGeneric("time.range"))
setMethod("time.range", "Individuals",
          function(x) {
              time.range <- range(x$time)
          })

