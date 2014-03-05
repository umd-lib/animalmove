data(puechabonsp)

test_that("abs.std.mean computes the absolute standard mean of numerical vectors", {
  v <- c(1.5, -3, -3.5, 12.5, 0)
  abs.dist <- abs.std.mean(v)
  expect_equal(abs.dist$vector.mean, 4.4/4.1)
})

test_that(".mci.spatial.index.IndividualsDataFrame is properly dispatched from mci.index", {
  relocs <- puechabonsp$relocs
  relocs@data$type <- "type1"
  relocs@data[1:50,]$type <- "type2"
  pop <- Individuals(relocs, group.by="type")
  pop@data$time.lag <- 365
  pop@data[1:50,]$time.lag <- 200
  df <- .mci.spatial.index.IndividualsDataFrame(pop,"time.lag")
  mci <- mci.index(pop, group.by="type", time.lag="time.lag")
  expect_false(any(df != mci))
  object <- MCIndex(mci)
  plot(object)
})

test_that("summary.MCIndex summarizes the results of the MCIndex object", {
  relocs <- puechabonsp$relocs
  relocs@data$type <- "type1"
  relocs@data[1:50,]$type <- "type2"
  pop <- Individuals(relocs, group.by="type")
  pop@data$time.lag <- 365
  pop@data[1:50,]$time.lag <- 200
  df <- .mci.spatial.index.IndividualsDataFrame(pop,"time.lag")
  mci <- mci.index(pop, group.by="type", time.lag="time.lag")
  object <- MCIndex(mci)
  sum1 <- summary(object)
  sum2 <- summary.MCIndex(object)
  expect_equivalent(sum1, sum2)
})