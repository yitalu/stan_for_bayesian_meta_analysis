# Forest Plot
library(grid)
library(forestploter)


percentile_intervals <- t(apply(theta[, 1:12], 2, quantile, probs = c(0.5, 0.025, 0.975)))
percentile_intervals_mu <- quantile(mu, probs = c(0.5, 0.025, 0.975))
percentile_intervals_tau <- quantile(tau, probs = c(0.5, 0.025, 0.975))

forest_tab <- data.frame(
  Study = d$Study,
  Treatment = d$mean_tea,
  Control = d$mean_control,
  Estimate = percentile_intervals[, 1],
  Lower = percentile_intervals[, 2],
  Upper = percentile_intervals[, 3]
)

row_summary <- c("Summary", " ", " ", as.numeric(percentile_intervals_mu))
row_heterogeneity <- c("Heterogeneity", " ", " ", as.numeric(percentile_intervals_tau))

forest_tab <- rbind(forest_tab, row_summary, row_heterogeneity)

# forest_tab$SE <- d$se_md
forest_tab$Estimate <- as.numeric(forest_tab$Estimate)
forest_tab$Lower <- as.numeric(forest_tab$Lower)
forest_tab$Upper <- as.numeric(forest_tab$Upper)

forest_tab$SE <- (forest_tab$Upper - forest_tab$Estimate) / 1.96
forest_tab$` ` <- paste(rep(" ", 20), collapse = " ")

forest_tab$`Effect (95% Credible Interval)` <- sprintf("%.2f (%.2f to %.2f)", forest_tab$Estimate, forest_tab$Lower, forest_tab$Upper)



head(forest_tab)

my_theme <- forest_theme(
  summary_fill = "#4575b4",
  summary_col = "#4575b4",
)

weights <- c(0.002 / (forest_tab$SE[1:12])^2, forest_tab$SE[13] * 2, forest_tab$SE[14] * 2)


forest_plot <- forest(
  forest_tab[, c(1:3, 8:9)],
  est = forest_tab$Estimate,
  lower = forest_tab$Lower,
  upper = forest_tab$Upper,
  sizes = weights,
  is_summary = c(rep(FALSE, nrow(forest_tab) - 2), TRUE, TRUE),
  ci_column = 4,
  ref_line = 0,
  arrow_lab = c("Treatment Better", "Placebo Better"),
  xlim = c(-2, 1),
  ticks_at = c(-2, -1, 0, 1),
  theme = my_theme
)

png(filename = "./figures/forest_plot_ma_re.png", width = 3000, height = 1400, res = 300)
plot(forest_plot)
dev.off()


range(forest_tab$SE)

forest_tab$SE