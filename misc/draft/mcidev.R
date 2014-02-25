abs.std.mean <- function(x, ... ){
    
    # x should be a numerical vector
    # add check for that
    
    len <- length(x)
    x <- data.table(x)
    abs.dist.mean <- x[,list (vector.mean=sum(abs(x - mean(x))), mean = mean(x))]
    sum.abs.vector.mean <- abs.dist.mean[,1, with = FALSE]
    abs.mean <- abs.dist.mean[,2, with = FALSE]
    sum.abs.vector.mean <- sum.abs.vector.mean[1]/len
    abs.std.mean <- sum.abs.vector.mean/abs.mean
      
    return (abs.std.mean)
    
}

#gg <- data.table(xx$x)[,vector.mean:=sum(abs(x - mean(x)))]

gg <- abs.std.mean(x)
gg