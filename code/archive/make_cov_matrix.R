
d <- read.csv("./data/parkinsons.csv")

id_study <- d$s

make_covmat <- function (id_study, id_treatment, std_err, variance) {
    n_comparisons <- length(id_study)
    n_studies <- max(id_study)

    covmat <- matrix(0, nrow = n_comparisons, ncol = n_comparisons)

    for (i in 1:n_studies) {
        ndx <- id_study == i
        if (sum(ndx) > 1) {
            covmat[ndx, ndx] <- variance[ndx][1]
        }
    }

    diag(covmat) <- std_err^2
    print(covmat)
}

make_covmat(id_study = d$s, id_treatment = d$t, std_err = d$se, variance = d$v)


0.668^2
0.695^2
