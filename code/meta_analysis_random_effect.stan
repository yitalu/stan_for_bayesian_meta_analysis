data {
    int n_studies;
    array[n_studies] real mean_diff;
    array[n_studies] real std_err;
}

parameters {
    real mu; // population effect size
    real<lower=0> tau; // between-study standard deviation
    array[n_studies] real theta; // true effect size for each study
}

model {
    mean_diff ~ normal(theta, std_err);
    theta ~ normal(mu, tau);

    // Priors
    mu ~ normal(0, 1);
    tau ~ cauchy(0, 0.5); // in fact Half Cauchy; tau is defined as real<lower=0> in the parameters block
}

generated quantities {
   array[n_studies] real mean_diff_pred;
   mean_diff_pred = normal_rng(theta, std_err);
}
