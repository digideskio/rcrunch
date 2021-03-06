% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset.R, R/shoji.R, R/variable.R
\docType{methods}
\name{describe}
\alias{alias,CrunchVariable-method}
\alias{alias<-}
\alias{alias<-,CrunchVariable-method}
\alias{describe}
\alias{description}
\alias{description,CrunchDataset-method}
\alias{description,CrunchVariable-method}
\alias{description<-}
\alias{description<-,CrunchDataset-method}
\alias{description<-,CrunchVariable-method}
\alias{endDate}
\alias{endDate,CrunchDataset-method}
\alias{endDate<-}
\alias{endDate<-,CrunchDataset-method}
\alias{id,CrunchDataset-method}
\alias{name}
\alias{name,CrunchDataset-method}
\alias{name,CrunchVariable-method}
\alias{name,ShojiObject-method}
\alias{name<-}
\alias{name<-,CrunchDataset,character-method}
\alias{name<-,CrunchVariable,character-method}
\alias{startDate}
\alias{startDate,CrunchDataset-method}
\alias{startDate<-}
\alias{startDate<-,CrunchDataset-method}
\title{Name, alias, and description for Crunch objects}
\usage{
\S4method{name}{CrunchDataset}(x)

\S4method{name}{CrunchDataset,character}(x) <- value

\S4method{description}{CrunchDataset}(x)

\S4method{description}{CrunchDataset}(x) <- value

\S4method{startDate}{CrunchDataset}(x)

\S4method{startDate}{CrunchDataset}(x) <- value

\S4method{endDate}{CrunchDataset}(x)

\S4method{endDate}{CrunchDataset}(x) <- value

\S4method{id}{CrunchDataset}(x)

\S4method{name}{ShojiObject}(x)

\S4method{name}{CrunchVariable}(x)

\S4method{name}{CrunchVariable,character}(x) <- value

\S4method{description}{CrunchVariable}(x)

\S4method{description}{CrunchVariable}(x) <- value

\S4method{alias}{CrunchVariable}(object)

\S4method{alias}{CrunchVariable}(x) <- value
}
\arguments{
\item{x}{a Dataset or Variable.}

\item{value}{For the setters, a length-1 character vector to assign}

\item{object}{Same as \code{x} but for the \code{alias} method, in order to
match the generic from another package. Note that \code{alias} is only
defined for Variables.}
}
\value{
Getters return the character object in the specified slot; setters
return \code{x} duly modified.
}
\description{
Name, alias, and description for Crunch objects
}
\seealso{
\code{\link{Categories}} \code{\link{describe-catalog}}
}

