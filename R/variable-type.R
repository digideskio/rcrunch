CASTABLE_TYPES <- c("numeric", "text", "categorical") ## Add datetime when server supports

##' Change the type of Crunch variables
##'
##' Numeric, text, and categorical variables can be cast to one another by
##' assigning them a new "type". This modifes the storage of the data on the
##' server and should only be done in narrow circumstances, as in when importing
##' data from a different file format has resulted in incorrect types being
##' specified. 
##'
##' @param x a Variable
##' @param value For the setter, a character value in c("numeric", "text",
##' "categorical")
##' @return Getter returns character; setter returns \code{x} duly modified.
##' @name type
##' @aliases type type<-
NULL

##' @rdname type
##' @export
setMethod("type", "CrunchVariable", function (x) x@body$type)
## do type casting as type<-

castVariable <- function (x, to) {
    if (!(to %in% CASTABLE_TYPES)) {
        halt(sQuote(to), " is not a Crunch variable type that can be assigned.",
            " Valid types are ", serialPaste(sQuote(CASTABLE_TYPES)))
    }
    if (type(x) != to) { ## no-op if cast type is same as current type
        crPOST(shojiURL(x, "views", "cast"), body=toJSON(list(cast_as=to)))
        x <- refresh(x)
    }
    invisible(x)
}

##' @rdname type
##' @export
setMethod("type<-", "CrunchVariable", 
    function (x, value) castVariable(x, value))

## Methods that prepare a data.frame to be written out as CSV and uploaded
setMethod("preUpload", "data.frame", function (x) {
    x[] <- lapply(x, preUpload)
    return(x)
})
setMethod("preUpload", "ANY", function (x) x)
setMethod("preUpload", "factor", function (x) as.numeric(x))
setMethod("preUpload", "Date", function (x) as.character(x))
setMethod("preUpload", "POSIXt", function (x) as.character(x))

## Functions that modify remote Crunch variables after uploading CSV so that
## all metadata R knows is translated to Crunch.

setMethod("postUpload", "ANY", function (source.var, crunch.var) {
    castVariable(crunch.var, "text")
})
setMethod("postUpload", "numeric", function (source.var, crunch.var) {
    castVariable(crunch.var, "numeric")
})
setMethod("postUpload", "factor", function (source.var, crunch.var) {
    casted <- castVariable(crunch.var, "categorical")
    ## Rename the categories
    cats <- categories(casted)
    v <- values(cats)
    n <- names(cats)
    n[!is.na(v)] <- levels(source.var)[v[!is.na(v)]]
    names(cats) <- n    
    categories(casted) <- cats
    invisible(casted)
})
setMethod("postUpload", "Date", function (source.var, crunch.var) {
    crunch.var
})
setMethod("postUpload", "POSIXt", function (source.var, crunch.var) {
    crunch.var
})