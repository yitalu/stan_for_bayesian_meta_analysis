rm(list = ls())
# library(extraDistr)
library(rstan)


# Load the data
d <- read.csv("./data/green_tea_weight_loss.csv")
# colnames(d) 
# head(d)


# Prepare the data for Bayesian meta-analysis
d$mean_diff <- d$mean_tea - d$mean_control

d$var_pooled <- ((d$n_tea - 1) * d$sd_tea ^ 2 + (d$n_control - 1) * d$sd_control ^ 2) / (d$n_tea - 1 + d$n_control - 1)
d$var_md <- (d$n_tea + d$n_control) * d$var_pooled / (d$n_tea * d$n_control)
d$se_md <- sqrt(d$var_md)

data_list <- list(
    n_studies = nrow(d),
    mean_diff = d$mean_diff,
    std_err = d$se_md
)


# Fit the Bayesian meta-analysis model
fit_re <- stan(
    file = "code/meta_analysis_random_effect.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)

summary(fit_re)
print(fit_re, pars = c("mu", "tau", "theta"))
stan_plot(fit_re, pars = c("mu", "tau", "theta"))
stan_trace(fit_re, pars = c("mu", "tau", "theta"))
stan_dens(fit_re, pars = c("mu", "tau", "theta"))
stan_hist(fit_re, pars = c("mu", "tau", "theta"))


# Extract the posterior samples
posterior_samples <- rstan::extract(fit_re)
mu <- posterior_samples$mu
tau <- posterior_samples$tau
theta <- posterior_samples$theta
# head(theta)

theta_pred <- posterior_samples$mean_diff_pred
head(theta_pred)

print(fit_re, pars = c("theta", "mean_diff_pred"))
stan_plot(fit_re, pars = c("theta", "mean_diff_pred"))


traceplot(fit_re, pars = c("mu", "tau", "theta"), inc_warmup = FALSE)
stan_trace(fit_re, pars = c("mu", "tau", "theta"), inc_warmup = FALSE)



plot(mu, type = "l", main = "Posterior of mu", xlab = "Iteration", ylab = "mu")
plot(density(mu))
plot(density(tau))

plot(ecdf(mu))
plot(ecdf(tau))

mu.ecdf <- ecdf(mu)
mu.ecdf(-0.3)




# png(filename = "./figures/weight_loss_effect_re.png", width = 4800, height = 2000, res = 300)
plot(NULL, xlim = c(-3.5, 2.5), ylim = c(0, 1.5), main = "Posterior Predictive Check", xlab = "Mean Difference", ylab = "Density")
for (i in 1:20) {
  lines(density(rnorm(1000, mean = mu[i], sd = tau[i])), col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1.5)
}
lines(density(d$mean_diff), lwd = 4)
grid()
# dev.off()




# Forest Plot
