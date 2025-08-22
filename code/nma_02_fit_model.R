source("./code/nma_01_load_data.R")
library(rstan)



# Fit model
fit_nma_re <- stan(
  file = "code/nma_02_fit_model.stan", 
  data = data_list, 
  chains = 4, 
  cores = 4, 
  iter = 8000
)