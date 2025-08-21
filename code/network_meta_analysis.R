library(dmetar)
library(rstan)

d <- read.csv("./data/therapy_formats.csv")

colnames(d)
head(d)
View(d)

n_studies <- length(unique(d$author)) # 182
n_pairs <- nrow(d) # 184

repeats <- unique(d$author[duplicated(d$author)]) # "Breiman, 2001"
which(d$author %in% repeats) # 8 16 184

# index study
authors <- unique(d$author)
d$study_id <- match(d$author, authors)


treatments <- unique(c(d$treat1, d$treat2)) # "ind" "grp" "gsh" "tel" "ush" "wlc" "cau"
n_treatments <- length(treatments) # 7
n_possible_pairs <- n_treatments * (n_treatments - 1) / 2 # 21

# reorder treatments
treatments <- c("cau", "grp", "gsh", "ind", "tel", "ush", "wlc")
d$treatment_id <- match(d$treat1, treatments)
d$baseline_id <- match(d$treat2, treatments)


# Data list for Stan
data_list <- list(
  n_studies = n_studies,
  n_pairs = n_pairs,
  n_treatments = n_treatments,
  effect_observed = d$TE,
  std_err = d$seTE,
  treatment = d$treatment_id, 
  baseline = d$baseline_id, 
  study = d$study_id
)

# Fit model
fit_nma_re <- stan(
  file = "code/network_meta_analysis_backup.stan", 
  data = data_list, 
  chains = 4, 
  cores = 4, 
  iter = 8000
)

summary(fit_nma_re)
# Print summary for theta and tau
print(fit_nma_re, pars = c("effect_true", "tau"))

png(filename = "./figures/true_effects.png", width = 2000, height = 3600, res = 300)
stan_plot(fit_nma_re, pars = c("effect_true", "tau"))
dev.off()

png(filename = "./figures/trace_plot.png", width = 3600, height = 2000, res = 300)
stan_trace(fit_nma_re, pars = c("effect_true", "tau"))
dev.off()

stan_dens(fit_nma_re, pars = c("effect_true", "tau"))
stan_hist(fit_nma_re, pars = c("effect_true", "tau"))

# Extract posterior mean for theta and convert to 7 x 7 matrix
effect_true_summary <- summary(fit_nma_re, pars = "effect_true")$summary
effect_true_mean <- effect_true_summary[, "mean"]
as.vector(effect_true_mean)


posterior_samples <- rstan::extract(fit_nma_re)
names(posterior_samples)
effect_true <- posterior_samples$effect_true

dim(effect_true)
