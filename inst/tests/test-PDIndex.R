data(caribou.reloc.16day.5indiv)
data(gazelle.reloc.16day.5indiv)
data(moose.reloc.16day.5indiv)
data(guanaco.reloc.16day.5indiv)

caribou.scale = seq(0,100000,5000) #caribou and gazelles
gazelle.scale = caribou.scale
moose.scale = seq(0,10000,500) #moose
guanaco.scale = seq(0,15000,500) #guanaco

test_that("PDIndex objects can be created properly", {
  caribou.pdi <- pdi.index(caribou.reloc.16day.5indiv, percent = 100, caribou.scale, unin = "m", unout = "km2")
  moose.pdi <- pdi.index(moose.reloc.16day.5indiv, percent = 100,   moose.scale, unin = "m", unout = "km2")
  expect_equivalent(class(moose.pdi), "PDIndex")
  expect_equal(length(moose.pdi@data), length(caribou.pdi@data))
})

test_that("summary.pdi is properly dispatched as the summary function", {
  pdi <- pdi.index(caribou.reloc.16day.5indiv, percent = 100, caribou.scale, unin = "m", unout = "km2")
  summary1 <- summary(pdi)
  summary2 <- summary.pdi(pdi)
  expect_equivalent(summary1, summary2)
})

test_that("PDIndex objects can be properly plotted", {
  caribou.pdi <- pdi.index(caribou.reloc.16day.5indiv, percent = 100, caribou.scale, unin = "m", unout = "km2")
  gazelle.pdi <- pdi.index(gazelle.reloc.16day.5indiv, percent = 100, gazelle.scale, unin = "m", unout = "km2")
  guanaco.pdi <- pdi.index(guanaco.reloc.16day.5indiv, percent = 100, guanaco.scale, unin = "m", unout = "km2")
  moose.pdi <- pdi.index(moose.reloc.16day.5indiv, percent = 100,   moose.scale, unin = "m", unout = "km2")
  
  
  #Get summaries of each specie PDI
  
  summary.caribou <- summary.pdi(caribou.pdi)
  summary.gazelle <- summary.pdi(gazelle.pdi)
  summary.guanaco <- summary.pdi(guanaco.pdi)
  summary.moose <- summary.pdi(moose.pdi)
  
  # Create X and Y axes for each species
  
  # caribou
  caribou.X <- c(summary.caribou$scale, rev(summary.caribou$scale))
  caribou.Y <- c(summary.caribou$mean.pdi + summary.caribou$se.pdi, rev(summary.caribou$mean.pdi - summary.caribou$se.pdi))
  
  # gazelle
  gazelle.X <- c(summary.gazelle$scale, rev(summary.gazelle$scale))
  gazelle.Y <- c(summary.gazelle$mean.pdi + summary.gazelle$se.pdi, rev(summary.gazelle$mean.pdi - summary.gazelle$se.pdi))
  
  # guanaco
  guanaco.X <- c(summary.guanaco$scale, rev(summary.guanaco$scale))
  guanaco.Y <- c(summary.guanaco$mean.pdi + summary.guanaco$se.pdi, rev(summary.guanaco$mean.pdi - summary.guanaco$se.pdi))
  
  # moose
  moose.X <- c(summary.moose$scale, rev(summary.moose$scale))
  moose.Y <- c(summary.moose$mean.pdi + summary.moose$se.pdi, rev(summary.moose$mean.pdi - summary.moose$se.pdi))
  
  
  
  # Plot default settings
  
  colorCaribou = "pink" 
  colorGazelle = "lightblue"
  colorGuanaco = "khaki1"#"#FFFF99"
  colorMoose = "lightgreen"
  colorCaribou2 = "red" 
  colorGazelle2 = "blue"
  colorGuanaco2 =  "darkorange"
  colorMoose2 = "darkgreen"
  
  cexValue = 1
  
  # Change number of panels in the plotting window back to a single panel
  par(mfrow=c(1,1))
  
  # Change margin size 
  #par(mar = c(5, 5, 2, 1)) 
  
  # Create empty plot, with axes labels
  plot(caribou.scale, summary.gazelle$mean.pdi, ylim = c(-25000,5000), xlim = c(0,50000), col = NA,  
       ylab = "Population Dispersion Index", xlab = "lag (km)",
       cex.lab = cexValue, cex.axis = cexValue,cex = cexValue, axes = F)
  
  #Add caribou data
  polygon(caribou.X, caribou.Y, col = colorCaribou, border = NA) # plots CI's
  
  #Add gazelle data
  polygon(gazelle.X, gazelle.Y, col = colorGazelle, border = NA) # plots CI's
  
  # Add Moose data
  polygon(moose.X, moose.Y, col = colorMoose, border = NA) # plots CI's
  
  # Add guanaco data
  polygon(guanaco.X, guanaco.Y, col = colorGuanaco, border = NA) # plots CI's
  
  
  # Add lines
  lines(summary.caribou$scale,summary.caribou$mean.pdi,col = colorCaribou2, lwd = 2) # plots PDI
  lines(summary.gazelle$scale,summary.gazelle$mean.pdi,col = colorGazelle2, lwd = 2) # plots PDI
  lines(summary.moose$scale,summary.moose$mean.pdi,col = colorMoose2, lwd = 2) # plots PDI
  lines(summary.guanaco$scale,summary.guanaco$mean.pdi,col = colorGuanaco2, lwd = 2) # plots PDI
  
  
  lines(c(0,100000),c(0,0),lwd = 2, lty = 1) # add baseline
  
  #Add axes
  axis(1, at=seq(0,50000,10000),labels = seq(0,50,10), cex.axis = cexValue)
  axis(2,at = seq(-25000,5000,10000), cex.axis= cexValue)
  
  #Add legend
  legend(-1000,-18000, legend = c("Caribou (C)", "M. gazelle (MG)", "Guanaco (G)","Moose (M)"), col = c( colorCaribou2,colorGazelle2, colorGuanaco2,colorMoose2),        box.lty= 0,lty = 1, lwd = 3, cex = cexValue, bg = NA)
  par(mfrow=c(2,2))
  par(cex=0.35)
  plot(caribou.pdi, col = colorCaribou, linecol = colorCaribou2, title = "Spatial Population Dispersion - Caribou, Kilometers")
  plot(gazelle.pdi, col = colorGazelle, linecol = colorGazelle2, title = "Spatial Population Dispersion - Gazelle, Kilometers")
  plot(moose.pdi, col = colorMoose, linecol = colorMoose2, title = "Spatial Population Dispersion - Moose, Kilometers")
  plot(guanaco.pdi, col = colorGuanaco, linecol = colorGuanaco2, title = "Spatial Population Dispersion - Guanaco, Kilometers")
  
})