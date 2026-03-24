# Replication and Code Documentation

**Markov-Switching DSGE Modeling in RISE**

Junior Maih, Nigar Hashimzade, Oleg Kirsanov, and Tatiana Kirsanova

January 21, 2026

## Purpose of the Repository

This repository accompanies the chapter
**“Markov-Switching DSGE Modeling in RISE”**
Prepared for the *Edward Elgar Handbook of Research Methods and Applications in Empirical Macroeconomics, 2nd ed.*

The chapter demonstrates how the RISE toolbox can be used to specify, solve, estimate, and analyze DSGE models with regime switching.

The files provided here correspond directly to the model specifications, estimation exercises, and empirical illustrations discussed in the chapter.

## Software Requirements

Replication requires the following software:

- MATLAB (R2021a or later recommended)
- RISE toolbox for MATLAB (Maih, 2015 and subsequent versions)
- MATLAB Optimization and Statistics toolboxes

## Repository Structure

The repository is organised as follows.

### Code

The `code/` directory contains the main MATLAB scripts used for estimation, simulation, and analysis:

- [x] `driver_nk.m`: Solution driver for the Baseline linear New Keynesian model.
- [x] `driver_nk_ms.m`: Solution driver for the Markov-switching version of the New Keynesian model.
- [x] `driver_nk_ms_obs.m`: Solution/simulation driver for the model with observation equations.
- [x] `create_priors.m`: Prior specification *function*.
  - FIXME: here the toolbox does not recognize the distribution `igamma1`
  - DONE: replaced with `inv_gamma`
- [x] `driver_nk_ms_est.m`: Estimation driver for the Markov-switching model.
- [x] `driver_mcmc.m`: MCMC driver for posterior simulation using Markov Chain Monte Carlo methods.
  - FIXME: the functions signature was not the same as the RISE version.
  - DONE: Use the signature that made sense
- [x] `nk_nonlinear_ssfile.m`: *function* with the steady-state of the nonlinear model.
- [x] `driver_nk_nonlinear.m`: Solution driver for a nonlinear model.
  - FIXME: a bunch of non-supported options
- [x] `analyze_estimation_results.m`: Processing of estimation results: Summary statistics and figures.
  - FIXME: some functions do not exist
  - DONE: functions were copied from the examples in the RISE dist
- [ ] `analyze_mcmc_diagn.m`: MCMC convergence diagnostics.
- [ ] `analyze_mcmc.m`: Post-processing of MCMC output.
- [ ] `replicate_history.m`: Historical decomposition and replication exercises.
- [ ] `counterfactual.m`: Counterfactual policy experiments.

### Model Files

The `models/` directory contains RISE model specification files:

- `nk.rs`: Baseline linear New Keynesian model.
- `nk_ms.rs`: Markov-switching New Keynesian model.
- `nk_ms_obs.rs`: Model with observable variables.
- `nk_ms_est.rs`: Estimation-ready version of the Markov-switching model.
- `nk_ms_nonlinear.rs`: Nonlinear Markov-switching model.

### Data

The `data/` directory contains the datasets used in estimation:

- `data_US.xlsx`: Main macroeconomic dataset used in estimation.
- `GDPCI_GDPOT.xlsx`: Output gap data.

All data are derived from publicly available sources, which are cited in the chapter.

### Example Output

The `examples/` directory contains example output files from estimation and MCMC runs (in `.mat` format) for reference and verification.

## Reproducibility

Running the driver scripts reproduces the main estimation and simulation results reported in the paper. Due to numerical optimisation routines and stochastic simulation, exact numerical results may vary slightly across machines and software versions.

## Data and Code Availability

All code and processed data required to replicate the paper's results are provided in this repository. No confidential, proprietary, or restricted-access data are used.

## Citation

If you use this code or data, please cite the accompanying chapter.

## License

The code is provided for academic and non-commercial use. Data sources are subject to their original licensing terms.

**Repository URL:** [The code is available at this link](https://github.com/jmaih/Markov-Switching-DSGE-Modeling-in-RISE)
