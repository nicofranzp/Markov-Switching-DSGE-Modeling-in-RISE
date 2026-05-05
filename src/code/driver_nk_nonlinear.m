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
m = rise('nk_ms_nonlinear.dsge');
p = struct('beta', 1/(1+0.706/400), 'sigma', 2.9, 'varphi', 2.5, 'theta', 0.82, 'gamma', 0.77, 'zeta', 0.10, 'eta', 10, 'nu', 1, 'rho_z', 0.90, 'rho_mu', 0.70, 'rho_xi', 0.80, 'rho_r', 0.79, 'PaiT', 1., 'sig_r', 0.10/100, 'sig_z', 0.50/100, 'sig_mu', 0.15/100, 'sig_xi', 0.10/100, 'policy_tp_1_2', 0.05, 'policy_tp_2_1', 0.05, 'phi1_policy_1', 1.72, 'phi1_policy_2', 1.20, 'phi2_policy_1', 0.49, 'phi2_policy_2', 0.20);

m = set(m,'parameters',p);
isnan(m);
m0 = solve(m);
print_solution(m0);

% provide a steady state file
ms1 = solve(m, 'sstate_file', @nk_nonlinear_ssfile);
print_solution(ms1);
resid(set(m, 'sstate_imposed', true, 'sstate_file', @nk_nonlinear_ssfile));
% brute force + block decomposition
ms2 = solve(m, 'sstate_blocks', true); 
print_solution(ms2);
ms21 = solve(m, 'sstate_blocks', true, 'debug', true, 'sstate_solver', {'lsqnonlin', 'MaxIter', 2000, 'MaxFunEvals', 1000000}); print_solution(ms21);
ms22 = solve(m, 'sstate_blocks', true, 'debug', true, 'sstate_solver', {'fsolve', 'MaxIter', 2000, 'MaxFunEvals', 1000000}); 
print_solution(ms22);

% smart initial conditions and bounds
bnds = struct();
bnds.Y = [2.4630 0 Inf];
bnds.Pai = [1.0000 0 Inf];
bnds.R = [0.0018 0 Inf];
bnds.C = [0.4433 0 Inf];
bnds.G1 = [101.3613 0 Inf];
bnds.G2 = [112.6237 0 Inf];
bnds.Pstar = [1.0000 0.5 2];
bnds.Pf = [1.0000 0.5 2];
bnds.Pb = [1.0000 0.5 2];
bnds.D = [1.0000 0.5 2];
bnds.W = [0.90000 0.5 2];

ms3 = solve(m, 'sstate_bounds', bnds, 'debug', true, 'sstate_blocks', true);
print_solution(ms3);