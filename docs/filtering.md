
# Filtering & Smoothing

RISE provides filtering and (optionally) smoothing for state estimation.

## Filtering

```matlab
results = filter(m, 'data', data_struct, ...);
```

- Kalman and particle filters supported depending on model type.

### Common Options

| Option                  | Description                                                                                         |
|-------------------------|-----------------------------------------------------------------------------------------------------|
| 'data'                  | The data structure (e.g., a struct of time series) to be used for filtering.                        |
| 'filter_type'           | The type of filter to use: 'kalman' for linear Gaussian models, 'particle' for nonlinear/non-Gaussian models, or other supported types. |
| 'start_date'            | The initial date (string or serial) for filtering. Only data from this date onward is used.         |
| 'end_date'              | The final date (string or serial) for filtering. Only data up to this date is used.                 |
| 'filter_initialization' | Method for initializing the filter state (e.g., 'steady_state', 'known', or a user-supplied vector).|
| 'filter_covariance'     | Covariance matrix or settings for the initial state or shocks.                                      |
| 'filter_shocks'         | How to handle shocks: specify exogenous shock values, or set to [] for default behavior.            |
| 'filter_options'        | Struct with advanced filter settings (e.g., number of particles, resampling method for particle filter, etc.). |
| 'smoother'              | Boolean (true/false). If true, runs a smoother after filtering to estimate full state trajectories.  |
| 'output'                | Specifies what to return: e.g., 'filtered_states', 'likelihood', 'smoothed_states', or a struct with all results. |

## Advanced Filter Settings: `filter_options` Struct

The `filter_options` struct allows you to fine-tune advanced aspects of the filtering process, especially for particle filters and other non-default scenarios. Common fields include:

| Field               | Description                                                         |
|:-------------------:|:-------------------------------------------------------------------:|
| `nparticles`        | Number of particles for particle filtering (default: 1000 or as set) |
| `resampling`        | Resampling method: e.g., 'systematic', 'multinomial', 'stratified'   |
| `resample_threshold`| Effective sample size threshold for resampling (0-1, default: 0.5)  |
| `seed`              | Random seed for reproducibility                                      |
| `max_iter`          | Maximum number of iterations (if applicable)                         |
| `verbose`           | Level of output detail (true/false or integer)                       |
| ...                 | Other model-specific or filter-specific options                      |

### Example

```matlab
opts = struct('nparticles', 2000, 'resampling', 'systematic', 'resample_threshold', 0.7, 'seed', 42);
results = filter(m, 'data', data_struct, 'filter_type', 'particle', 'filter_options', opts);
```

```matlab
results = filter(m, 'data', data_struct, 'filter_type', 'kalman', 'smoother', true);
```

## Supported Filter Types and Their Options

RISE supports several types of filters for state-space models. Each filter type is suited for different model structures and inference needs. Below is a list of the main filter types, with explanations and their key options:

| Filter Type                  | Description                                                                 | Key Options/Notes                                                                                 |
|------------------------------|-----------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| `kalman`                     | Standard Kalman filter for linear Gaussian state-space models.               | Fast, exact for linear models. Use with `filter_options.kalman_tol` for numerical tolerance.      |
| `extended_kalman`            | Extended Kalman filter (EKF) for nonlinear models, linearizes at each step.  | Use `filter_options.linearization` to control linearization order.                                |
| `unscented_kalman`           | Unscented Kalman filter (UKF) for nonlinear models, uses sigma points.       | Set `filter_options.alpha`, `beta`, `kappa` for sigma point spread and weighting.                 |
| `particle`                   | Particle filter for highly nonlinear/non-Gaussian models.                    | Control with `filter_options.nparticles`, `resampling`, `resample_threshold`, etc.                |
| `bootstrap_particle`         | Bootstrap particle filter, a basic particle filter variant.                   | Similar options as `particle`.                                                                    |
| `apf`                        | Auxiliary particle filter, improves on bootstrap for some models.            | Similar options as `particle`, plus auxiliary variable settings.                                  |
| `simulation_smoother`        | Simulation smoother for drawing states from the smoothing distribution.      | Use after filtering for state simulation.                                                         |
| `kalman_smoother`            | Kalman smoother for linear Gaussian models.                                 | Provides smoothed state estimates.                                                                |
| `extended_kalman_smoother`   | Smoother for EKF, applies to nonlinear models.                              | Provides smoothed state estimates for nonlinear models.                                           |
| `unscented_kalman_smoother`  | Smoother for UKF, applies to nonlinear models.                              | Provides smoothed state estimates for nonlinear models.                                           |

### Filter Type Details

- **kalman**: The default for linear models. Fast and numerically stable. Use when the model is linear and all shocks are Gaussian.
- **extended_kalman**: For nonlinear models. Linearizes the model at each time step. May be less accurate for highly nonlinear systems.
- **unscented_kalman**: Uses deterministic sampling (sigma points) to better capture nonlinearities. More accurate than EKF for some models.
- **particle**: Handles strong nonlinearities and non-Gaussian shocks. Computationally intensive. Number of particles (`nparticles`) controls accuracy.
- **bootstrap_particle**: A simple particle filter. Use for baseline comparisons or simple nonlinear models.
- **apf**: Auxiliary particle filter. Can be more efficient than bootstrap in some cases, especially with informative auxiliary variables.
- **simulation_smoother**: Used to generate draws from the full smoothing distribution, often for Bayesian analysis.
- **kalman_smoother**: Provides optimal smoothed state estimates for linear models.
- **extended_kalman_smoother**: Smoothing for nonlinear models using EKF.
- **unscented_kalman_smoother**: Smoothing for nonlinear models using UKF.

### Filter Options by Type

Each filter type in RISE can be customized with specific options via the `filter_options` struct. Below are the most relevant options for each filter type:

#### Kalman Filter (`kalman`)

| Option            | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `kalman_tol`      | Numerical tolerance for matrix inversions (default: 1e-12).                  |
| `steady_state`    | Use steady-state Kalman gain (true/false, default: false).                   |
| `presample`       | Number of initial periods to discard from likelihood (default: 0).           |
| `verbose`         | Level of output detail (true/false or integer).                              |

#### Extended Kalman Filter (`extended_kalman`)

| Option            | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `linearization`   | Order of Taylor expansion (default: 1).                                      |
| `kalman_tol`      | Numerical tolerance for matrix inversions.                                   |
| `presample`       | Number of initial periods to discard from likelihood.                        |
| `verbose`         | Level of output detail.                                                      |

#### Unscented Kalman Filter (`unscented_kalman`)

| Option            | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `alpha`           | Spread of sigma points (default: 1e-3).                                      |
| `beta`            | Prior knowledge of distribution (default: 2 for Gaussian).                   |
| `kappa`           | Secondary scaling parameter (default: 0).                                    |
| `kalman_tol`      | Numerical tolerance for matrix inversions.                                   |
| `presample`       | Number of initial periods to discard from likelihood.                        |
| `verbose`         | Level of output detail.                                                      |

#### Particle Filter (`particle`, `bootstrap_particle`, `apf`)

| Option                | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `nparticles`          | Number of particles (default: 1000).                                        |
| `resampling`          | Resampling method: 'systematic', 'multinomial', 'stratified' (default: 'systematic'). |
| `resample_threshold`  | Effective sample size threshold for resampling (0-1, default: 0.5).         |
| `seed`                | Random seed for reproducibility.                                            |
| `max_iter`            | Maximum number of iterations (if applicable).                               |
| `verbose`             | Level of output detail.                                                     |
| `auxiliary_variable`  | (APF only) Auxiliary variable settings.                                     |

#### Smoothers (`*_smoother`, `simulation_smoother`)

| Option            | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `draws`           | Number of draws for simulation smoother (default: 1).                        |
| `seed`            | Random seed for reproducibility.                                            |
| `verbose`         | Level of output detail.                                                     |

**Note:** Not all options are required for every filter type. Unused options are ignored. For advanced use, see the RISE source or API docs for additional filter-specific settings.

#### Example: Setting the Filter Type

```matlab
filter_options = struct();
filter_options.filter_type = 'particle';
filter_options.nparticles = 1000;
results = filter(mymodel, data, filter_options);
```

#### Notes
- Not all filter types are compatible with all models. For example, `kalman` requires a linear state-space model.
- If an incompatible filter/model combination is chosen, RISE will throw an informative error.

## Smoothing

- Smoothing is typically available as part of the filter output or as a post-processing step.

## Output

- Filtered states, likelihood, and diagnostics are available in the results struct.
