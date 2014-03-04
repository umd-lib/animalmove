library(testthat)
require(sqldf)
require(adehabitatHR)
require(sp)

library(adehabitatHR)
library(sp)
library(sqldf)

source('/apps/git/animalmove/R/Class-Individuals.R')
source('/apps/git/animalmove/R/Individuals-methods.R')
source('/apps/git/animalmove/R/MovementAnalysis-methods.R')
source('/apps/git/animalmove/R/Class-RMI.R')
source('/apps/git/animalmove/R/RMI-methods.R')

data(puechabonsp)
sampleds <- puechabonsp
relocs <- sampleds$relocs
relocs@data$type <- "type1"
relocs@data[1:50,5] <- "type2"
pop.data <- Individuals(relocs, group.by = c("type"))
rmi.df <- compute.RealizedMobilityIndex(pop.data, percent = 100,
                                        id="Name")
rmi <- RMIndex(rmi.df)

test_that("compute.RealizedMobilityIndex is computed correctly", {
  expect_equal(length(rmi.df[[1]]), 4)
  expect_false(any(rmi.df$rmi.index > 1.0))
})

test_that("Object creation works properly for RMIndex objects", {
  expect_true(class(rmi) == "RMIndex")
  expect_equal(length(r@data), 5)
})

test_that("RMIndex can be properly summarized using RMIndex object", {
  summary <- summary.rmi(rmi)
  expect_equal(length(summary), 2)
})

test_that("RMIndex can be properly summarized using data.frame", {
  summary <- summary.rmi(rmi.df)
  expect_equal(length(summary), 2)
})