function priors = create_priors(model)
priors = struct();
% --- Structural parameters (Chen et al. 2017, Table 1) ---
priors.sigma = {3.2512, 2.50, 0.15, 'normal', 0.5, 5}; % inv. IES
priors.varphi = {2.6795, 2.50, 0.15, 'normal', 0.5, 5}; % inv. Frisch
priors.theta = {0.27175, 0.25, 0.05, 'beta', 0.01, 0.999}; % habit
priors.gamma = {0.74198, 0.75, 0.02, 'beta', 0.01, 0.999}; % Calvo
priors.zeta = {0.93025, 0.75, 0.05, 'beta', 0.01, 0.999}; % indexation
% --- AR(1) coefficients ---
priors.rho_xi = {0.91315, 0.50, 0.15, 'beta', 0.01, 0.999};
priors.rho_mu = {0.17067, 0.50, 0.15, 'beta', 0.01, 0.999};
priors.rho_z = {0.6328, 0.50, 0.15, 'beta', 0.01, 0.999};
priors.rho_r = {0.836, 0.50, 0.15, 'beta', 0.01, 0.999};
% --- Shock volatilities (switching) ---
priors.sig_xi_vol_1 = {0.97639, 0.50, 0.50, 'igamma1', 1e-4, 10};
priors.sig_xi_vol_2 = {4.7282, 2.00, 0.50, 'igamma1', 1e-4, 10};
priors.sig_mu_vol_1 = {0.0858, 0.25, 0.50, 'igamma1', 1e-4, 10};
priors.sig_mu_vol_2 = {0.76634, 1.00, 0.50, 'igamma1', 1e-4, 10};
priors.sig_z_vol_1 = {0.33166, 0.50, 0.50, 'igamma1', 1e-4, 10};
priors.sig_z_vol_2 = {1.0837, 1.50, 0.50, 'igamma1', 1e-4, 10};
priors.sig_r = {0.18226, 0.25, 0.05, 'igamma1', 1e-4, 10};
% --- Policy rule coefficients (switching) ---
priors.phi1_policy_1 = {1.8601, 2.00, 0.15, 'normal', 0.001, 10};
priors.phi1_policy_2 = {0.34163, 0.50, 0.50, 'normal', 0.001, 10};
priors.phi2_policy_1 = {0.85946, 0.50, 0.15, 'beta', 0.01, 0.999};
priors.phi2_policy_2 = {0.35774, 0.50, 0.15, 'beta', 0.01, 0.999};
% --- Transition probabilities (off-diagonals) ---
priors.policy_tp_1_2 = {0.061718, 0.10, 0.05, 'beta', 0.001, 0.999};
priors.policy_tp_2_1 = {0.18273, 0.10, 0.05, 'beta', 0.001, 0.999};
priors.vol_tp_1_2 = {0.0260, 0.10, 0.05, 'beta', 0.001, 0.999};
priors.vol_tp_2_1 = {0.2013, 0.10, 0.05, 'beta', 0.001, 0.999};