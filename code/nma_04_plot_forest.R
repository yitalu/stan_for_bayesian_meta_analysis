library(forestploter)

dim(effect_true)


percentile_intervals <- t(apply(effect_true[, 1:6], 2, quantile, probs = c(0.5, 0.025, 0.975)))

percentile_intervals_effect_true <- quantile(effect_true, probs = c(0.5, 0.025, 0.975))

treatments
treatments <- c(
    "Care As Usual", "Group", "Guided Self-Help", "Individual", "Telephone", "Unguided Self-Help", "Waitlist Control"
)

forest_tab <- data.frame(
    "Compared with Care As Usual" = treatments[-1],
    Estimate = percentile_intervals[, 1], 
    Lower = percentile_intervals[, 2], 
    Upper = percentile_intervals[, 3], 
    check.names = FALSE
)



# forest_tab$Estimate <- as.numeric(forest_tab$Estimate)
# forest_tab$Lower <- as.numeric(forest_tab$Lower)
# forest_tab$Upper <- as.numeric(forest_tab$Upper)

# forest_tab$SE <- (forest_tab$Upper - forest_tab$Estimate) / 1.96

forest_tab$` ` <- paste(rep(" ", 20), collapse = " ")

forest_tab$`Effect (95% Cred. Interval)` <- sprintf("%.2f (%.2f to %.2f)", forest_tab$Estimate, forest_tab$Lower, forest_tab$Upper)


head(forest_tab)

my_theme <- forest_theme(
  summary_fill = "#4575b4",
  summary_col = "#4575b4",
)

forest_plot <- forest(
  forest_tab[, c(1, 5:6)],
  est = forest_tab$Estimate,
  lower = forest_tab$Lower,
  upper = forest_tab$Upper,
#   sizes = weights,
#   is_summary = c(rep(FALSE, nrow(forest_tab) - 2), TRUE, TRUE),
  ci_column = 2,
  ref_line = 0,
  arrow_lab = c("Treatment Better", "Placebo Better"),
  xlim = c(-1.5, 1),
  ticks_at = c(-1, 0, 1),
  theme = my_theme
)


png(filename = "./figures/forest_plot_nma.png", width = 2400, height = 1200, res = 300)
plot(forest_plot)
dev.off()
