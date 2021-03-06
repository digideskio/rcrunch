context("Sharing")

me <- "fake.user@example.com"

with_mock_HTTP({
    ds <- loadDataset("test ds")
    ds2 <- loadDataset("ECON.sav")
    test_that("Dataset has permissions catalog", {
        expect_is(permissions(ds), "PermissionCatalog")
        expect_identical(urls(permissions(ds)),
            c("/api/users/user1.json", "/api/users/user2.json"))
        expect_identical(emails(permissions(ds)),
            c("fake.user@example.com", "nobody@crunch.io"))
    })
    test_that("Editing attributes", {
        expect_identical(is.editor(permissions(ds)),
            structure(c(TRUE, FALSE),
            .Names=c("fake.user@example.com", "nobody@crunch.io")))
        expect_true(is.editor(permissions(ds)[me]))
        expect_true(is.editor(permissions(ds)[[me]]))
        expect_false(is.editor(permissions(ds)["nobody@crunch.io"]))
    })
    test_that("Permissions with dataset shared with team", {
        expect_identical(emails(permissions(ds2)),
            c(NA_character_, "dos@example.io", "tres@example.com"))
        expect_identical(is.editor(permissions(ds2)),
            structure(c(TRUE, TRUE, TRUE),
            .Names=c(NA_character_, "dos@example.io", "tres@example.com")))
    })

    with(temp.options(crunch.api="https://fake.crunch.io/api/v2/"), {
        test_that("Share payload shape", {
            expect_identical(passwordSetURLTemplate(),
                "https://fake.crunch.io/password/change/${token}/")
            expect_error(share(ds, "lauren.ipsum@crunch.io", edit=TRUE,
                notify=FALSE),
                paste0('PATCH /api/datasets/dataset1/permissions.json ',
                '{"lauren.ipsum@crunch.io":{"dataset_permissions":',
                '{"edit":true,"view":true}},"send_notification":false}'),
                fixed=TRUE)
            expect_error(share(ds, "lauren.ipsum@crunch.io", edit=TRUE,
                notify=TRUE),
                paste0('PATCH /api/datasets/dataset1/permissions.json ',
                '{"lauren.ipsum@crunch.io":{"dataset_permissions":',
                '{"edit":true,"view":true}},"send_notification":true,',
                '"url_base":"https://fake.crunch.io/password/change/${token}/",',
                '"dataset_url":"https://fake.crunch.io/dataset/511a7c49778030653aab5963"}'),
                fixed=TRUE)
        })
    })
})

me <- getOption("crunch.email")

if (run.integration.tests) {
    with_test_authentication({
        with(test.dataset(df), {
            test_that("PermissionsCatalog from real dataset", {
                expect_is(permissions(ds), "PermissionCatalog")
                expect_identical(urls(permissions(ds)),
                    userURL())
                expect_identical(emails(permissions(ds)),
                    me)
                expect_identical(is.editor(permissions(ds)),
                    structure(TRUE, .Names=me))
            })

            test_that("share and unshare methods for dataset", {
                ds <- share(ds, "foo@crunch.io", notify=FALSE)
                expect_true(setequal(emails(permissions(ds)),
                    c(me, "foo@crunch.io")))
                ds <- unshare(ds, "foo@crunch.io")
                expect_identical(emails(permissions(ds)), me)
            })

            test_that("re-sharing doesn't change the state", {
                try(share(ds, "foo@crunch.io", notify=FALSE))
                expect_true(setequal(emails(permissions(ds)),
                    c(me, "foo@crunch.io")))
            })

            others <- c("foo@crunch.io", "a@crunch.io", "b@crunch.io")
            test_that("can share dataset with multiple at same time", {
                try(share(ds, c("a@crunch.io", "b@crunch.io"), notify=FALSE))
                expect_true(setequal(emails(permissions(ds)),
                    c(me, others)))
                expect_true(is.editor(permissions(ds)[[me]]))
                for (user in others) {
                    expect_false(is.editor(permissions(ds)[[user]]), info=user)
                }
            })

            test_that("Cannot unmake myself editor without passing", {
                try(share(ds, me, notify=FALSE, edit=TRUE))
                expect_true(is.editor(permissions(ds)[[me]]))
                expect_error(share(ds, me, notify=FALSE, edit=FALSE),
                    "Cannot remove editor from the dataset without specifying another")
            })

            test_that("Can make multiple people editors", {
                skip("TODO invite a and b as advanced users")
                ds <- share(ds, c("a@crunch.io", "b@crunch.io"),
                    notify=FALSE, edit=TRUE)
                expect_true(is.editor(permissions(ds)[["a@crunch.io"]]))
                expect_true(is.editor(permissions(ds)[["b@crunch.io"]]))
            })
        })
    })
}
