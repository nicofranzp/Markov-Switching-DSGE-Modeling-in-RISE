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
m = rise('nk_ms_est.dsge');
p = struct('beta', 1/(1+0.706/400), 'sigma', 2.9, 'varphi', 2.5, 'theta', 0.82, 'gamma', 0.77, 'zeta', 0.10, 'rho_z', 0.90, 'rho_mu', 0.70, 'rho_xi', 0.80, 'rho_r', 0.79, 'sig_r', 0.10, 'policy_tp_1_2', 0.05, 'policy_tp_2_1', 0.05, 'vol_tp_1_2', 0.05, 'vol_tp_2_1', 0.05, 'phi1_policy_1', 1.72, 'phi1_policy_2', 1.20, 'phi2_policy_1', 0.49, 'phi2_policy_2', 0.20, 'sig_z_vol_1', 0.50, 'sig_z_vol_2', 1.00, 'sig_mu_vol_1', 0.15, 'sig_mu_vol_2', 0.30, 'sig_xi_vol_1', 0.10, 'sig_xi_vol_2', 0.20);
m = set(m, 'parameters', p);
m = solve(m);
print_solution(m);
data = readmatrix('data_US.xlsx', 'Sheet', 1, 'Range', 'B2:D285');
vnames = readcell('data_US.xlsx', 'Sheet', 1, 'Range', 'B1:D1');
data = data-mean(data, 1);
start = '1954Q3';
db = struct();

for iv=1:numel(vnames)
	db.(vnames{iv}) = ts(start,data(:,iv));
end

figure('name','Observables')
for ii=1:numel(vnames) 
	subplot(3,1,ii);
	plot(db.(vnames{ii}));
	title(vnames{ii});
end
priors = create_priors(m);
[me, filtration] = estimate(m, 'data', db, 'estim_priors', priors, 'estim_start_date', '1954Q3', 'estim_end_date', '2025Q2', 'optimizer', 'fmincon');

% Save estimation results
rndName = fullfile(Path.examples, ['Estimation_NKUS5425_', replace(char(datetime("now")), {'-',':',' '}, {'_','_','_'})]);
pmode = get(me, 'mode');
save(rndName, 'pmode', 'priors', 'me', 'filtration', 'm', 'db');