data(puechabonsp)


xc <- round(runif(10), 2)
yc <- round(runif(10), 2)
xy <-  cbind(xc, yc)
xy
xy.sp <-  SpatialPoints(xy)

xy.sp

plot(xy.sp, pch = 2)

xy.cc = coordinates(xy.sp)

class(xy.cc)

dimensions(xy.sp)

xy.sp[1:2]

xy.sp[1:3]

xy.df = as.data.frame(xy.sp)

dim(xy.df)

summary(xy.sp)

df = data.frame(z1 = round(5 + rnorm(10), 2), z2 = 20:29)

xy.spdf = SpatialPointsDataFrame(xy.sp, df)

xy.spdf

summary(xy.spdf)

xy.spdf[1:2, ] # selects row 1 and 2



coordinates(df2)[1:2,]

df2[["z2"]]

df2[["z2"]][10] = 20

summary(df2)

bubble(df2, "z1", key.space = "bottom")

spplot(df2, "z1", key.space = "bottom")

## making Individuals data frame
xs <- round(runif(10), 2)
ys <- round(runif(10), 2)

lt <-  cbind(xc, yc)
lt
lt.sp <-  SpatialPoints(lt)
lt.sp
df = data.frame(z1 = round(5 + rnorm(10), 2), z2 = 20:29)
lt.spdf <- SpatialPointsDataFrame(lt.sp, df)
lt.ind <- Individuals(lt.spdf, group.names = c("good"))

