# Stan for Bayesian Meta-Analysis




## Overview

This repository contains Stan and R code for performing Bayesian meta-analyses (hierarchical models). Meta-analysis is a statistical method that combines results from multiple studies to estimate an overall effect. In a **random effects meta-analysis**, we assume that the true effect size may vary between studies due to differences in study populations or methods; this model accounts for such variability. A **network meta-analysis** extends this approach to compare a network of multiple treatments across studies, allowing for both direct and indirect comparisons between treatments.

Currently, the repository includes code for a random effects model and a random effects network meta-analysis (indirect treatment comparisons). The random effects model uses data from a study on the effects of green tea on weight loss [^1], collected by [^2]. The network meta-analysis uses data on the effectiveness of different cognitive behavioral therapies for depression, as studied by [^3]. The data is formatted in the R package *dmetar* by [^4].




<br>

## Random Effects Model
The random effects model in the Stan script [ma_02_fit_model.stan](./code/ma_02_fit_model.stan) has the following form:

$$\hat{\theta_{k}} \sim Normal(\theta_{k}, \space \sigma^2 )$$

$$\theta_{k} \sim Normal(\mu, \tau^2)$$

with the priors:

$$\mu \sim Normal(0, 1)$$
$$\tau \sim HalfCauchy(0, 0.5)$$

A forest plot of the effects on weight loss is generated using the [ma_04_plot_forest.R](./code/ma_04_plot_forest.R) script, which creates a visual representation of the estimated effects and their credible intervals:

<!-- ![A forest plot of effects on weight loss](./figures/forest_plot_re.png) -->

<p align="center">
<img src="./figures/forest_plot_ma_re.png" alt="Forest Plot Random Effects" width="75%">
</p>


A posterior predictive distribution of the mean difference, using 20 samples from the posterior distribution, is generated:

<p align="center">
<img src="./figures/weight_loss_effect_re.png" alt="Posterior Predictive Plot Random Effects" width="75%">
</p>




<br>

## Network Meta-Analysis
The scripts for the network meta-analysis are in [nma_02_fit_model.R](./code/nma_02_fit_model.R) and [nma_02_fit_model.stan](./code/nma_02_fit_model.stan). The model we estimate is:

$${\hat \theta_{i, \space b_{i} k}} \sim Normal(\theta_{i, \space b_{i} k}, \space \sigma_{i, \space b_{i} k}^2 )$$

<br>

$$
\theta_{i, \space b_{i} k} \sim
\begin{cases}
Normal(\theta_{b_{i} k}, \space \tau^2), & \text{for} \space b_i = b \\
Normal(\theta_{b k} - \theta_{b b_{i}}, \space \tau^2), & \text{for} \space b_i \neq b
\end{cases}
$$

<!-- $$\theta_{i, \space b_{i} k} \sim MVNormal(\theta_{ij}, \space T)$$ -->

<!-- where 

$$
\Sigma_k = 
\begin{bmatrix}
\sigma_{k,11} & 0 & 0 & \cdots & 0 \\
0 & \sigma_{k,22} & 0 & \cdots & 0 \\
0 & 0 & \sigma_{k,33} & \cdots & 0 \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
0 & 0 & 0 & \cdots & \sigma_{k,nn}
\end{bmatrix},
$$

$$
R = 
\begin{bmatrix}
\rho & 1 & 1 & 1 \\
1 & \rho & 1 & 1 \\
1 & 1 & \rho & 1 \\
1 & 1 & 1 & \rho
\end{bmatrix},
$$

and 

$$
T = 
\begin{bmatrix}
\tau^2 & \tau^2/2 & \tau^2/2 & \tau^2/2 \\
\tau^2/2 & \tau^2 & \tau^2/2 & \tau^2/2 \\
\tau^2/2 & \tau^2/2 & \tau^2 & \tau^2/2 \\
\tau^2/2 & \tau^2/2 & \tau^2/2 & \tau^2
\end{bmatrix}, 
$$ -->

<br>

with the following priors:

$$\theta_{bk} \sim Normal(0, 10^2)$$

$$\tau \sim HalfCauchy(0, 0.5)$$

<br>

Below shows the estimated true effect of each treatment, using Care As Usual as the baseline:

<p align="center">
<img src="./figures/forest_plot_nma.png" alt="Treatment Effects" width="80%">
<p>


<br>

and their trace plots

<p align="center">
<img src="./figures/trace_plot.png" alt="Trace Plot" width="60%">
<p>




<br>
From these estimated true effects, and in fact, their posterior samples, we can obtain effects between any two treatments in the network.

First, the network of comparisons between treatments pooled from all studies is shown:

<p align="center">
<img src="./figures/network.png" alt="Network of Pairwise Comparisons" width="50%">
<p>

and the thickness of the edge represents the count of pairwise comparisons between treatments.

Once we have the posterior samples of the true effects of each treatment, we can compute the mean effect between any two treatments, along with their credible intervals. The table below shows the mean effects between all pairs of treatments:
<p align="center">
<img src="./figures/table_network_effects.png" alt="Table of Network Effects" width="100%">
<p>

Further analyses will be added soon.


<br>

## References
[^1]: Jurgens TM, Whelan AM, Killian L, Doucette S, Kirk S, Foy E. Green tea for weight loss and weight maintenance in overweight or obese adults. *Cochrane Database of Systematic Reviews 2012, Issue 12*.

[^2]: Grant, R., & Di Tanna, G. L. (2025). *Bayesian meta-analysis: a practical introduction*. CRC Press.

[^3]: Cuijpers, P., Noma, H., Karyotaki, E., Cipriani, A., & Furukawa, T. A. (2019). Effectiveness and acceptability of cognitive behavior therapy delivery formats in adults with depression: a network meta-analysis. *JAMA psychiatry, 76*(7), 700-707.

[^4]: Harrer, M., Cuijpers, P., Furukawa, T.A., & Ebert, D.D. (2021). *Doing Meta-Analysis with R: A Hands-On Guide*. Boca Raton, FL and London: Chapman & Hall/CRC Press. ISBN 978-0-367-61007-4.