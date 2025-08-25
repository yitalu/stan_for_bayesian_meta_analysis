treatments
treatments <- c(
    "Care As Usual", "Group", "Guided Self-Help", "Individual", "Telephone", "Unguided Self-Help", "Waitlist"
)



table_network_effects <- data.frame(
  "Baseline \\ Treatment" = treatments,

  "Care As Usual" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 1], effect_network_percentile_025[1:7, 1], effect_network_percentile_975[1:7, 1]), 

  "Group" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 2], effect_network_percentile_025[1:7, 2], effect_network_percentile_975[1:7, 2]), 

  "Guided Self-Help" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 3], effect_network_percentile_025[1:7, 3], effect_network_percentile_975[1:7, 3]), 

  "Individual" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 4], effect_network_percentile_025[1:7, 4], effect_network_percentile_975[1:7, 4]), 

  "Telephone" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 5], effect_network_percentile_025[1:7, 5], effect_network_percentile_975[1:7, 5]), 

  "Unguided Self-Help" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 6], effect_network_percentile_025[1:7, 6], effect_network_percentile_975[1:7, 6]), 

  "Waitlist" = sprintf("%.2f (%.2f to %.2f)", effect_network_mean[1:7, 7], effect_network_percentile_025[1:7, 7], effect_network_percentile_975[1:7, 7]), 

  check.names = FALSE
)


# Output effect_network_mean as a table figure with column titles
library(gridExtra)
library(grid)

png(filename = "./figures/table_network_effects.png", width = 4000, height = 1000, res = 300)
gridExtra::grid.table(table_network_effects, rows = NULL)
dev.off()







# # Alternative way to create a table figure with column titles
# col_titles <- c("Baseline \\ Treatment", "Care As Usual", "Group", "Guided Self-Help", "Individual", "Telephone", "Unguided Self-Help", "Waitlist Control")

# table_plot <- tableGrob(table_network_effects, cols = col_titles, theme = ttheme_minimal(), rows = NULL)

# png(filename = "./figures/table_network_effects_test.png", width = 4000, height = 1000, res = 300)
# grid.draw(table_plot)
# dev.off()
