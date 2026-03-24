# Estimation

RISE supports both Maximum Likelihood and Bayesian estimation.

## Maximum Likelihood
```matlab
results = estimate(m, 'data', data_struct, 'optimizer', 'fmincon');
```

## Bayesian Estimation
Specify priors and use:
```matlab
results = estimate(m, 'data', data_struct, 'estim_priors', priors, 'optimizer', 'fmincon');
```

## Priors
- Priors are set using a struct or helper functions.
- Supported distributions: normal, beta, inv_gamma, etc.

## Posterior Analysis
- Use `print_estimation_results(m)` and `prior_plots(m)` for diagnostics.
