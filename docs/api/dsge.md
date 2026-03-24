# DSGE Class API Reference

The `dsge` class is the main interface for regime-switching DSGE models in RISE.

## Constructor
```matlab
m = dsge('model_file.rs');
```

## Key Methods
| Method | Description |
|--------|-------------|
| `estimate` | Estimate model parameters (MLE/Bayesian) |
| `filter` | State estimation (Kalman/particle) |
| `forecast` | Forecast future values |
| `simulate` | Simulate the model |
| `solve` | Solve for model solution |
| `set` | Set options or parameters |
| `get` | Get properties or results |
| `counterfactual` | Compute counterfactual scenarios |
| `historical_decomposition` | Historical shock decomposition |
| `variance_decomposition` | Variance decomposition |
| `irf` | Impulse response functions |
| `print_solution` | Print model solution |
| `print_estimation_results` | Print estimation results |
| `log_posterior_kernel` | Evaluate log-posterior |
| `log_prior_density` | Evaluate log-prior |
| `log_marginal_data_density` | Marginal data density |
| `prior_plots` | Plot prior distributions |
| `simulate_nonlinear` | Nonlinear simulation |
| `stoch_simul` | Stochastic simulation |
| `theoretical_autocorrelations` | Theoretical autocorrelations |
| `theoretical_autocovariances` | Theoretical autocovariances |

See also: [SVAR API](svar.md), [TS API](ts.md)
