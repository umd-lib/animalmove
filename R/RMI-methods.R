compute.RealizedMobilityIndex <- function(xy, percent = 95,
                                          unin=c("m", "km"),
                                          unout=c("ha", "km2", "m2"), id) {
   
    unin <- match.arg(unin)
    unout <- match.arg(unout)
    id <- id
    
    idcolumnName = id
    index_id = grep(idcolumnName, colnames(xy@data))
    
    if (is.na(index)){
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
  
    colnames(tmp5) <- c("id", "type", "ind.home.range", "pop.home.range", "rmi.index")
   
    result <- tmp5
   
    options( warn = 0 )
    return(result)
    
   
}


.divide <- function(x,y) {
    result <- 0
    
    options( warn = -1 )
    if (y!=0){
        result <- x/y
    }
    
    return (result)
    
}


