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
m = rise('nk_ms.rs');
% Parameterization
p = struct('beta', 1/(1+0.706/400), 'sigma',2.9, 'varphi',2.5, 'theta',0.82, 'gamma',0.77, 'zeta', 0.10, 'rho_z', 0.90, 'rho_mu', 0.70, 'rho_xi',0.80, 'rho_r',0.79,'sig_z', 0.50, 'sig_mu', 0.15, 'sig_xi', 0.10, 'sig_r', 0.10, 'policy_tp_1_2', 0.05, 'policy_tp_2_1', 0.05, 'phi1_policy_1', 1.72, 'phi1_policy_2', 1.20, 'phi2_policy_1', 0.49, 'phi2_policy_2', 0.20 );
m = set(m, 'parameters', p);
% Solve and print
m = solve(m);
vList = {'R', 'Y', 'Pai', 'C', 'Omega', 'Mu', 'Xi', 'Z'};
print_solution(m,vList);
% IRFs: compute and plot
IRF = irf(m, 'irf_periods', 24);
quick_irfs(m, IRF, {'Pai', 'Y', 'R'}, {'Ez', 'Emu', 'Exi', 'Ei'});
% Simulation: simulate, access the data and print basic statistics
rng(1234);
nsim = 300;
mysim = simulate(m, 'simul_periods', nsim);
fprintf('Std Pai=%.3f, Y=%.3f,R=%.3f\n', std(mysim.Pai.data), std(mysim.Y.data), std(mysim.R.data));