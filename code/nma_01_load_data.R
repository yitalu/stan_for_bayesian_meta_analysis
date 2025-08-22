rm(list = ls())
# library(dmetar)



# Load data
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