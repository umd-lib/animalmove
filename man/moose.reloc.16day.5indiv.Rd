\name{moose.reloc.16day.5indiv}
\alias{moose.reloc.16day.5indiv}
\docType{data}
\title{
Moose data set - 5 individuals observed during 16 days
}
\description{
Caribou data set contains 80 observations of  5 individuals observed during 16 days.
}
\usage{data(moose.reloc.16day.5indiv)}
\format{
  The format is:
Formal class 'Individuals' [package "animalmove"] with 6 slots
  ..@ group.by   : chr "pop.type"
  ..@ data       :'data.frame':	80 obs. of  2 variables:
  .. ..$ id      : Factor w/ 5 levels "F6","M4","M6",..: 1 1 1 1 1 1 1 1 1 1 ...
  .. ..$ pop.type: chr [1:80] "moose" "moose" "moose" "moose" ...
  ..@ coords.nrs : num(0) 
  ..@ coords     : num [1:80, 1:2] 1808336 1807318 1806820 1804499 1805478 ...
  .. ..- attr(*, "dimnames")=List of 2
  .. .. ..$ : NULL
  .. .. ..$ : chr [1:2] "x" "y"
  ..@ bbox       : num [1:2, 1:2] 1798642 493789 1821501 515468
  .. ..- attr(*, "dimnames")=List of 2
  .. .. ..$ : chr [1:2] "x" "y"
  .. .. ..$ : chr [1:2] "min" "max"
  ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slots
  .. .. ..@ projargs: chr NA
}
\details{
%%  ~~ If necessary, more details than the __description__ above ~~
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\examples{
data(moose.reloc.16day.5indiv)
## maybe str(moose.reloc.16day.5indiv) ; plot(moose.reloc.16day.5indiv) ...
}
\keyword{datasets}
