setGeneric("importMoveTracks", function(x, y, time, data, proj=NA, ...) standardGeneric("importMoveTracks"))
setMethod(f = "importMoveTracks", 
          signature = c(x="character",y='missing',time='missing', data='missing', proj='missing'), 
          definition = function(x, ...){
              if(!file.exists(x))
                  stop("x should be a file on disk but it cant be found")
              if(grepl(".zip", x))
              {
                  files<-as.character(unzip(x,list=T)$Name)
                  if(1!=sum(rd<-(files=='readme.txt'))| length(files)!=2)
                      stop('zip file not as expected')
                  Individuals<-importMoveTracks(unz(x, files[!rd]),...)
                  close(con)
                  return(m)
              }else{
                  return(importMoveTracks(file(x),...))
              }
              
          })
setMethod(f = "importMoveTracks", 
          signature = c(x="file",y='missing',time='missing', data='missing', proj='missing'), 
          definition = function(x, removeDuplicatedTimestamps=F,...){
              df <- read.csv(x, header=TRUE, sep=",", dec=".", stringsAsFactors=T)
              
              if (!all(c("timestamp", 
                         "location.long",  
                         "location.lat", 
                         "study.timezone", 
                         "study.local.timestamp", 
                         "sensor.type", 
                         "individual.local.identifier", 
                         "individual.taxon.canonical.name")%in%colnames(df))){
                  stop("The entered file does not seem to be from Movebank. Please use the alternative import function.")
              }
              
              df$timestamp <- as.POSIXct(strptime(df$timestamp,format="%Y-%m-%d %H:%M",tz="GMT"))
              df$study.local.timestamp <- as.POSIXct(strptime(df$study.local.timestamp, format="%Y-%m-%d %H:%M:%OS"))
              
              if(any(tapply(df$sensor.type, df$individual.local.identifier, length)!=1)){
                  df <- df[with(df, order(df$individual.local.identifier, timestamp)), ]  
              }
              df$individual.local.identifier<-as.factor( df$individual.local.identifier)
              levels(df$individual.local.identifier) <- raster:::.goodNames(levels(factor(df$individual.local.identifier))) 
              
              if("visible" %in% colnames(df))
              {
                  v<-df$visible=='false'
              }else{
                  v<-F
              }
              unUsed<-is.na(df$location.long)|is.na(df$location.lat)|v| is.na(df$individual.local.identifier)| df$individual.local.identifier==''
              sensor<-df$sensor.type
              
              df$time<-df$timestamp
              df$id<-df$tag.local.identifier
              df$pop.type <- df$individual.taxon.canonical.name
              unUsedDf<-df[unUsed,]
              
              df<-df[!unUsed,]
              data.xy <- df[, c(x="utm.easting",y="utm.northing")]
              proj4string <-  CRS("+proj=utm +zone=28 +datum=WGS84")
              attr.columns <- setdiff(colnames(df),colnames(data.xy))
              data.attr  <- df[,attr.columns]
              
              spatial.points <- SpatialPoints(data.xy)
              spatial.df <- SpatialPointsDataFrame(coords = spatial.points, data = data.attr, 
                                                   proj4string = proj4string, match.ID = TRUE)
              
              individuals <- new ("Individuals", spatial.df, group.by = "pop.type")
              
              return(individuals)
              
          }
)

setMethod(f = "importMoveTracks", 
          signature = c(x="data.frame",y='missing',time='missing', data='missing', proj='ANY'), 
          definition = function(x,y,time,data,proj, ...){
              data.xy <- x[,c(x="x",y="y")]
              attr.columns <- setdiff(colnames(x),colnames(data.xy))
              data.attr  <- x[,attr.columns]
              
              spatial.points <- SpatialPoints(data.xy)
              spatial.df <- SpatialPointsDataFrame(coords = spatial.points, data = data.attr, 
                                                   proj4string = proj, match.ID = TRUE)
              
              new ("Individuals", spatial.df, group.by = "pop.type")
          }
)

