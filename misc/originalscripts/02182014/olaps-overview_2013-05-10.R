load("/apps/git/animalmove/misc/originaldata/martin/khulanData.Rdata")

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


#blup <- t(sapply(1:length(blup),function(x)c(blup[[x]],rep("",max(ol$numberOfIndividuals)-ol$numberOfIndividuals[x]))))
#colnames(blup) <- paste("individual",1:ncol(blup),sep="")

#maxIndivs einfügen

ss <- overlapOverview(dat,start=c("2009-07-20 00:00","2009-07-21 00:00"),end="2010-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL)

