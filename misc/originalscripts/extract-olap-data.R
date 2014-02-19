extractOverlapData <- function(dat,possOlaps,rown,completeSetsOnly=TRUE){
  interval <- possOlaps[[1]][rown,4]
  i <- unlist(strsplit(interval," "))
  i <- as.difftime(as.numeric(i[1]),units=i[2])
  i <- as.numeric(i,units="secs")
  accuracy <- possOlaps[[1]][rown,5]
  a <- unlist(strsplit(accuracy," "))
  a <- as.difftime(as.numeric(a[1]),units=a[2])
  a <- as.numeric(a,units="secs")
  start <- possOlaps[[1]][rown,6]
  s <- as.numeric(strptime(start,format="%Y-%m-%d %H:%M",tz="GMT"))
  end <- possOlaps[[1]][rown,9]
  e <- as.numeric(strptime(end,format="%Y-%m-%d %H:%M",tz="GMT"))
  indivs <- possOlaps[[2]][[rown]]
  time <- as.numeric(strptime(dat$time,format="%Y-%m-%d %H:%M:%S",tz="GMT"))
  dd <- data.frame(id=dat$id,time,recID=1:nrow(dat))
  dd <- dd[dd$id%in%indivs,]
  iDat <- split(dd,dd$id)
  scantimes <- seq(s,e,i) # create scantimes
  stlo <- scantimes - a 
  sthi <- scantimes + a
  br <- sort(c(stlo,sthi)) # make breaks for following function
  intervalID <- factor(findInterval(dd$time,br),levels=seq(1,by=2,length.out=length(scantimes)))#   seq_along(br[-1]))
  p <- split(dd,intervalID,drop=FALSE) #        p <- p[seq_along(p)%%2==1]
  p <- lapply(p,function(x)split(x,as.character(x$id)))
  p <- sapply(seq_along(p),function(x)lapply(p[[x]],function(y)if(nrow(y)>1){y[which.min(abs(y$time-scantimes[x])),]}else{y}))
  l <- sapply(p,length)
  recID <- lapply(p,function(x)sapply(x,function(y)y$recID))
  if(completeSetsOnly){
    overlapID <- rep(which(l==length(indivs)),each=length(indivs))
    scantimes <- rep(scantimes[l==length(indivs)],each=length(indivs))
    scantimes <- strftime(as.POSIXlt(scantimes,origin="1970-01-01",tz="GMT"))
    dat <- dat[unlist(recID[l==length(indivs)]),]
    dat <- data.frame(overlapID,scantimes,dat)
  }else{
    overlapID <- rep(seq_along(scantimes),l)
    scantimes <- rep(scantimes,l)
    scantimes <- strftime(as.POSIXlt(scantimes,origin="1970-01-01",tz="GMT"))
    dat <- dat[unlist(recID),]
    dat <- data.frame(overlapID,scantimes,dat)
  }
  rownames(dat) <- 1:nrow(dat)
  return(dat)
}


 s <- Sys.time()
aa <- extractOverlapData(dat,olap=ss,rown=1,completeSetsOnly=TRUE)
e <- Sys.time()
e-s
 aa <- extractOverlapData(dat,possOlaps=ss,rown=1,completeSetsOnly=TRUE)