# Getting Started

## Installation

1. Download or clone the RISE toolbox from GitHub.
2. Add the toolbox path to MATLAB.
3. Run `rise_startup()` in MATLAB.

## Quick Example

```matlab
m = dsge('my_model.rs');
m = set(m, 'parameters', param_struct);
m = solve(m);
results = estimate(m, 'data', data_struct);
```

See [Examples](examples.md) for more.