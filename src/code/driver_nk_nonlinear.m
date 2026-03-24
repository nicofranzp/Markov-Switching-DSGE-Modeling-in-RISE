%% Preamble 
	close all
	clear
	clc
%% Loads matlab project with all the relative paths
	input.root_name= 'Markov-Switching-DSGE-Modeling-in-RISE';
	local_path= fileparts(mfilename('fullpath'));
	root= extractBefore(local_path,strfind(local_path, input.root_name)+length(input.root_name));
	cd(fullfile(local_path,'functions', 'utils'));
	loadProject(root, input.root_name);
	Path= setPaths(currentProject);
%% Check for RISE startup
	try 
		rise;
	catch
		run('rise_startup.m');
	end
%% Run the code
m = rise('nk_ms_nonlinear.rs', 'steady_state_file', @nk_nonlinear_ssfile);
p = struct('beta', 1/(1+0.706/400), 'sigma', 2.9, 'varphi', 2.5, 'theta', 0.82, 'gamma', 0.77, 'zeta', 0.10, 'eta', 10, 'nu', 1, 'rho_z', 0.90, 'rho_mu', 0.70, 'rho_xi', 0.80, 'rho_r', 0.79, 'PaiT', 1., 'sig_r', 0.10/100, 'sig_z', 0.50/100, 'sig_mu', 0.15/100, 'sig_xi', 0.10/100, 'policy_tp_1_2', 0.05, 'policy_tp_2_1', 0.05, 'phi1_policy_1', 1.72, 'phi1_policy_2', 1.20, 'phi2_policy_1', 0.49, 'phi2_policy_2', 0.20);
m = set(m, 'parameters', p);
isnan(m);
% Brute force solve is not robust for nonlinear models and often fails.
% Use the robust approaches below (steady state file or bounds).
% m0 = solve(set(m, 'parameters', struct('beta', 0.99, 'sigma', 2, 'varphi', 2, 'theta', 0.75, 'gamma', 0.5, 'zeta', 0.1, 'eta', 5, 'nu', 1, 'rho_z', 0.5, 'rho_mu', 0.5, 'rho_xi', 0.5, 'rho_r', 0.5, 'PaiT', 1, 'sig_r', 1e-4, 'sig_z', 1e-4, 'sig_mu', 1e-4, 'sig_xi', 1e-4, 'policy_tp_1_2', 0.01, 'policy_tp_2_1', 0.01, 'phi1_policy_1', 1.5, 'phi1_policy_2', 1.2, 'phi2_policy_1', 0.5, 'phi2_policy_2', 0.2));
% print_solution(m0);

%% --- approaches to solution ---
% provide a steady state file (now set at model creation)
ms1 = solve(m); print_solution(ms1);
resid(m); % Check residuals with imposed steady state
% smart initial conditions and bounds
bnds = struct();
bnds.Y = [2.4630 0 Inf]; bnds.Pai = [1.0000 0 Inf]; bnds.R = [0.0018 0 Inf];
bnds.C = [0.4433 0 Inf]; bnds.G1 = [101.3613 0 Inf]; bnds.G2 = [112.6237 0 Inf];
bnds.Pstar = [1.0000 0.5 2]; bnds.Pf = [1.0000 0.5 2]; bnds.Pb = [1.0000 0.5 2];
bnds.D = [1.0000 0.5 2]; bnds.W = [0.90000 0.5 2];
% ms3 = solve(m,'sstate_bounds',bnds,'debug',true,'sstate_blocks',true); print_solution(ms3);