context("Cubes with categorical array and multiple response")

if (run.integration.tests) {
    with(test.authentication, {
        cubemrdf <- mrdf
        cubemrdf$v5 <- as.factor(c("A", "A", "B", "B"))
        with(test.dataset(cubemrdf, "mrds"), {
            mrds <- mrdf.setup(mrds, selections="1.0")
            test_that("univariate multiple response cube", {
                kube <- try(crtabs(~ MR, data=mrds))
                expect_true(inherits(kube, "CrunchCube"))
                expect_equivalent(as.array(kube),
                    array(c(2, 1, 1), dim=c(3L),
                        dimnames=list(MR=c("mr_1", "mr_2", "mr_3"))))
            })
            
            test_that("bivariate cube with MR", {
                kube <- try(crtabs(~ MR + v4, data=mrds))
                expect_true(inherits(kube, "CrunchCube"))
                expect_equivalent(as.array(kube),
                    array(c(2, 1, 1, 0, 0, 0), dim=c(3L, 2L),
                        dimnames=list(MR=c("mr_1", "mr_2", "mr_3"),
                        v4=c("B", "C"))))
                
                kube <- try(crtabs(~ v4 + MR, data=mrds))
                expect_true(inherits(kube, "CrunchCube"))
                expect_equivalent(as.array(kube),
                    array(c(2, 0, 1, 0, 1, 0), dim=c(2L, 3L),
                        dimnames=list(v4=c("B", "C"),
                        MR=c("mr_1", "mr_2", "mr_3"))))
                
                kube <- try(crtabs(~ v4 + MR, data=mrds, useNA="ifany"))
                expect_true(inherits(kube, "CrunchCube"))
                expect_equivalent(as.array(kube),
                    array(c(2, 0, 1, 0, 1, 0, 0, 1), dim=c(2L, 4L),
                        dimnames=list(v4=c("B", "C"),
                        MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
            })
            
            test_that("prop.table on univariate MR", {
                c1 <- crtabs(~ MR, data=mrds)
                expect_equivalent(prop.table(c1),
                    array(c(2/3, 1/3, 1/3), dim=c(3L),
                        dimnames=list(MR=c("mr_1", "mr_2", "mr_3"))))
                c2 <- c1
                c2@useNA <- "always"
                expect_equivalent(prop.table(c2),
                    array(c(.5, .25, .25, .25), dim=c(4L),
                        dimnames=list(MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
            })
            
            test_that("prop.table on bivariate with MR", {
                c1 <- crtabs(~ v5 + MR, data=mrds)
                #    MR
                # v5  mr_1 mr_2 mr_3
                #   A    1    0    0
                #   B    1    1    1
                expect_equivalent(as.array(c1),
                    array(c(1, 1, 0, 1, 0, 1), dim=c(2L, 3L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3"))))
                expect_equivalent(margin.table(c1), 3)
                expect_equivalent(prop.table(c1),
                    array(c(1, 1, 0, 1, 0, 1)/3, dim=c(2L, 3L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3"))))
                expect_equivalent(margin.table(c1, 1),
                    as.array(c(2, 1)))
                expect_equivalent(prop.table(c1, margin=1),
                    array(c(.5, 1, 0, 1, 0, 1), dim=c(2L, 3L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3"))))
                expect_equivalent(margin.table(c1, margin=2),
                    as.array(c(2, 1, 1)))
                expect_equivalent(prop.table(c1, margin=2),
                    array(c(.5, .5, 0, 1, 0, 1), dim=c(2L, 3L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3"))))
                c2 <- c1
                c2@useNA <- "ifany"
                #    MR
                # v5  mr_1 mr_2 mr_3 <NA>
                #   A    1    0    0    0
                #   B    1    1    1    1
                expect_equivalent(as.array(c2),
                    array(c(1, 1, 0, 1, 0, 1, 0, 1), dim=c(2L, 4L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
                expect_equivalent(margin.table(c2), 4)
                expect_equivalent(prop.table(c2),
                    array(c(1, 1, 0, 1, 0, 1, 0, 1)/4, dim=c(2L, 4L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
                expect_equivalent(margin.table(c2, 1),
                    as.array(c(2, 2)))
                expect_equivalent(prop.table(c2, margin=1),
                    array(c(.5, .5, 0, .5, 0, .5, 0, .5), dim=c(2L, 4L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
                expect_equivalent(margin.table(c2, 2),
                    as.array(c(2, 1, 1, 1)))
                expect_equivalent(prop.table(c2, margin=2),
                    array(c(.5, .5, 0, 1, 0, 1, 0, 1), dim=c(2L, 4L),
                        dimnames=list(v5=c("A", "B"),
                        MR=c("mr_1", "mr_2", "mr_3", "<NA>"))))
            })
            
            mrds$MR <- undichotomize(mrds$MR)
            alias(mrds$MR) <- "CA"
            name(mrds$CA) <- "Cat array"
            test_that("'univariate' categorical array cube", {
                kube <- try(crtabs(~ CA, data=mrds, useNA="ifany"))
                expect_true(inherits(kube, "CrunchCube"))
                expect_equivalent(as.array(kube), 
                    array(c(1, 2, 2, 2, 1, 1, 1, 1, 1),
                    dim=c(3L, 3L),
                    dimnames=list(CA=c("mr_1", "mr_2", "mr_3"),
                        CA=c("0.0", "1.0", "<NA>"))))
            })
            
            test_that("prop.table on univariate CA", {
                
            })
        })
    })
}