% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/json.R
\docType{methods}
\name{tojson-crunch}
\alias{jsonprep}
\alias{jsonprep,ANY-method}
\alias{jsonprep,Categories-method}
\alias{jsonprep,OrderGroup-method}
\alias{jsonprep,ShojiOrder-method}
\alias{jsonprep,list-method}
\alias{toJSON}
\alias{tojson-crunch}
\title{toJSON methods for Crunch objects}
\usage{
jsonprep(x, ...)

\S4method{jsonprep}{Categories}(x, ...)

\S4method{jsonprep}{list}(x, ...)

\S4method{jsonprep}{ANY}(x, ...)

\S4method{jsonprep}{ShojiOrder}(x, ...)

\S4method{jsonprep}{OrderGroup}(x, ...)

toJSON(x, ...)
}
\arguments{
\item{x}{the object}

\item{...}{additional arguments}
}
\value{
\code{jsonprep} returns a base R object that \code{jsonlite::toJSON}
can handle. \code{toJSON} returns the JSON-serialized character object.
}
\description{
\code{crunch} uses the \code{jsonlite} package for (de)serialization of
JSON. Unlike \code{RJSONIO}'s \code{toJSON}, \code{\link[jsonlite]{toJSON}}
does not allow for defining S4 methods for other object types. So,
\code{crunch::toJSON} wraps \code{jsonprep}, which exists to translate
objects to base R objects, which \code{jsonlite::toJSON} can handle.
\code{jsonprep} is defined as an S4 generic, and it is exported (unlike
code{jsonlite::asJSON}), so you can define methods for it if you have other
objects that you want to successfully serialize to JSON.
}
\seealso{
\code{\link[jsonlite]{toJSON}}
}

