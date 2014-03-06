\docType{class}
\name{PDIndex}
\alias{PDIndex}
\alias{PDIndex-class}
\title{The PDIndex class}
\description{
The \code{PDIndex} object contains Population Dispersion
Index data frame, which is computed for the populations of
Inidividuals.
}
\note{
Object is constructed as a result of pdi.index method call
on the data frame of the Individuals
}
\section{Slots}{
  \describe{ \item{\code{pop.type}:}{Object of class
  \code{"character"}, pop.type - population type}
  \item{\code{scale}:}{Object of class \code{"numeric"},
  scale - scale is used to compute the PDI data matrix}
  \item{\code{data}:}{Object of class \code{"data.frame"},
  PDI data frame, columns - animals id, rows - scale,
  intersection of row and column - is the value of the
  index for the animal and a given scale} }
}
\author{
Irina Belyaeva
}

