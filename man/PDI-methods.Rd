\name{as.matrix.extractPointsXY}
\alias{as.matrix.extractPointsXY}
\alias{as.matrix.extractPolygonPointsXY}
\alias{compute.Individual.PDI}
\alias{compute.k12hat}
\title{Extracts XY coordinates from the Individuals object}
\usage{
as.matrix.extractPointsXY(x, ...)

as.matrix.extractPolygonPointsXY(x, ...)

compute.k12hat(df1, df2, polygon, polyscale)

compute.Individual.PDI(id, df, polygon, polyscale)
}
\arguments{
  \item{x}{- Individual object}

  \item{x}{- Spatial Polygon}

  \item{df1}{- data frame of coordinates of this animal id}

  \item{df2}{- data frame of coordinates of other animals
  from the same population}

  \item{id}{- animal id}

  \item{df}{- data frame of the Individuals of the same
  population}
}
\description{
Extracts XY coordinates from the Individuals object

Extracts XY coordinates from the Spatial Polygon of the
Individual object

Computes biviariate function for a single animal
constructed as the Individual object

Computes PDIndex for a single animal constructed as the
Individual object
}

