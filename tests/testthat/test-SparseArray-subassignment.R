.test_SparseArray_subassignment_by_Mindex_and_Lindex <-
    function(a0, Mindex, vals, expected_class)
{
    object0 <- as(a0, expected_class)
    Lindex <- Mindex2Lindex(Mindex, dim(a0))

    a <- `[<-`(a0, Mindex, value=vals)
    object <- `[<-`(object0, Mindex, value=vals)
    check_SparseArray_object(object, expected_class, a)
    object <- `[<-`(object0, Lindex, value=vals)
    check_SparseArray_object(object, expected_class, a)
    object <- `[<-`(object0, as.double(Lindex), value=vals)
    check_SparseArray_object(object, expected_class, a)
    object <- `[<-`(object0, Lindex + 0.5, value=vals)
    check_SparseArray_object(object, expected_class, a)
}

test_that("subassign an SVT_SparseArray object by an Mindex or Lindex", {
    ## Only zeros.
    a0 <- array(0L, c(7, 10, 3),
                dimnames=list(NULL, letters[1:10], LETTERS[1:3]))
    Mindex3 <- rbind(c(7,  9, 3), c(7, 10, 3), c(6, 4, 3), c(2, 4, 3),
                     c(1, 10, 3), c(7, 10, 3), c(1, 1, 3), c(5, 4, 3),
                     c(2,  4, 3))
    vals <- c(11:18, 0L)
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex3, vals,
                                                         "SVT_SparseArray")
    m0 <- a0[ , , 1]  # 2D
    Mindex2 <- Mindex3[ , -3]
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(m0, Mindex2, vals,
                                                         "SVT_SparseMatrix")
    x0 <- as.array(m0[1, ])  # 1D
    Mindex1 <- Mindex2[ , -2, drop=FALSE]
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(x0, Mindex1, vals,
                                                         "SVT_SparseArray")

    ## Add some nonzero elements.
    a0 <- make_3D_double_array()
    Mindex23 <- rbind(cbind(Mindex2, 1L), Mindex3)
    vals2 <- c(vals, vals)
    Mindex0 <- nzwhich(a0, arr.ind=TRUE)
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex23, vals2,
                                                         "SVT_SparseArray")
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex0, 0,
                                                         "SVT_SparseArray")
    m0 <- a0[ , , 1]  # 2D
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(m0, Mindex2, vals,
                                                         "SVT_SparseMatrix")
    x0 <- as.array(m0[1, ])  # 1D
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(x0, Mindex1, vals,
                                                         "SVT_SparseArray")

    ## Integer array.
    a0 <- make_3D_double_array()
    suppressWarnings(storage.mode(a0) <- "integer")
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex23, vals2,
                                                         "SVT_SparseArray")
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex0, 0L,
                                                         "SVT_SparseArray")

    ## Array type changed by subassignment.
    a0 <- make_3D_double_array()
    vals2 <- complex(real=vals2, imaginary=-0.75)
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex23, vals2,
                                                         "SVT_SparseArray")
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex0, -9.99,
                                                         "SVT_SparseArray")

    ## Assign random values to random array locations.
    set.seed(123)
    Mindex <- Lindex2Mindex(sample(length(a0)), dim(a0))
    vals <- sample(0:5, length(a0), replace=TRUE)
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex, vals,
                                                         "SVT_SparseArray")
    Mindex <- Lindex2Mindex(sample(length(a0), 5000, replace=TRUE), dim(a0))
    vals <- sample(-99:99, 5000, replace=TRUE)
    .test_SparseArray_subassignment_by_Mindex_and_Lindex(a0, Mindex, vals,
                                                         "SVT_SparseArray")
})

.test_SparseArray_subassignment_by_Nindex <-
    function(a0, index, vals, expected_class)
{
    object0 <- as(a0, expected_class)

    a <- `[<-`(a0, index, value=vals)
    object <- `[<-`(object0, index, value=vals)
    check_SparseArray_object(object, expected_class, a)
}

test_that(paste("subassign an SVT_SparseArray object by an Nindex",
                "and with a short vector"), {
    set.seed(123)
    a0 <- array(0L, c(180, 400, 50))
    a0[sample(length(a0), 1e6)] <- sample(10L, 1e6, replace=TRUE)
    svt0 <- as(a0, "SVT_SparseArray")

    ## Wipe out all nonzeros:
    a <- `[<-`(a0, , , , value=0L)
    svt <- `[<-`(svt0, , , , value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    expect_null(svt@SVT)

    ## Wipe out all nonzeros in a column:
    a <- `[<-`(a0, , 8, 1, value=0L)
    svt <- `[<-`(svt0, , 8, 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    expect_null(svt@SVT[[1L]][[8L]])
    i0 <- nzwhich(a0[ , 8, 1])
    svt2 <- `[<-`(svt0, i0, 8, 1, value=0L)
    expect_identical(svt2, svt)

    ## Wipe out all nonzeros in a row:
    a <- `[<-`(a0, 17, , 1, value=0L)
    svt <- `[<-`(svt0, 17, , 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    j0 <- nzwhich(a0[17, , 1])
    svt2 <- `[<-`(svt0, 17, j0, 1, value=0L)
    expect_identical(svt2, svt)

    ## Inject zeros at random positions in a column:
    i <- sample(180L, 20L)
    a <- `[<-`(a0, i, 8, 1, value=0L)
    svt <- `[<-`(svt0, i, 8, 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject zeros at random positions in a row:
    j <- sample(400L, 50L)
    a <- `[<-`(a0, 17, j, 1, value=0L)
    svt <- `[<-`(svt0, 17, j, 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject zeros in a random set of rows:
    a <- `[<-`(a0, i, , 1, value=0L)
    svt <- `[<-`(svt0, i, , 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject zeros in a random set of columns:
    a <- `[<-`(a0, , j, 1, value=0L)
    svt <- `[<-`(svt0, , j, 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject zeros at random positions:
    a <- `[<-`(a0, i, j, 1, value=0L)
    svt <- `[<-`(svt0, i, j, 1, value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    a <- `[<-`(a0, i, j, , value=0L)
    svt <- `[<-`(svt0, i, j, , value=0L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject fixed nonzero at random positions in a column:
    a <- `[<-`(a0, i, 8, 1, value=-555L)
    svt <- `[<-`(svt0, i, 8, 1, value=-555L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject fixed nonzero at random positions in a row:
    a <- `[<-`(a0, 17, j, 1, value=-555L)
    svt <- `[<-`(svt0, 17, j, 1, value=-555L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject fixed nonzero val at random positions:
    a <- `[<-`(a0, i, j, 1, value=-555L)
    svt <- `[<-`(svt0, i, j, 1, value=-555L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    a <- `[<-`(a0, i, j, , value=-555L)
    svt <- `[<-`(svt0, i, j, , value=-555L)
    check_SparseArray_object(svt, "SVT_SparseArray", a)

    ## Inject short vector with recycling:
    value <- c(-(101:104), 0L)
    a <- `[<-`(a0, i, j, 1, value=value)
    svt <- `[<-`(svt0, i, j, 1, value=value)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
    a <- `[<-`(a0, i, , , value=value)
    svt <- `[<-`(svt0, i, , , value=value)
    check_SparseArray_object(svt, "SVT_SparseArray", a)
})

if (SparseArray:::SVT_VERSION != 0L) {

test_that("handling of lacunar leaves in SVT_SparseArray subassignment", {

    run_tests <- function(type) {

        check_svt123_leaves <- function(expected_leaf) {
            leaf_nzvals <- expected_leaf[[1L]]
            if (!is.null(leaf_nzvals)) {
                type(leaf_nzvals) <- type
                expected_leaf[[1L]] <- leaf_nzvals
            }
            expect_identical(svt1@SVT, expected_leaf)
            expect_identical(svt2@SVT[[2L]], expected_leaf)
            expect_identical(svt3@SVT[[2L]], expected_leaf)
            expect_identical(svt3@SVT[[4L]], expected_leaf)
            expect_identical(svt3@SVT[[5L]], expected_leaf)
        }

        svt1[2:3] <- -99L
        svt2[6:7] <- -99L
        svt3[2:3, c(2L, 4:5)] <- -99L
          m3[2:3, c(2L, 4:5)] <- -99L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(c(-99L, -99L), c(1L, 2L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[2:3] <- 0L
        svt2[6:7] <- 0L
        svt3[2:3, c(2L, 4:5)] <- 0L
          m3[2:3, c(2L, 4:5)] <- 0L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(NULL)
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1:4] <- 101:104
        svt2[5:8] <- 101:104
        svt3[1:4, c(2L, 4:5)] <- 101:104
          m3[1:4, c(2L, 4:5)] <- 101:104
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(101:104, 0:3))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[2:4] <- 1L
        svt2[6:8] <- 1L
        svt3[2:4, c(2L, 4:5)] <- 1L
          m3[2:4, c(2L, 4:5)] <- 1L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(c(101L, 1L, 1L, 1L), 0:3))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1:2] <- 0L
        svt2[5:6] <- 0L
        svt3[1:2, c(2L, 4:5)] <- 0L
          m3[1:2, c(2L, 4:5)] <- 0L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, 2:3))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1L] <- NA
        svt2[5L] <- NA
        svt3[1L, c(2L, 4:5)] <- NA
          m3[1L, c(2L, 4:5)] <- NA
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(c(NA, 1L, 1L), c(0L, 2L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1L] <- 1L
        svt2[5L] <- 1L
        svt3[1L, c(2L, 4:5)] <- 1L
          m3[1L, c(2L, 4:5)] <- 1L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, c(0L, 2L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[3L] <- 11L
        svt2[7L] <- 11L
        svt3[3L, c(2L, 4:5)] <- 11L
          m3[3L, c(2L, 4:5)] <- 11L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(c(1L, 11L, 1L), c(0L, 2L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[2:3] <- 0L
        svt2[6:7] <- 0L
        svt3[2:3, c(2L, 4:5)] <- 0L
          m3[2:3, c(2L, 4:5)] <- 0L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, c(0L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1:4] <- 1:0
        svt2[5:8] <- 1:0
        svt3[1:4, c(2L, 4:5)] <- 1:0
          m3[1:4, c(2L, 4:5)] <- 1:0
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, c(0L, 2L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[c(1L, 4L)] <- 1L
        svt2[c(5L, 8L)] <- 1L
        svt3[c(1L, 4L), c(2L, 4:5)] <- 1L
          m3[c(1L, 4L), c(2L, 4:5)] <- 1L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, c(0L, 2L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[c(1L, 4:3)] <- c(0L, 1L, 0L)
        svt2[c(5L, 8:7)] <- c(0L, 1L, 0L)
        svt3[c(1L, 4:3), c(2L, 4:5)] <- c(0L, 1L, 0L)
          m3[c(1L, 4:3), c(2L, 4:5)] <- c(0L, 1L, 0L)
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, 3L))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[1:2] <- 2:1
        svt2[5:6] <- 2:1
        svt3[1:2, c(2L, 4:5)] <- 2:1
          m3[1:2, c(2L, 4:5)] <- 2:1
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(list(c(2L, 1L, 1L), c(0L, 1L, 3L)))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)

        svt1[c(3L, 1L)] <- 1L
        svt2[c(7L, 5L)] <- 1L
        svt3[c(3L, 1L), c(2L, 4:5)] <- 1L
          m3[c(3L, 1L), c(2L, 4:5)] <- 1L
        check_SparseArray_object(svt3, "SVT_SparseMatrix", m3)
        check_svt123_leaves(make_lacunar_leaf(type, 0:3))
        expect_identical(as(m3, "SVT_SparseMatrix"), svt3)
    }

    svt1 <- as(array(0L, dim=4L), "SVT_SparseArray")  # 1D
    m3 <- matrix(0L, nrow=4, ncol=5)
    svt2 <- svt3 <- as(m3, "SVT_SparseMatrix")        # 2D
    run_tests("integer")

    type(svt1) <- "double"
    m3[ , 3L] <- 0.1
    svt2 <- svt3 <- as(m3, "SVT_SparseMatrix")
    run_tests("double")

})

}  # ----- end if (SparseArray:::SVT_VERSION != 0L) -----
