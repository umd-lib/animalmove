#RMI && PDI

rmiPossOlap <- overlapOverview(dat,start=c("2009-07-20 00:00"),end="2010-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL)


rmiOLap <- extractOverlapData(dat,possOlaps=rmiPossOlap,rown=1,completeSetsOnly=TRUE)
head(rmiOLap)

# MCI
mciPossOlaps <- overlapOverview(dat,start=c("2009-01-01 00:00"),end="2009-12-31 00:00",interval=c("50 hours"),accuracy=c("3 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL)
mciOlap <- extractOverlapData(dat,possOlaps=mciPossOlaps,rown=1,completeSetsOnly=TRUE)


time.reference <- min(mciPossOlaps$overview$firstOverlap)
time.reference <- as.POSIXlt(time.reference, tz="GMT")
mciOlap$time.lag <-  difftime(mciOlap$time, time.reference, unit="days")
head(mciOlap)


rmiPossOlap1 <- overlapOverview(khulan.test.data,start=c("2009-07-20 00:00"),end="2010-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL)

rmiOLap1 <- extractOverlapData(khulan.test.data,possOlaps=rmiPossOlap1,rown=1,completeSetsOnly=TRUE)
head(rmiOLap1)


subsample <- function(data, startTime, endTime, interval=c("24 hours","48 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL, completeSetsOnly=TRUE, index.type)

#RMI&PDI subsampling
    
rmi.sample <- subsample(khulan.test.data, start=c("2009-07-20 00:00"),end="2010-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL,index.type="rmi")

head(rmi.sample)

#MCI subsampling
mci.sample <- subsample(khulan.test.data, start=c("2009-07-20 00:00"),end="2010-07-21 00:00",interval=c("25 hours","50 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL,index.type="mci")

head(mci.sample)

