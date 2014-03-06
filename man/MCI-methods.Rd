\docType{methods}
\name{abs.std.mean}
\alias{TukeyHSD,MCIndex,missing-method}
\alias{abs.std.mean}
\alias{aov,MCIndex,missing,missing,missing,missing-method}
\alias{aov.mci}
\alias{kruskal.test,MCIndex-method}
\alias{kruskalmc,MCIndex-method}
\alias{mci.index,Individuals-method}
\alias{mci.index,SpatialPointsDataFrame-method}
\title{Computing the standartizied distance from the mean}
\usage{
\method{abs}{std.mean}(x)

\S4method{mci.index}{SpatialPointsDataFrame}(object, group.by, time.lag, ...)

\S4method{mci.index}{Individuals}(object, time.lag, ...)

\S4method{aov}{MCIndex,missing,missing,missing,missing}(formula, data,
  projections, qr, contrasts, ...)

aov.mci(formula, data = NULL, projections = FALSE, qr = TRUE,
  contrasts = NULL, print = FALSE)

\S4method{TukeyHSD}{MCIndex,missing}(x, which, ...)

\S4method{kruskal.test}{MCIndex}(x, ...)

\S4method{kruskalmc}{MCIndex}(resp, ...)
}
\arguments{
  \item{x}{- numeric vector}

  \item{object}{An Individuals object}

  \item{object}{An Individuals object}

  \item{object}{An MCIndex object}

  \item{object}{An MCIndex object}

  \item{object}{An MCIndex object}

  \item{object}{An MCIndex object}

  \item{object}{An MCIndex object}

  \item{...}{Arguments to be passed to \code{lm}, such as
  \code{subset} or \code{na.action}.  See \sQuote{Details}
  about \code{weights}.}

  \item{formula}{A formula specifying the model.}

  \item{data}{A data frame in which the variables specified
  in the formula will be found. If missing, the variables
  are searched for in the standard way.}

  \item{projections}{Logical flag: should the projections
  be returned?}

  \item{qr}{Logical flag: should the QR decomposition be
  returned?}

  \item{contrasts}{A list of contrasts to be used for some
  of the factors in the formula. These are not used for any
  \code{Error} term, and supplying contrasts for factors
  only in the \code{Error} term will give a warning.}

  \item{which}{A character vector listing terms in the
  fitted model for which the intervals should be
  calculated.  Defaults to all the terms.}

  \item{resp}{ a numeric vector of data values or a formula
  of the type 'response~category'. }
}
\value{
standartizied distance from the mean
}
\description{
Computing the standartizied distance from the mean

Movement Coordination Index

Movement Coordination Index

ANOVA object computed for Movement Coordination Index
object

Helper method to compute MCIndex

TukeyHSD object computed for Movement Coordination Index
object

Kruskal Test object computed for Movement Coordination
Index object

KruskalMC object computed for Movement Coordination Index
object
}

