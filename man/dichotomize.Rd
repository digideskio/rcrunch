% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dichotomize.R
\docType{methods}
\name{dichotomize}
\alias{dichotomize}
\alias{dichotomize,CategoricalArrayVariable,ANY-method}
\alias{dichotomize,CategoricalVariable,ANY-method}
\alias{dichotomize,Categories,character-method}
\alias{dichotomize,Categories,logical-method}
\alias{dichotomize,Categories,numeric-method}
\alias{is.dichotomized}
\alias{is.dichotomized,Categories-method}
\alias{undichotomize}
\alias{undichotomize,CategoricalArrayVariable-method}
\alias{undichotomize,CategoricalVariable-method}
\alias{undichotomize,Categories-method}
\title{Indicate how categories represent a dichotomized value}
\usage{
\S4method{is.dichotomized}{Categories}(x)

\S4method{dichotomize}{Categories,numeric}(x, i)

\S4method{dichotomize}{Categories,logical}(x, i)

\S4method{dichotomize}{Categories,character}(x, i)

\S4method{undichotomize}{Categories}(x)

\S4method{dichotomize}{CategoricalVariable,ANY}(x, i)

\S4method{dichotomize}{CategoricalArrayVariable,ANY}(x, i)

\S4method{undichotomize}{CategoricalVariable}(x)

\S4method{undichotomize}{CategoricalArrayVariable}(x)
}
\arguments{
\item{x}{Categories or a Variable subclass that has Categories}

\item{i}{For the \code{dichotomize} methods, the numeric or logical indices
of the categories to mark as "selected", or if character, the Category
"names". Note that unlike some other categorical variable methods,
numeric indices are positional, not with reference to category ids.}
}
\value{
Categories or the Variable, (un)dichotomized accoringly
}
\description{
Multiple Response variables are essentially Categorical Arrays that have
had a category or categories indicated as the "selected" value. These
methods let you set that state.
}
\details{
\code{dichotomize} lets you specify which categories are "selected", while
\code{undichotomize} strips that selection information. Dichotomize converts
a Categorical Array to a Multiple Response, and undichotomize converts back.
}
\seealso{
\code{\link{describe-category}}
}

