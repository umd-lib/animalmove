\name{Individuals-class}

\alias{Individuals}
\alias{Individuals-class}
\alias{Individuals,ANY,ANY-class}


\docType{class}

\title{
The Individuals class
}

\description{
  The Individuals object contains at least animal id,
population type and xy coordinates of an animal. In order
to analyze the temporal population patterns it should
also have timestamp attribute. It can contain further
attribute data such as sex or age. 
}


\note{
Initial implementation of the package does not include
export of this object to other packages to program against
}

\section{Slots}{
  \describe{
    \item{data}{belongs to the SpatialPointsDataFrame}
    \item{id}{a vector that indicates, which data, coordinates and timestamps belong to an individual}
    \item{time}{timestamps according to the coordinates}
    \item{x}{x coordinates}
    \item{y}{y coordinates}
    \item{group.by}{population type or species name (taxon name)}
    \item{proj4string}{projection of all coordinates}
    }
}

\section{Methods}{
  Methods defined with class "Individuals" in the signature:
    \describe{
      \item{\code{\link{summary}}}{\code{signature(object = "Individuals")}: provides summary of Individuals object}
       \item{\code{\link{subsample.reloc}}}{\code{signature(data = "Individuals", startTime, endTime, interval=c("24 hours","48 hours"),accuracy=c("3 mins","1 mins"),minIndiv=3,maxIndiv=4,mustIndiv=NULL, completeSetsOnly=TRUE, index.type)}: subsamples Individuals object within selected time period, time interval and accuracy}
       \item{\code{\link{print}}}{\code{signature(x="Individuals")}: provides summary of Individuals object}
       \item{\code{\link{show.mcp}}}{\code{signature(x="Individuals", percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), id)}: provides spatial extent, coordinate reference system and area of each Minimum Convex Polygon found in the Individuals object}
       \item{\code{\link{rmi.index}}}{\code{signature(this="Individuals", percent = 95, unin=c("m", "km"),
                   unout=c("ha", "km2", "m2"), id)}: computes Realized Mobility Index of the Individuals object}
    }

}


