context("Dataset object and methods")

with_mock_HTTP({
    test.ds <- loadDataset("test ds")
    test.ds2 <- loadDataset("ECON.sav")
    test.ds3 <- loadDataset("an archived dataset", kind="archived")

    today <- "2016-02-11"

    test_that("Dataset can be loaded", {
        expect_true(is.dataset(test.ds))
    })

    test_that("Dataset attributes", {
        expect_identical(name(test.ds), "test ds")
        expect_identical(description(test.ds), "")
        expect_identical(id(test.ds), "511a7c49778030653aab5963")
    })

    test_that("archived", {
        expect_false(is.archived(test.ds))
        expect_false(is.archived(test.ds2))
        expect_true(is.archived(test.ds3))
    })

    test_that("archive setting", {
        expect_error(is.archived(test.ds2) <- TRUE,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"archived":true}}'),
            fixed=TRUE
        )
        expect_error(archive(test.ds2),
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"archived":true}}'),
            fixed=TRUE
        )
    })

    test_that("draft/published", {
        expect_true(is.published(test.ds))
        expect_false(is.published(test.ds2))
        expect_false(is.draft(test.ds))
        expect_true(is.draft(test.ds2))
    })

    test_that("draft/publish setting", {
        expect_error(is.published(test.ds2) <- TRUE,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"is_published":true}}'),
            fixed=TRUE
        )
        expect_error(is.published(test.ds) <- FALSE,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset1.json":',
                    '{"is_published":false}}'),
            fixed=TRUE
        )
        expect_error(is.draft(test.ds2) <- FALSE,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"is_published":true}}'),
            fixed=TRUE
        )
        expect_error(is.draft(test.ds) <- TRUE,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset1.json":',
                    '{"is_published":false}}'),
            fixed=TRUE
        )
        expect_error(publish(test.ds2),
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"is_published":true}}'),
            fixed=TRUE
        )
        expect_error(publish(test.ds), NA)
        expect_error(is.draft(test.ds) <- FALSE, NA)
        expect_error(is.published(test.ds) <- TRUE, NA)
    })

    test_that("start/endDate", {
        expect_identical(startDate(test.ds), "2016-01-01")
        expect_identical(endDate(test.ds), "2016-01-01")
        expect_null(startDate(test.ds2))
        expect_null(endDate(test.ds2))
    })

    test_that("startDate<- makes correct request", {
        expect_error(startDate(test.ds2) <- today,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"start_date":"2016-02-11"}}'),
            fixed=TRUE
        )
        expect_error(startDate(test.ds) <- NULL,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset1.json":',
                    '{"start_date":null}}'),
            fixed=TRUE
        )
    })
    test_that("endDate<- makes correct request", {
        expect_error(endDate(test.ds2) <- today,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset3.json":',
                    '{"end_date":"2016-02-11"}}'),
            fixed=TRUE
        )
        expect_error(endDate(test.ds) <- NULL,
            paste0('PATCH /api/datasets.json {"/api/datasets/dataset1.json":',
                    '{"end_date":null}}'),
            fixed=TRUE
        )
    })

    test_that("Dataset webURL", {
        with(temp.options(crunch.api="https://fake.crunch.io/api/v2/"), {
            expect_identical(webURL(test.ds),
                "https://fake.crunch.io/dataset/511a7c49778030653aab5963")
        })
    })

    test_that("Dataset VariableCatalog index is ordered", {
        expect_identical(urls(variables(test.ds)),
            c("/api/datasets/dataset1/variables/birthyr.json",
            "/api/datasets/dataset1/variables/gender.json",
            "/api/datasets/dataset1/variables/mymrset.json",
            "/api/datasets/dataset1/variables/textVar.json",
            "/api/datasets/dataset1/variables/starttime.json",
            "/api/datasets/dataset1/variables/catarray.json"))
        ## But allVariables isn't ordered
        expect_true(setequal(urls(allVariables(test.ds)),
            c("/api/datasets/dataset1/variables/birthyr.json",
            "/api/datasets/dataset1/variables/catarray.json",
            "/api/datasets/dataset1/variables/gender.json",
            "/api/datasets/dataset1/variables/mymrset.json",
            "/api/datasets/dataset1/variables/starttime.json",
            "/api/datasets/dataset1/variables/textVar.json")))
    })

    test_that("namekey function exists and affects names()", {
        expect_identical(getOption("crunch.namekey.dataset"), "alias")
        expect_identical(names(test.ds), aliases(variables(test.ds)))
        with(temp.option(crunch.namekey.dataset="name"), {
            expect_identical(names(test.ds), names(variables(test.ds)))
        })
    })

    test_that("Dataset ncol doesn't make any requests", {
        with(temp.options(httpcache.log=""), {
            logs <- capture.output(nc <- ncol(test.ds))
        })
        expect_identical(logs, character(0))
        expect_identical(nc, 6L)
        expect_identical(dim(test.ds), c(25L, 6L))
    })

    test_that("Dataset has names() and extract methods work", {
        expect_false(is.null(names(test.ds)))
        expect_identical(names(test.ds),
            c("birthyr", "gender", "mymrset", "textVar", "starttime", "catarray"))
        expect_true(is.variable(test.ds[[1]]))
        expect_true("birthyr" %in% names(test.ds))
        expect_true(is.variable(test.ds$birthyr))
        expect_true(is.dataset(test.ds[2]))
        expect_identical(test.ds["gender"], test.ds[2])
        expect_identical(test.ds[,2], test.ds[2])
        expect_identical(test.ds[names(test.ds)=="gender"], test.ds[2])
        expect_identical(names(test.ds[2]), c("gender"))
        expect_identical(dim(test.ds[2]), c(25L, 1L))
        expect_null(test.ds$not.a.var.name)
        expect_error(test.ds[[999]], "subscript out of bounds")
    })

    ## This is a start on a test that getting variables doesn't hit server.
    ## It doesn't now, but if variable catalogs are lazily fetched, assert that
    ## we're hitting cache
    # with(temp.option(httpcache.log=""), {
    #     dlog <- capture.output({
    #         v1 <- test.ds$birthyr
    #         d2 <- test.ds[names(test.ds)=="gender"]
    #     })
    # })
    # print(dlog)
    # logdf <- loadLogfile(textConnection(dlog))
    # print(logdf)

    test_that("Dataset extract error handling", {
        expect_error(test.ds[[999]], "subscript out of bounds")
        expect_error(test.ds[c("gender", "NOTAVARIABLE")],
            "Undefined columns selected: NOTAVARIABLE")
        expect_null(test.ds$name)
    })

    test_that("Extract from dataset by VariableOrder/Group", {
        ents <- c("/api/datasets/dataset1/variables/gender.json",
            "/api/datasets/dataset1/variables/mymrset.json")
        ord <- VariableOrder(VariableGroup("G1", entities=ents))
        expect_identical(test.ds[ord[[1]]], test.ds[c("gender", "mymrset")])
        expect_identical(test.ds[ord], test.ds[c("gender", "mymrset")])
    })

    test_that("show method", {
        expect_identical(getShowContent(test.ds),
            c(paste("Dataset", dQuote("test ds")),
            "",
            "Contains 25 rows of 6 variables:",
            "",
            "$birthyr: Birth Year (numeric)",
            "$gender: Gender (categorical)",
            "$mymrset: mymrset (multiple_response)",
            "$textVar: Text variable ftw (text)",
            "$starttime: starttime (datetime)",
            "$catarray: Cat Array (categorical_array)"
        ))
    })

    test_that("dataset can refresh", {
        ds <- loadDataset("test ds")
        expect_identical(ds, refresh(ds))
    })
})

if (run.integration.tests) {
    with_test_authentication({
        with(test.dataset(df), {
            test_that("Name and description setters push to server", {
                d2 <- ds
                name(ds) <- "Bond. James Bond."
                expect_identical(name(refresh(d2)), name(ds))
            })

            test_that("Can set (and unset) startDate", {
                startDate(ds) <- "1985-11-05"
                expect_identical(startDate(ds), "1985-11-05")
                expect_identical(startDate(refresh(ds)), "1985-11-05")
                startDate(ds) <- NULL
                expect_null(startDate(ds))
                expect_null(startDate(refresh(ds)))
            })
            test_that("Can set (and unset) endDate", {
                endDate(ds) <- "1985-11-05"
                expect_identical(endDate(ds), "1985-11-05")
                expect_identical(endDate(refresh(ds)), "1985-11-05")
                endDate(ds) <- NULL
                expect_null(endDate(ds))
                expect_null(endDate(refresh(ds)))
            })

            test_that("Can publish/unpublish a dataset", {
                expect_true(is.published(ds))
                expect_false(is.draft(ds))
                is.draft(ds) <- TRUE
                expect_false(is.published(ds))
                expect_true(is.draft(ds))
                ds <- refresh(ds)
                expect_false(is.published(ds))
                expect_true(is.draft(ds))
                is.published(ds) <- TRUE
                expect_true(is.published(ds))
                expect_false(is.draft(ds))
            })

            test_that("Can archive/unarchive", {
                expect_false(is.archived(ds))
                is.archived(ds) <- TRUE
                expect_true(is.archived(ds))
                ds <- refresh(ds)
                expect_true(is.archived(ds))
                is.archived(ds) <- FALSE
                expect_false(is.archived(ds))
            })

            test_that("Sending invalid dataset metadata errors usefully", {
                expect_error(endDate(ds) <- list(foo=4),
                    "must be a string")
                expect_error(name(ds) <- 3.14,
                    'Names must be of class "character"')
                expect_error(startDate(ds) <- 1985,
                    "must be a string")
                expect_error(name(ds) <- NULL,
                    'Names must be of class "character"')
                skip("Improve server-side validation")
                expect_error(startDate(ds) <- "a string",
                    "Useful error message here")
            })

            test_that("A variable named/aliased 'name' can be accessed", {
                ds$name <- 1
                expect_true("name" %in% aliases(variables(ds)))
                expect_true("name" %in% names(ds))
                expect_true(is.Numeric(ds$name))
            })
        })

        with(test.dataset(df), {
            test_that("dataset dim", {
                expect_identical(dim(ds), dim(df))
                expect_identical(nrow(ds), nrow(df))
                expect_identical(ncol(ds), ncol(df))
            })

            test_that("Dataset [[<-", {
                v1 <- ds$v1
                name(v1) <- "Variable One"
                ds$v1 <- v1
                expect_identical(names(variables(ds))[1], "Variable One")
                expect_error(ds$v2 <- v1,
                    "Cannot overwrite one Variable")
            })
        })

        with(test.dataset(mrdf), {
            cast.these <- grep("mr_", names(ds))
            test_that("Dataset [<-", {
                expect_true(all(vapply(variables(ds)[cast.these],
                    function (x) x$type == "numeric", logical(1))))
                expect_true(all(vapply(ds[cast.these],
                    function (x) is.Numeric(x), logical(1))))
                ds[cast.these] <- lapply(ds[cast.these],
                    castVariable, "categorical")
                expect_true(all(vapply(variables(ds)[cast.these],
                    function (x) x$type == "categorical", logical(1))))
                expect_true(all(vapply(ds[cast.these],
                    function (x) is.Categorical(x), logical(1))))
            })
            test_that("Dataset [[<- on new array variable", {
                try(ds$arrayVar <- makeArray(ds[cast.these],
                    name="Array variable"))
                expect_true(is.CA(ds$arrayVar))
                expect_identical(name(ds$arrayVar), "Array variable")
            })
        })

        test_that("Dataset deleting is safe", {
            with(test.dataset(df), {
                expect_error(delete(ds, confirm=TRUE),
                    "Must confirm deleting dataset")
                expect_error(delete(ds, confirm=FALSE),
                    NA)
            })
        })

        test_that("Can give consent to delete", {
            with(test.dataset(df), {
                with(consent(), {
                    expect_error(delete(ds, confirm=TRUE),
                        NA)
                })
            })
        })
    })
}
