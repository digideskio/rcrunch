% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/category.R
\docType{methods}
\name{describe-category}
\alias{describe-category}
\alias{id}
\alias{id,Category-method}
\alias{is.selected}
\alias{is.selected,Category-method}
\alias{name,Category-method}
\alias{name<-,ANY,ANY-method}
\alias{name<-,Category,character-method}
\alias{value}
\alias{value,Category-method}
\alias{value<-}
\alias{value<-,Category-method}
\title{Category attributes}
\usage{
\S4method{name}{Category}(x)

\S4method{name}{Category,character}(x) <- value

\S4method{name}{ANY,ANY}(x) <- value

\S4method{value}{Category}(x)

\S4method{value}{Category}(x) <- value

\S4method{id}{Category}(x)

\S4method{is.selected}{Category}(x)
}
\arguments{
\item{x}{a Category}

\item{value}{For the setters, an appropriate value to set}
}
\value{
\code{name} returns character; \code{value} and \code{id} return
numeric; value but not id may be \code{NA}; \code{is.selected} returns
logical indicating whether this Category is a "selected" dichotomy. Setters
return \code{x} duly modified.
}
\description{
Category attributes
}
\seealso{
\code{\link{Categories}} \code{\link{dichotomize}}
}

