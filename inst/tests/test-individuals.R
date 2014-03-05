library(testthat)
library(animalmove)

data(puechabonsp)
sampleds <- puechabonsp
relocs <- sampleds$relocs

test_that("Valid objects can be created for the Individuals class", {
  reloc <- sampleds$relocs
  reloc@data$type <- "type1"
  reloc@data[1:50,5] <- "type2"
  testObject <- Individuals(reloc, group.by = "type")
  expect_equal(length(testObject@coords), length(reloc@coords))
  expect_true(validObject(testObject))
})

test_that("Individuals objects can't be created with simple vectors or frames", {
  vector <- c(1,3, 5)
  expect_error(Individuals(vector))
  
  frame <- data.frame(x = vector, y = vector)
  expect_error(Individuals(frame))
})

test_that("A valid group.by is needed to create Individuals", {
  expect_error(Individuals(relocs))
  expect_error(Individuals(relocs, group.by = "foo"))
})
test_that("mcp.population is properly computed", {
  pop <- Individuals(relocs, group.by = "Name")
  pop.mcp <- mcp.population(pop)
  cp <- mcp(puechabonsp$relocs[,1], percent=95)
  
  expect_equal(as.data.frame(cp), pop.mcp@data)
})

test_that("mcp.area.population is properly computed", {
  reloc <- sampleds$relocs
  pop <- Individuals(relocs, group.by = "Name")
  pop.area <- mcp.area.population(pop, percent=95)
  expect_equal(length(pop.area), 4)
  pop.area <- mcp.area.population(pop)
  expect_equal(length(pop.area), 4)
})

test_that("group.by is set and used correctly", {
  namepop <- Individuals(relocs, group.by = "Name")
  agepop <- Individuals(relocs, group.by = "Age")
  expect_equal(namepop@group.by, "Name")
  expect_equal(agepop@group.by, "Age")
  
  namemcp <- mcp.area.population(namepop, percent=95, plotit=FALSE)
  agemcp <- mcp.area.population(agepop, percent=95, plotit=FALSE)
  
  expect_equal(length(namemcp), 4)
  expect_equal(length(agemcp), 2)
})

test_that("populations correctly factors based on group.by", {
  name_populations <- populations(Individuals(relocs, group.by = "Name"))
  sex_populations <- populations(Individuals(relocs, group.by = "Sex"))
  expect_true(length(name_populations)>0 && length(sex_populations>0))
  expect_false(any(duplicated(name_populations)) || any(duplicated(sex_populations)))
  expect_false(any(is.na(name_populations)) || any(is.na(sex_populations)))
})

test_that("rmi.index is computed correctly", {
  reloc <- sampleds$relocs
  reloc@data$type <- "type1"
  reloc@data[1:50,5] <- "type2"
  pop <- Individuals(reloc, group.by = "type")
  rmi <- rmi.index(pop, id="Name")
  expect_equal(length(rmi$id), 4)
  expect_false(any(rmi$rmi.index > 1.0))
  expect_true(all(rmi$ind.home.range / rmi$pop.home.range == rmi$rmi.index))
})
