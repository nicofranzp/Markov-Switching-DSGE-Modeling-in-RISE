# Model Specification

RISE models are specified in .rs files using a flexible syntax for regime-switching DSGE models.

## Key Concepts
- Regimes and switching
- Parameters and priors
- Model equations

## Example
```rs
#parameters
beta, sigma, rho
#regimes
regime1, regime2
#model
x = beta * x(-1) + epsilon;
```

See the RISE examples folder for more templates.