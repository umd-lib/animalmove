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

data(puechabonsp)
sampleds <- puechabonsp

test_that("Valid objects can be created for the Individuals class", {
  reloc <- sampleds$relocs
  reloc@data$type <- "type1"
  reloc@data[1:50,5] <- "type2"
  testObject <- Individuals(reloc, group.by = "type")
  expect_equal(length(testObject@coords), length(dataIn@coords))
  expect_true(validObject(testObject))
})

test_that("Individuals objects can't be created with simple vectors or frames", {
  vector <- c(1,3, 5)
  expect_error(Individuals(vector))
  
  frame <- data.frame(x = vector, y = vector)
  expect_error(Individuals(frame))
  

})

test_that("mcp.population is properly computed", {
  reloc <- sampleds$relocs
  pop <- Individuals(reloc, group.by = "Name")
  pop.mcp <- mcp.population(pop)
  cp <- mcp(puechabonsp$relocs[,1], percent=95)
  
  expect_equal(as.data.frame(cp), pop.mcp@data)
})

test_that("mcp.area.population is properly computed", {
  reloc <- sampleds$relocs
  pop <- Individuals(reloc, group.by = "Name")
  pop.mcp <- mcp.area.population(pop)
  mcp(puechabonsp$relocs[,1], percent=95)
})