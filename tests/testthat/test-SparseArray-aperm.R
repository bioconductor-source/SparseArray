.test_SparseMatrix_transposition <- function(m0, to)
{
    svt <- as(m0, to)
    tm0 <- t(m0)
    tsvt <- t(svt)
    check_SparseArray_object(tsvt, to, tm0)
    expect_identical(tsvt, as(tm0, to))
}

test_that("SVT_SparseMatrix transposition", {
    ## Only zeros.
    m0 <- matrix(0.0, nrow=7, ncol=10, dimnames=list(NULL, letters[1:10]))
    .test_SparseMatrix_transposition(m0, "SVT_SparseMatrix")

    ## Add some nonzero elements.
    set.seed(789)
    m0[5*(1:14)] <- runif(7, min=-5, max=10)
    m0[2, c(1:4, 7:9)] <- c(NA, NaN, Inf, 3e9, 256, -0.999, -1)
    .test_SparseMatrix_transposition(m0, "SVT_SparseMatrix")

    ## Length zero.
    m <- m0[0 , ]
    .test_SparseMatrix_transposition(m, "SVT_SparseMatrix")
    m <- m0[ , 0]  # this sets the dimnames to list(NULL, NULL)
    dimnames(m) <- NULL  # fix the dimnames
    .test_SparseMatrix_transposition(m, "SVT_SparseMatrix")

    ## Other types.
    m <- m0
    suppressWarnings(storage.mode(m) <- "integer")
    .test_SparseMatrix_transposition(m, "SVT_SparseMatrix")
    m <- m0
    suppressWarnings(storage.mode(m) <- "logical")
    .test_SparseMatrix_transposition(m, "SVT_SparseMatrix")
    m <- m0
    suppressWarnings(storage.mode(m) <- "raw")
    .test_SparseMatrix_transposition(m, "SVT_SparseMatrix")
})

test_that(".aperm_SVT() follows base::aperm() semantic", {
    ## --- with 2 dimensions ---

    m0 <- array(1:120, c(8, 15))
    svt0 <- SparseArray(m0)

    expect_identical(aperm(svt0, 1:2), svt0)

    expected <- aperm(m0)
    current <- aperm(svt0)
    check_SparseArray_object(current, "SVT_SparseMatrix", expected)
    expect_identical(aperm(current, 2:1), svt0)

    ## --- with 3 dimensions ---

    a0 <- array(1:360, c(8, 3, 15))
    a0[ , , c(11,15)] <- 0L
    a0[ , 1:2, 14] <- 0L
    a0[c(1:4, 6), 3, 13] <- 0L
    svt0 <- SparseArray(a0)

    expect_identical(aperm(svt0, 1:3), svt0)

    expected <- aperm(a0)
    current <- aperm(svt0)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, 3:1), svt0)

    perm <- c(1, 3, 2)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, perm), svt0)

    perm <- c(2, 1, 3)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, perm), svt0)

    perm <- c(2, 3, 1)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, perm[perm]), svt0)

    ## --- with 5 dimensions and dimnames ---

    a0 <- array(1:184800, c(55, 8, 10, 3, 14),
                dimnames=list(NULL, NULL, letters[1:10], NULL, LETTERS[1:14]))
    svt0 <- SparseArray(a0)

    expect_identical(aperm(svt0, 1:5), svt0)

    expected <- aperm(a0)
    current <- aperm(svt0)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, 5:1), svt0)

    perm <- c(1, 2, 3, 5, 4)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, perm), svt0)

    perm <- c(1, 2, 4, 3, 5)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, perm), svt0)

    perm <- c(3, 1, 2, 4, 5)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    rperm <- c(2, 3, 1, 4, 5)  # reverse permutation
    expect_identical(aperm(current, rperm), svt0)

    perm <- c(1, 2, 5, 3, 4)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    rperm <- c(1, 2, 4, 5, 3)  # reverse permutation
    expect_identical(aperm(current, rperm), svt0)

    perm <- c(4, 3, 5, 1, 2)
    expected <- aperm(a0, perm)
    current <- aperm(svt0, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    rperm <- c(4, 5, 2, 1, 3)  # reverse permutation
    expect_identical(aperm(current, rperm), svt0)

    expect_identical(aperm(svt0, perm[perm]), aperm(current, perm))

    a <- a0 * 0.1
    svt <- SparseArray(a)

    expect_identical(aperm(svt, 1:5), svt)

    expected <- aperm(a)
    current <- aperm(svt)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    expect_identical(aperm(current, 5:1), svt)

    perm <- c(1, 2, 5, 3, 4)
    expected <- aperm(a, perm)
    current <- aperm(svt, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    rperm <- c(1, 2, 4, 5, 3)  # reverse permutation
    expect_identical(aperm(current, rperm), svt)

    perm <- c(4, 3, 5, 1, 2)
    expected <- aperm(a, perm)
    current <- aperm(svt, perm)
    check_SparseArray_object(current, "SVT_SparseArray", expected)
    rperm <- c(4, 5, 2, 1, 3)  # reverse permutation
    expect_identical(aperm(current, rperm), svt)

    expect_identical(aperm(svt, perm[perm]), aperm(current, perm))
})

test_that(".aperm_SVT() supports S4Arrays::aperm2() extended semantic", {
    a <- array(1:6000, c(1, 40, 1, 50, 3))
    dimnames(a) <- list(NULL,
                        paste0("B", 1:40),
                        NULL,
                        paste0("D", 1:50),
                        paste0("E", 1:3))
    svt <- SparseArray(a)
    perms <- list(2:5,
                  5:2,
                  c(1:2,4:5),
                  c(5,2,1,4),
                  c(NA,NA,5,2,NA,1,4,NA),
                  c(2,4:5),
                  c(4:5,2))
    for (perm in perms) {
        expected <- aperm2(a, perm)
        current <- aperm(svt, perm)
        check_SparseArray_object(current, "SVT_SparseArray", expected)
    }
})

if (SparseArray:::SVT_VERSION != 0L) {

test_that("handling of lacunar leaves in t.SVT_SparseMatrix()", {
    m0 <- matrix(0L, nrow=4, ncol=5)
    m0[2:3 , 2L] <- 99L
    m0[1:2 , 3L] <- m0[c(1L, 4L), 5L] <- 1L

    run_tests <- function() {
        type0 <- type(m0)
        svt0 <- as(m0, "SVT_SparseMatrix")
        m <- t(m0)
        svt <- t(svt0)
        check_SparseArray_object(svt, "SVT_SparseMatrix", m)
        expect_identical(svt@SVT[[1L]], make_lacunar_leaf(type0, c(2L, 4L)))
        expect_identical(svt@SVT[[4L]], make_lacunar_leaf(type0, 4L))
        expect_identical(as(m, "SVT_SparseMatrix"), svt)
        expect_identical(t(svt), svt0)
    }

    run_tests()

    type(m0) <- "double"
    run_tests()

    type(m0) <- "complex"
    run_tests()

    type(m0) <- "raw"
    run_tests()

    type(m0) <- "logical"
    run_tests()
})

test_that("handling of lacunar leaves in .aperm_SVT()", {
    a0 <- array(0L, c(3, 5, 2))
    a0[2:3 , 2L, 1L] <- 99L
    a0[1L, 2L, 1L] <- a0[1:2 , 3L, 1L] <- a0[c(1L, 3L), 5L, 1L] <- 1L
    a0[1L, 2L, 2L] <- a0[2L, 5L, 2L] <- 1L
    a0[1L, 4L, 2L] <- 99L

    run_tests <- function() {
        type0 <- type(a0)
        svt0 <- as(a0, "SVT_SparseArray")

        a <- aperm(a0, c(2:1, 3L))
        svt <- aperm(svt0, c(2:1, 3L))
        check_SparseArray_object(svt, "SVT_SparseArray", a)
        expect_identical(svt@SVT[[1L]][[1L]],
                         make_lacunar_leaf(type0, c(1L, 2L, 4L)))
        expect_identical(svt@SVT[[2L]][[2L]],
                         make_lacunar_leaf(type0, 4L))
        expect_identical(as(a, "SVT_SparseArray"), svt)
        expect_identical(aperm(svt, c(2:1, 3L)), svt0)

        a <- aperm(a0, 3:1)
        svt <- aperm(svt0, 3:1)
        check_SparseArray_object(svt, "SVT_SparseArray", a)
        expect_identical(svt@SVT[[1L]][[2L]],
                         make_lacunar_leaf(type0, c(0L, 1L)))
        expect_identical(as(a, "SVT_SparseArray"), svt)
        expect_identical(aperm(svt, 3:1), svt0)

        a <- aperm(a0, c(2L, 3L, 1L))
        svt <- aperm(svt0, c(2L, 3L, 1L))
        check_SparseArray_object(svt, "SVT_SparseArray", a)
        expect_identical(svt@SVT[[1L]][[1L]],
                         make_lacunar_leaf(type0, c(1L, 2L, 4L)))
        expect_identical(svt@SVT[[2L]][[2L]],
                         make_lacunar_leaf(type0, 4L))
        expect_identical(as(a, "SVT_SparseArray"), svt)
        expect_identical(aperm(svt, c(3L, 1L, 2L)), svt0)
    }

    type(a0) <- "double"
    run_tests()

    type(a0) <- "complex"
    run_tests()

    type(a0) <- "raw"
    run_tests()

    type(a0) <- "logical"
    run_tests()
})

}  # ----- end if (SparseArray:::SVT_VERSION != 0L) -----
