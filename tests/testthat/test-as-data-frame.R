context("Getting values to make local R objects")

ca.values <- structure(c(2L, 2L, 1L, NA, 1L, 2L, 1L, 2L, 2L, 2L, NA, 2L, NA, 
NA, 1L, 1L, 2L, 2L, 2L, 1L, NA, 1L, NA, NA, 1L, 1L, 1L, 2L, NA, 
NA, NA, NA, 1L, 2L, NA, NA, 1L, NA, NA, NA, 1L, 2L, 1L, 1L, 1L, 
NA, 1L, NA, 1L, 2L, 1L, NA, 1L, 2L, NA, 1L, 2L, NA, 1L, NA, 2L, 
1L, 1L, 2L, 1L, 1L, 2L, 1L, NA, 1L, 2L, 1L, 1L, 1L, 2L), .Dim = c(25L, 
3L), levels=c("A", "B"), class="factor")

with(fake.HTTP, {
    test.ds <- loadDataset("test ds")
    test.ds@variables@index[["/api/datasets/dataset1/variables/mymrset.json"]]$discarded <- TRUE
    # hiddenVariables(test.ds) <- "mymrset" # Defer implementing MR as.vector
    test_that("setup", {
        expect_identical(dim(test.ds), c(nrow(test.ds), ncol(test.ds)))
        expect_identical(dim(test.ds), c(25L, 5L))
        expect_identical(names(test.ds),
            c("birthyr", "gender", "textVar", "starttime", "catarray"))
    })
    
    test_that("as.vector on Variables", {
        expect_true(is.numeric(as.vector(test.ds$birthyr)))
        expect_true(is.factor(as.vector(test.ds$gender)))
        expect_true(all(levels(as.vector(test.ds$gender)) %in% names(categories(test.ds$gender))))
    })
    
    test_that("as.vector on Categorical Array", {
        expect_true(is.CA(test.ds$catarray))
        expect_true(is.matrix(as.vector(test.ds$catarray)))
        expect_identical(as.vector(test.ds$catarray), ca.values)
    })

    test_that("as.data.frame on CrunchDataset yields CrunchDataFrame", {
        expect_false(is.data.frame(as.data.frame(test.ds)))
        expect_true(inherits(as.data.frame(test.ds), "CrunchDataFrame"))
        expect_identical(dim(as.data.frame(test.ds)), c(25L, ncol(test.ds)))
        expect_identical(names(as.data.frame(test.ds)), names(test.ds))
        expect_identical(as.data.frame(test.ds)$birthyr, as.vector(test.ds$birthyr))
        expect_identical(evalq(gender, as.data.frame(test.ds)), 
            as.vector(test.ds$gender))
    })
    
    test_that("as.data.frame(as.data.frame())", {
        expect_true(is.data.frame(as.data.frame(as.data.frame(test.ds))))
        expect_true(is.data.frame(as.data.frame(test.ds, force=TRUE)))
    })
    
    test_that("as.data.frame size limit", {
        options(crunch.data.frame.limit=50)
            expect_error(as.data.frame(test.ds, force=TRUE), 
                "Dataset too large to coerce")
            expect_true(is.data.frame(as.data.frame(test.ds[,1:2], force=TRUE)))
        options(crunch.data.frame.limit=10000)
    })
    
    test.df <- as.data.frame(test.ds)
    
    test_that("model.frame thus works on CrunchDataset", {
        expect_identical(model.frame(birthyr ~ gender, data=test.df),
            model.frame(birthyr ~ gender, data=test.ds))
    })
    
    test_that("so lm() should work too", {
        test.lm <- lm(birthyr ~ gender, data=test.ds)
        expected <- lm(birthyr ~ gender, data=test.df)
        expect_true(inherits(test.lm, "lm"))
        expect_identical(names(test.lm), names(expected))
        for (i in setdiff(names(expected), "call")) {
            expect_identical(test.lm[[i]], expected[[i]])
        }
    })
})

if (run.integration.tests) {
    with(test.authentication, {
        with(test.dataset(df), {        
            test_that("as.vector methods correctly handle data from the API", {
                expect_true(is.Numeric(ds[["v1"]]))
                expect_true(is.Text(ds[["v2"]]))
                expect_true(is.Numeric(ds[["v3"]]))
                expect_true(is.Categorical(ds[["v4"]]))
                expect_true(is.Datetime(ds$v5))
        
                expect_true(is.numeric(as.vector(ds$v1)))
                expect_identical(sum(is.na(as.vector(ds$v1))), 5L)
                expect_equivalent(as.vector(ds$v1), df$v1)
        
                expect_true(is.character(as.vector(ds$v2)))
                expect_identical(sum(is.na(as.vector(ds$v2))), 5L)
                expect_equivalent(as.vector(ds$v2), df$v2)
        
                expect_true(is.numeric(as.vector(ds$v3)))
                expect_equivalent(as.vector(ds$v3), df$v3)
                
                expect_true(is.factor(as.vector(ds$v4)))
                expect_equivalent(as.vector(ds$v4), df$v4)
                
                expect_true(inherits(as.vector(ds$v5), "Date"))
                expect_equivalent(as.vector(ds$v5), df$v5)
            })
        
            test_that("as.data.frame with API", {
                expect_false(is.data.frame(as.data.frame(ds)))
                expect_true(inherits(as.data.frame(ds), "CrunchDataFrame"))
                expect_identical(dim(as.data.frame(ds)), dim(df))
                expect_identical(names(as.data.frame(ds)), names(df))
                expect_identical(as.data.frame(ds)$v1,
                    as.vector(ds$v1))
            })
            
            test_that("as.data.frame(force) with API", {
                expect_true(is.data.frame(as.data.frame(as.data.frame(ds))))
                expect_true(is.data.frame(as.data.frame(ds, force=TRUE)))
            })
            
            v2 <- ds$v2
            delete(v2)
            test_that("CrunchDataFrame lazily fetches columns", {
                expect_true("v2" %in% names(ds)) ## ds is stale
                expect_true(inherits(as.data.frame(ds), "CrunchDataFrame"))
                ## This should error because it will try to get values for v2
                expect_error(as.data.frame(ds, force=TRUE))
            })
        
            test_that("model.frame thus works on CrunchDataset over API", {
                ## would like this to be "identical" instead of "equivalent"
                expect_equivalent(model.frame(v1 ~ v3, data=ds),
                    model.frame(v1 ~ v3, data=df))
            })
        
            test_that("so lm() should work too over the API", {
                test.lm <- lm(v1 ~ v3, data=ds)
                expected <- lm(v1 ~ v3, data=df)
                expect_true(inherits(test.lm, "lm"))
                expect_identical(names(test.lm), names(expected))
                ## would like this to be "identical" instead of "equivalent"
                for (i in setdiff(names(expected), "call")) {
                    expect_equivalent(test.lm[[i]], expected[[i]])
                }
            })
        })
    })
}
