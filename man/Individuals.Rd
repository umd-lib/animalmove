\docType{class}
\name{Individuals}
\alias{Individuals}
\alias{Individuals-class}
\title{The Individuals class}
\usage{
RMIndex(df)
}
\description{
The \code{Individuals} object contains at least animal id,
population type and xy coordinates of an animal. In order
to analyze the temporal #' # #population patterns it should
also have time lag attribute. It can contain further
attribute data such as sex or age. These data are stored in
the attribute #'data data.frame.

The \code{RMI} object contains Realized Mobility Index data
frame, which is computed for the populations of
Inidividuals.
}
\details{
This line and the next ones go into the details. This line
thus appears in the details as well.

This line and the next ones go into the details. This line
thus appears in the details as well.
}
\note{
Initial implementation of the package does not include
export of this object to other packages to program against

Initial implementation of the package does not include
export of this object to other packages to program against
}
\section{Slots}{
  \describe{ \item{\code{group.by}:}{Object of class
  \code{"character"}, column name in the attribute
  data.frame that contains population type of the animal
  belongs to;} \item{\code{data}:}{Object of class
  \code{"data.frame"}, additional data of that object that
  is stored in the SpatialPointsDataFrame} }
}

\section{Slots}{
  \describe{ \item{\code{group.by}:}{Object of class
  \code{"character"}, column name in the attribute
  data.frame that contains population type of the animal
  belongs to;} \item{\code{data}:}{Object of class
  \code{"data.frame"}, additional data of that object that
  is stored in the SpatialPointsDataFrame} }
}
\author{
Irina Belyaeva

Irina Belyaeva
}

