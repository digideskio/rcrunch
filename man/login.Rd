% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auth.R
\name{login}
\alias{login}
\title{Authenticate with the Crunch API}
\usage{
login(email = getOption("crunch.email"), password = getOption("crunch.pw"),
  ...)
}
\arguments{
\item{email}{the email address associated with the user's Crunch account}

\item{password}{the password associated with the user's Crunch account}

\item{...}{additional parameters passed in the authentication. Not
currently supported by the Crunch API.}
}
\description{
Note that you can store your Crunch account info in your .Rprofile under
"crunch.email" and "crunch.pw" for convenience. If you do so, you can simply
\code{login()} to authenticate. For running batch jobs, this could be
particularly useful. However, be warned that storing your
password in a plain text file such as .Rprofile is a security risk (though
perhaps less so than in every .R script you write), and we
cannot officially recommend that you do so.
}
\details{
If a password is not supplied (or, if no arguments are supplied and only
the \code{crunch.email} is specified in .Rprofile), and you are in an
interactive session, you will be prompted to enter your password. At
present, this is the most secure practice as your password is not stored
locally.
}

