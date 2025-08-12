
d <- read.csv("./data/therapy_formats.csv")
colnames(d)

d <- read.csv("./data/parkinsons.csv")
head(d)
View(d)


make_var_cov_matrix <- function(study_id, treatment_id, std_err, variance){
    
    n_studies <- max(study_id)
    n_pair <- length(study_id)
    
    varcov_matrix <- matrix(0, nrow = n_pair, ncol = n_pair)

    for (i in 1:n_studies) {
        ndx <- study_id == i
        if (sum(ndx) > 1) {
            varcov_matrix[ndx, ndx] <- variance[ndx][1]
        }
    }

    diag(varcov_matrix) <- std_err^2
    print(varcov_matrix)
}


varcov <- make_var_cov_matrix(
    study_id = d$s,
    treatment_id = d$t,
    std_err = d$se,
    variance = d$v
)


data_list <- list(
    n_studies = nrow(d), 
    n_treatments = max(d$t), 
    treatment = d$t, 
    control = d$b, 
    effect = d$y, 
    varcov = varcov, 
    meanA = -0.73, 
    sdA = 1/sqrt(21)
)


fit_nma <- stan(
    file = "code/network_meta_analysis.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)