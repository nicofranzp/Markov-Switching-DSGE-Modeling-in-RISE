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
m = rise('nk_ms_obs.rs');
% Parameterization
p = struct('beta',1/(1+0.706/400),'sigma',2.9,'varphi',2.5,'theta',0.82, ...
'gamma',0.77,'zeta',0.10,'rho_z',0.90,'rho_mu',0.70,'rho_xi',0.80, ...
'rho_r',0.79,'sig_z',0.50,'sig_mu',0.15,'sig_xi',0.10,'sig_r',0.10,...
'policy_tp_1_2',0.05,'policy_tp_2_1',0.05, ... % Tr. prob. (off-diagonal)
'phi1_policy_1',1.72,'phi1_policy_2',1.20,... % state-specific coefficients
'phi2_policy_1',0.49,'phi2_policy_2',0.20 ); % state-specific coefficients
m = set(m,'parameters',p);
% Solve and print
m = solve(m); vList = {'R','Y','Pai','C','Omega','Mu','Xi','Z'}; print_solution(m,vList);
% Simulation: simulate, access the data and print basic statistics
rng(1234); nsim = 300; mysim = simulate(m,'simul_periods',nsim);
obsnames = get(m,'obs_list');
db = rmfield(mysim, setdiff(fieldnames(mysim), obsnames));

[myfilt, loglik] = filter(m,'data',db);
% True vs updated vs smoothed (omega and hawkish probability)
t = 1:nsim;
gap_data = mysim.Omega.data;
gap_upd = myfilt.Expected_updated_variables.Omega.data;
gap_smo = myfilt.Expected_smoothed_variables.Omega.data;
hawk_data = 2 - mysim.policy.data; % recode so 1 = hawkish
hawk_upd = myfilt.updated_state_probabilities.policy_1.data;
hawk_smo = myfilt.smoothed_state_probabilities.policy_1.data;
figure('Name','Results','Color','w');
subplot(2,1,1)
plot(t,gap_data,'k-',t,gap_upd,'k-.',t,gap_smo,'k--','LineWidth',1);title('A: Output Gap');
subplot(2,1,2)
plot(t,hawk_data,'k-',t,hawk_upd,'k-.',t,hawk_smo,'k--','LineWidth',1);
title('B: Probability to be in Hawkish policy state');
legend('data','updated variables','smoothed variables','Location','best');
%--- RMSEs and smoothing gains ---
gap_upd_RMSE = sqrt(mean((gap_upd - gap_data).^2));
gap_smo_RMSE = sqrt(mean((gap_smo - gap_data).^2));
gap_gain = (1 - gap_smo_RMSE/gap_upd_RMSE)*100;
hawk_upd_RMSE = sqrt(mean((hawk_upd - hawk_data).^2));
hawk_smo_RMSE = sqrt(mean((hawk_smo - hawk_data).^2));
hawk_gain = (1 - hawk_smo_RMSE/hawk_upd_RMSE)*100;
fprintf('GAP : RMSE upd=%.4f, smo=%.4f, gain=%.1f%%\n', gap_upd_RMSE, gap_smo_RMSE, gap_gain);
fprintf('Hawk: RMSE upd=%.4f, smo=%.4f, gain=%.1f%%\n', hawk_upd_RMSE, hawk_smo_RMSE, hawk_gain);