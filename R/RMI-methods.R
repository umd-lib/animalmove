"RMIndex" =  function(df) {
    
    if (is.data.frame(df)){
        
        # include validation of presence of columns
        
    }
    
    new ("RMIndex",  data = df)
}

compute.RealizedMobilityIndex <- function(xy, percent = 95,
                                          unin=c("m", "km"),
                                          unout=c("ha", "km2", "m2"), id) {
   
    unin <- match.arg(unin)
    unout <- match.arg(unout)
    id <- id
    
    idcolumnName = id
    index_id = grep(idcolumnName, colnames(xy@data))
    
    if (is.na(index_id)){
        stop("Column Animal Id is missing.")
    }
    
    population.mcp <- mcp.population(xy, percent,
                               unin = unin,
                               unout = unout)
    
   
   individual.mcp <- mcp(xy[,index_id ], percent,
                          unin = unin,
                          unout = unout)
    
    tmp1 <- as.data.frame(individual.mcp)
    tmp2 <- xy@data
    tmp3 <- as.data.frame(population.mcp@data)
   
   columnName = colnames(populations(xy))
   index = grep(columnName, colnames(tmp2))
   colnames(tmp2)[colnames(tmp2)==columnName] <- "type"
   
    colnames(tmp2)[index_id] <- "id"
      
    tmp4 <- sqldf("select tmp1.id, tmp2.type, tmp1.area from tmp1 join tmp2 on tmp1.id=tmp2.id group by tmp1.id")
       
    tmp5 <- sqldf("select tmp4.id, tmp4.type, tmp4.area as indhomerange, tmp3.area pophomerange, case when tmp3.area > 0 then tmp4.area/tmp3.area else 0 end as rmiindex from tmp4 left outer join tmp3 on tmp4.type=tmp3.id")
  
    colnames(tmp5) <- c("id", "pop.type", "ind.home.range", "pop.home.range", "rmi.index")
   
    result <- tmp5
   
    options( warn = 0 )
    return(result)
    
   
}


setGeneric("summary.rmi", function(object, ...) {
    standardGeneric("summary.rmi")
})

setMethod("summary.rmi", "RMIndex",
          function(object, ...) {
              df = as.data.frame(object@data)
              tapply(df$rmi.index, df$pop.type, summary)
          }          
)


setMethod("summary.rmi", "data.frame",
          function(object, ...) {
              df = as.data.frame(object)
              tapply(df$rmi.index, df$pop.type, summary)
          }          
)

plot.RMIndex <- function(x,y, ...){
    
     
    if (!inherits(x, "RMIndex")){
        stop("Object should be type of RMIndex")    
    }
    
    df <- as.data.frame(x@data)
    
    dt <- as.data.table(df)
    dt[,tmp.rank:=max(rmi.index),by=pop.type]
    dt[,pop.rank:=rank(-tmp.rank)]
    
    df <- as.data.frame(dt)
    df <- within(df,pop.type <- factor(pop.type, levels=names(sort(table(pop.type), decreasing = TRUE))))
    df$pop.type <- reorder(df$pop.type, df$pop.rank)
    
    # strip chart again
    stripchart(rmi.index ~ factor(pop.type)
               , data = df, col = NA,xlim = c(.8,5), 
               cex = cexValue+2,cex.lab = cexValue,cex.axis= cexValue, frame = F,
               vertical = T,ylab = "Realized mobility index", xlab = "Species",
               ylim = c(0,0.8))
    
    this.x <- jitter(as.integer(factor(as.integer(factor(df$pop.type)))),.3)
    this.y <- df$rmi.index
    
    index <- as.integer(factor(as.integer(factor(df$pop.type))))
                        
    fg.pal <- color.palette(length(unique(df$pop.type)))
    bg.pal <- color.palette(length(unique(df$pop.type)), palette = c("Dark2"))  
    
    df$color <- fg.pal[index]
    df$bgcolor <- bg.pal[index]

    cexValue = 2
    
    points(this.x, this.y ,col= df$color, bg =  df$bgcolor,
           pch = 25,cex = cexValue+2,lwd = 2)
    
    
}

setMethod("plot", signature(x="RMIndex", y="missing"),
          function(x,y, ...){
              
              plot.RMIndex(x, ...)
          }
          )
