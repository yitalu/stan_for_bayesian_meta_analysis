# Stan for Meta-Analysis




## Overview
This repository contains my Stan and R code that can be adapted for various Bayesian meta analyses (hierarchical models). Currently, it includes a random effects model and a network meta-analysis. Data for the random effects model is from a study on the effects of green tea on weight loss [1] and collected by [2].




## Random Effects Model
The random effects model in the Stan script [meta_analysis_random_effect.stan](./code/meta_analysis_random_effect.stan) has the following form:

$$\hat{\theta_{k}} \sim Normal(\theta_{k}, \space \sigma )$$

$$\theta_{k} \sim Normal(\mu, \tau)$$

with the priors:

$$\mu \sim Normal(0, 1)$$
$$\tau \sim HalfCauchy(0, 0.5)$$

A forest plot of the effects on weight loss is generated using the [plot_forest.R](./code/plot_forest.R) script, which creates a visual representation of the estimated effects and their credible intervals:

<!-- ![A forest plot of effects on weight loss](./figures/forest_plot_re.png) -->

<img src="./figures/forest_plot_re.png" alt="Forest Plot Random Effects" width="100%">


A posterior predictive distribution of the mean difference, using 20 samples from the posterior distribution, is generated:

<img src="./figures/weight_loss_effect_re.png" alt="Posterior Predictive Plot Random Effects" width="75%">


## References
[1] Jurgens TM, Whelan AM, Killian L, Doucette S, Kirk S, Foy E. Green tea for weight loss and weight maintenance in overweight or obese adults. *Cochrane Database of Systematic Reviews 2012, Issue 12*.
[2] Grant, R., & Di Tanna, G. L. (2025). *Bayesian meta-analysis: a practical introduction*. CRC Press.