source("./code/ma_01_load_data.R")
library(rstan)



# Fit random effects model in Stan
fit_re <- stan(
    file = "code/ma_02_fit_model.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)