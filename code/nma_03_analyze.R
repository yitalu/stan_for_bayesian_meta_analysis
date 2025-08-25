
sampler_params <- get_sampler_params(fit_nma_re, inc_warmup = FALSE)
head(sampler_params[[1]])
energy__ <- sampler_params[[1]][, "energy__"]

length()

pairs(fit_nma_re, pars = c(energy__, "effect_true", "tau"))

pairs(fit_nma_re, energy__, effect_true[, 1:6])


params <- names(extract(fit_nma_re))
pairs(fit, pars = c("energy__", params))



summary(fit_nma_re)
# Print summary for theta and tau
print(fit_nma_re, pars = c("effect_true", "tau"))

# png(filename = "./figures/true_effects.png", width = 2000, height = 3600, res = 300)
stan_plot(fit_nma_re, pars = c("effect_true", "tau"))
# dev.off()

# png(filename = "./figures/trace_plot.png", width = 3600, height = 2000, res = 300)
stan_trace(fit_nma_re, pars = c("effect_true", "tau"))
# dev.off()

stan_dens(fit_nma_re, pars = c("effect_true", "tau"))
stan_hist(fit_nma_re, pars = c("effect_true", "tau"))

# Extract posterior mean for true effects
effect_true_summary <- summary(fit_nma_re, pars = "effect_true")$summary
effect_true_mean <- effect_true_summary[, "mean"]
as.vector(effect_true_mean)


posterior_samples <- rstan::extract(fit_nma_re)
names(posterior_samples)
effect_true <- posterior_samples$effect_true
tau <- posterior_samples$tau
heterogeneity <- posterior_samples$heterogeneity
effect_study <- posterior_samples$effect_study

dim(effect_true)
head(effect_true, 1)
dim(posterior_samples$effect_true)



# Calculate indirect effects
effect_network <- array(0, dim = c(7, 7, nrow(effect_true))) # 7 treatments, 7 treatments, n samples
effect_network[1, 2:7, ] <- t(effect_true[, 1:6])

for (i in 2:7) {
    for (j in 1:7) {
        effect_network[i, j, ] <- effect_network[1, j, ] - effect_network[1, i, ]
    }
}

# effect_network[2, 1, ] <- effect_network[1, 1, ] - effect_network[1, 2, ]
# effect_network[2, 2, ] <- effect_network[1, 2, ] - effect_network[1, 2, ]
# effect_network[2, 3, ] <- effect_network[1, 3, ] - effect_network[1, 2, ]
# effect_network[2, 4, ] <- effect_network[1, 4, ] - effect_network[1, 2, ]
# effect_network[2, 5, ] <- effect_network[1, 5, ] - effect_network[1, 2, ]
# effect_network[2, 6, ] <- effect_network[1, 6, ] - effect_network[1, 2, ]
# effect_network[2, 7, ] <- effect_network[1, 7, ] - effect_network[1, 2, ]

# effect_network[3, 1, ] <- effect_network[1, 1, ] - effect_network[1, 3, ]
# effect_network[3, 2, ] <- effect_network[1, 2, ] - effect_network[1, 3, ]
# effect_network[3, 3, ] <- effect_network[1, 3, ] - effect_network[1, 3, ]
# effect_network[3, 4, ] <- effect_network[1, 4, ] - effect_network[1, 3, ]
# effect_network[3, 5, ] <- effect_network[1, 5, ] - effect_network[1, 3, ]
# effect_network[3, 6, ] <- effect_network[1, 6, ] - effect_network[1, 3, ]
# effect_network[3, 7, ] <- effect_network[1, 7, ] - effect_network[1, 3, ]


effect_network_mean <- apply(effect_network, c(1, 2), mean)
effect_network_percentile_025 <- apply(effect_network, c(1, 2), quantile, probs = 0.025)
effect_network_percentile_975 <- apply(effect_network, c(1, 2), quantile, probs = 0.975)
