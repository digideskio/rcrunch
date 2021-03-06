% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataset.R
\docType{methods}
\name{dataset-variables}
\alias{allVariables}
\alias{allVariables,CrunchDataset-method}
\alias{allVariables<-}
\alias{allVariables<-,CrunchDataset,VariableCatalog-method}
\alias{dataset-variables}
\alias{variables}
\alias{variables,CrunchDataset-method}
\alias{variables<-}
\alias{variables<-,CrunchDataset,VariableCatalog-method}
\title{Access a Dataset's Variables Catalog}
\usage{
\S4method{variables}{CrunchDataset}(x)

\S4method{variables}{CrunchDataset,VariableCatalog}(x) <- value

\S4method{allVariables}{CrunchDataset}(x)

\S4method{allVariables}{CrunchDataset,VariableCatalog}(x) <- value
}
\arguments{
\item{x}{a Dataset}

\item{value}{For the setters, a VariableCatalog to assign.}
}
\value{
Getters return VariableCatalog; setters return \code{x} duly
modified.
}
\description{
Datasets contain collections of variables. For a few purposes, such as
editing variables' metadata, it is helpful to access these variable catalogs
more directly.
}
\details{
\code{variables} gives just the active variables in the dataset, while
\code{allVariables}, as the name suggests, yields all variables, including
hidden variables.
}

