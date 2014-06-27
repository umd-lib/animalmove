abs.std.mean1 <- function(x){
    
    # x should be a numerical vector
    # add check for that
    
    len <- length(x)
    print(x)
    mean.abs <- mean(abs(x))
    print("mean.abs")
    print(mean.abs)
    abs.mean.diff.x <- sum(abs(x - mean(x)))
    print("abs.mean.diff.x")
    print(abs.mean.diff.x)
    sum.abs.vector.mean <- abs.mean.diff.x/len
    print("sum.abs.vector.mean")
    print(sum.abs.vector.mean)
    abs.std.mean <- sum.abs.vector.mean/mean.abs
    
    print("abs.std.mean")
    print(abs.std.mean)
    
    return (abs.std.mean)
    
}


x1 = sapply(seq(1:7),abs.std.mean1)
x1

x2 <- 1:4

y2 <- factor(rep(letters[1:2], each = 2))

z = tapply(x2, y2, abs.std.mean1)  
z
