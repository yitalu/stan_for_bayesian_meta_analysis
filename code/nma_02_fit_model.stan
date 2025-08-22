data {
    int<lower=0> n_studies; // number of studies
    int<lower=0> n_pairs; // number of pairwise comparisons
    int<lower=0> n_treatments; // number of treatments in all studies

    array[n_pairs] real effect_observed; // treatment effect for each comparison
    array[n_pairs] real std_err; // standard error for each comparison
    array[n_pairs] int<lower=0> treatment; // treatment index in each comparison
    array[n_pairs] int<lower=0> baseline; // baseline index in each comparison
    array[n_pairs] int<lower=0> study; // study index for each comparison
}

parameters {
    array[n_treatments-1] real effect_true; // true effect size relative to baseline; theta_bk, b = 1
    real<lower=0> tau; // between-study standard deviation
    array[n_studies, n_treatments-1] real heterogeneity;
}

transformed parameters {
    array[n_studies, n_treatments] real effect_study; // study-specific (underlying) effect size; theta_ibik, bi: study-specific baseline, equal or not equal to b
    for (s in 1:n_studies) {
        effect_study[s, 1] = 0;
        for (t in 2:n_treatments) {
            effect_study[s, t] = effect_true[t-1] + heterogeneity[s, t-1];
        }
    }
}

model {
    
    for (s in 1:n_studies) {
        for (t in 2:n_treatments) {
            heterogeneity[s, t-1] ~ normal(0, tau);
        }
    }
    
    for (p in 1:n_pairs) {
        effect_observed[p] ~ normal(
            effect_study[study[p], treatment[p]] - effect_study[study[p], baseline[p]], 
            std_err[p]
        );
    }

    // priors
    effect_true ~ normal(0, 10);
    tau ~ cauchy(0, 0.5); // in fact Half Cauchy; tau is defined as real<lower=0> in the parameters block

}
