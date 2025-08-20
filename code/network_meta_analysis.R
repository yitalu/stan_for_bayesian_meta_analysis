library(dmetar)
library(rstan)

d <- read.csv("./data/therapy_formats.csv")

colnames(d)
head(d)
View(d)

n_studies <- length(unique(d$author))
n_pairs <- nrow(d)

repeats <- unique(d$author[duplicated(d$author)])
which(d$author %in% repeats)

d_2arms <- d[-which(d$author %in% repeats), ]
d_3arms <- d[which(d$author %in% repeats), ]


treatments <- unique(c(d$treat1, d$treat2))
print(treatments)
n_treatments <- length(treatments)
n_possible_pairs <- n_treatments * (n_treatments - 1) / 2

# reorder treatments
treatments <- c("cau", "grp", "gsh", "ind", "tel", "ush", "wlc")
d_2arms$treat1_num <- match(d_2arms$treat1, treatments)
d_2arms$treat2_num <- match(d_2arms$treat2, treatments)

pairs_2arms <- unique(cbind(d_2arms$treat1_num, d_2arms$treat2_num))
pairs_2arms
nrow(pairs_2arms)

# Data list for Stan
data_list <- list(
  n_studies = n_studies,
  n_studies_2arms = length(unique(d_2arms$author)),
  n_studies_3arms = length(unique(d_3arms$author)),
  n_treatments = n_treatments,
  n_pairs = n_pairs,
  mean_diff_2arms = d_2arms$TE,
  std_err_2arms = d_2arms$seTE,
  id_treatments_2arms = cbind(d_2arms$treat1_num, d_2arms$treat2_num)
)




# Fit model
fit_nma_re <- stan(
  file = "code/network_meta_analysis.stan", 
  data = data_list, 
  chains = 4, 
  cores = 4, 
  iter = 2000
)

summary(fit_nma_re)
# Print summary for theta and tau
print(fit_nma_re, pars = c("theta", "tau"))
stan_plot(fit_nma_re, pars = c("theta", "tau"))
stan_trace(fit_nma_re, pars = c("theta", "tau"))
stan_dens(fit_nma_re, pars = c("theta", "tau"))
stan_hist(fit_nma_re, pars = c("theta", "tau"))

# Extract posterior mean for theta and convert to 7 x 7 matrix
theta_summary <- summary(fit_nma_re, pars = "theta")$summary
theta_mean <- theta_summary[, "mean"]
theta_matrix <- matrix(theta_mean, nrow = n_treatments, ncol = n_treatments, byrow = TRUE)
print(theta_matrix)
round(theta_matrix, 2)


posterior_samples <- rstan::extract(fit_nma_re)
names(posterior_samples)
theta <- posterior_samples$theta