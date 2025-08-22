

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

# Extract posterior mean for true effects
effect_true_summary <- summary(fit_nma_re, pars = "effect_true")$summary
effect_true_mean <- effect_true_summary[, "mean"]
as.vector(effect_true_mean)


posterior_samples <- rstan::extract(fit_nma_re)
names(posterior_samples)
effect_true <- posterior_samples$effect_true

dim(effect_true)
