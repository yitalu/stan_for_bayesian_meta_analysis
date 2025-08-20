data {
    int<lower=0> n_studies; // number of studies>
    int<lower=0> n_studies_2arms; // number of 2-arm studies
    int<lower=0> n_studies_3arms; // number of 3-arm studies
    int<lower=0> n_treatments; // number of treatments in all studies
    int<lower=0> n_pairs; // number of comparisons

    array[n_studies_2arms] real mean_diff_2arms; // mean difference for each comparison
    array[n_studies_2arms] real std_err_2arms; // standard error for each comparison
    array[n_studies_2arms, 2] int id_treatments_2arms; // treatment ids for each 3-arm study

    // array[n_studies_3arms, 3] real mean_diff_3arms; // mean difference for each comparison
    // array[n_studies_3arms, 3] real std_err_3arms; // standard error for each comparison
    // array[n_studies_3arms, 3] int id_treatments_3arms; // treatment ids for each 3-arm study

    // array[n_studies] int<lower=1> id_study;
}

parameters {
    matrix[n_treatments, n_treatments] theta; // true effect size for each pair/comparison
    real<lower=0> tau; // between-study standard deviation
    // array[n_pairs] real theta_study; // true effect size for each study
    array[n_studies_2arms, 1] real theta_studies_2arms; // true effect size for each 2-arm study
    // array[n_studies_3arms, 3] real theta_studies_3arms; // true effect size for each 3-arm study
}

model {
    
    for (s in 1:n_studies_2arms) {
        
        mean_diff_2arms[s] ~ normal(theta_studies_2arms[s, 1], std_err_2arms[s]);

        theta_studies_2arms[s, 1] ~ normal(theta[id_treatments_2arms[s, 1], id_treatments_2arms[s, 2]], tau);

    }

    // for (s in 1:n_studies_3arms) {
    //     mean_diff_3arms[s] ~ multi_normal(theta_studies_3arms[s, 1:3], std_err[s, 1:3]);
    //     theta_studies_3arms[s, 1:3] ~ multi_normal(theta[]);
    // }

    // Priors
    to_vector(theta) ~ normal(0, 1);
    tau ~ cauchy(0, 0.5);

}

// model {
//     // Likelihood for 2-arm studies
//     for (p in 1:n_pairs) {
        
//         if (n_arms[p] == 2) {
//             mean_diff[p] ~ normal(theta_study[ study[p], treatment[p] ], std_err[p])
//             theta_study[ study[p], treatment[p] ] ~ normal( theta[ baseline[p], treatment[p] ] , tau)
//         }

//         if (n_arms[p] == 3) {
//             mean_diff[p]
//         }
//     }
        
// }
