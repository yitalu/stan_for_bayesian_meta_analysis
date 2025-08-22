rm(list = ls())

# Load data
d <- read.csv("./data/green_tea_weight_loss.csv")
# colnames(d) 
# head(d)



# Prepare data for Stan
d$mean_diff <- d$mean_tea - d$mean_control
d$var_pooled <- ((d$n_tea - 1) * d$sd_tea ^ 2 + (d$n_control - 1) * d$sd_control ^ 2) / (d$n_tea - 1 + d$n_control - 1)
d$var_md <- (d$n_tea + d$n_control) * d$var_pooled / (d$n_tea * d$n_control)
d$se_md <- sqrt(d$var_md)

data_list <- list(
    n_studies = nrow(d),
    mean_diff = d$mean_diff,
    std_err = d$se_md
)