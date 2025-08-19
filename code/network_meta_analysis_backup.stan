data {
    int<lower=0> n_studies; // number of studies
    int<lower=0> n_treatments; // number of treatments
    int<lower=0> n_pairs; // number of comparisons
    array[n_pairs] int baseline; // baseline in each comparison
    array[n_pairs] int treatment; // treatment in each comparison
    array[n_pairs] int id_study; // study ID for each comparison
    array[n_pairs] real mean_diff; // mean difference for each comparison
    array[n_pairs] real std_err; // standard error for each comparison
    array[n_pairs] real variance_baseline; // variance for baseline treatment
}

parameters {
    array[n_treatments - 1] real mu; // true effect size
    real<lower=0> tau; // between-study standard deviation
    array[n_treatments - 1] real theta; // true effect size for each comparison
}

transformed parameters {
    array[n_treatments-1, n_treatments-1] real varcov_sampling; // sampling variance-covariance matrix
    array[n_treatments-1, n_treatments-1] real varcov_heterogeneity; // heterogeneity variance-covariance matrix

    for (i in 1:(n_treatments-1)) {
        for (j in 1:(n_treatments-1)) {
            if (i == j) {
                varcov_sampling[i, j] = std_err[i] * std_err[i];
            } else {
                varcov_sampling[i, j] = variance_baseline;
            }
        }
    }

    for (i in 1:(n_treatments-1)) {
        for (j in 1:(n_treatments-1)) {
            if (i == j) {
                varcov_heterogeneity[i, j] = tau;
            } else {
                varcov_heterogeneity[i, j] = tau / 2;
            }
        }
    }
}

model {
    mean_diff ~ multi_normal(theta, covariance_matrix);
    theta ~ normal(mu, tau);
}