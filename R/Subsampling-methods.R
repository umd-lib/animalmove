#' Provides summary of overlapping time intervals
#' @param dat - input data frame
#' @export
#' @rdname Subsampling-methods
#' @return overlap object
overlapOverview <- function(dat,start,end,interval,accuracy,minIndiv=1,maxIndiv=NULL,mustIndiv=NULL){
    ee <- as.numeric(strptime(end,format="%Y-%m-%d %H:%M",tz="GMT"))
    time <- as.numeric(strptime(dat$time,format="%Y-%m-%d %H:%M:%S",tz="GMT"))
    oTab <- data.frame()
    uu <- list()
    for(i in interval){
        for(a in accuracy){
            for(s in start){
                ss <- as.numeric(strptime(s,format="%Y-%m-%d %H:%M",tz="GMT"))
                ii <- unlist(strsplit(i," "))
                ii <- as.difftime(as.numeric(ii[1]),units=ii[2])
                ii <- as.numeric(ii,units="secs")
                aa <- unlist(strsplit(a," "))
                aa <- as.difftime(as.numeric(aa[1]),units=aa[2])
                aa <- as.numeric(aa,units="secs")
                scantimes <- seq(ss,ee,ii) # create scantimes
                stlo <- scantimes - aa 
                sthi <- scantimes + aa
                br <- sort(c(stlo,sthi)) # make breaks for following function
                intervalID <- factor(findInterval(time,br),levels=seq(1,by=2,length.out=length(scantimes)))#   seq_along(br[-1]))
                p <- split(dat$id,intervalID,drop=FALSE) #        p <- p[seq_along(p)%%2==1]
                p <- lapply(p,function(x)unique(as.character(sort(x))))
                u <- unique(p)
                l <- sapply(u,length)
                u <- u[l>=minIndiv & l<=min(maxIndiv,max(l))]
                if(length(mustIndiv)) u <- u[sapply(u,function(x)all(mustIndiv%in%x))]
                if(length(u)){
                    isValidOlap <- lapply(u,function(x)sapply(p,function(y)length(x)<=length(y)&&all(x%in%y)))
                    validOlaps <- lapply(isValidOlap,which)
                    completeSets <- sapply(isValidOlap,sum)
                    pairsOfCompleteSets <- sapply(validOlaps,function(x)sum(diff(x)==1))
                    numberOfIndividuals <- sapply(u,length)
                    firstOverlap <- strftime(as.POSIXlt(scantimes[sapply(validOlaps,min)],origin="1970-01-01",tz="GMT"),format="%F %H:%M")
                    lastOverlap <- strftime(as.POSIXlt(scantimes[sapply(validOlaps,max)],origin="1970-01-01",tz="GMT"),format="%F %H:%M")
                    oTab <- rbind(oTab,data.frame(numberOfIndividuals,pairsOfCompleteSets,completeSets,scanInterval=i,scanAccuracy=a,firstScantime=s,firstOverlap,lastOverlap,lastScantime=end,stringsAsFactors=FALSE))
                    uu <- c(uu,u)
                }
            }
        }
    }
    sorted <- order(oTab[,1],oTab[,2],oTab[,3],decreasing=TRUE)
    oTab <- oTab[sorted,]
    rownames(oTab) <- 1:nrow(oTab)
    uu <- uu[sorted]
    return(list(overview=oTab,individuals=uu))
}

#' Extracts overlaps data from possible overlaps
#' @param dat - input data frame
#' @export
#' @rdname Subsampling-methods
#' @return overlap object
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

subsample <- function(data, startTime, endTime, interval=c("24 hours","48 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL, completeSetsOnly=TRUE, index.type){
    
    poss.overlaps <- overlapOverview(data,start=startTime,end=endTime,interval=interval,accuracy=accuracy,minIndiv=3,maxIndiv=4,mustIndiv=NULL)
    
    if (index.type=="mci"){
        completeSets = TRUE
    }
    else{
        completeSets = completeSetsOnly
    }
    
    subsampled.data <- extractOverlapData(data,possOlaps=poss.overlaps,rown=1,completeSetsOnly=completeSets)
    
    time.reference <- min(poss.overlaps$overview$firstOverlap)
    time.reference <- as.POSIXlt(time.reference, tz="GMT")
    subsampled.data$time.lag <-  difftime(subsampled.data$time, time.reference, unit="days")   
    
    subsampled.data
}


