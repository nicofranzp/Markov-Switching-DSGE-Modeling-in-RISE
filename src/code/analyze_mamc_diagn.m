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


% Load latest MCMC file
mcmcFile = getEstimationFilename(Path.examples, 'MCMC_NKUS5725', 'latest');
load(mcmcFile);

priornames = fieldnames(me.estimation.priors);
ndraw = 1000;
res = mcmc(results, priornames, {1:5:ndraw,1:2});
[summary_tables, MyQuantiles] = summary(res);
figure('Name','Diagnostics')
subplot(2,4,1); autocorrplot(res,'theta');subplot(2,4,2); densplot(res,'theta');
subplot(2,4,3); meanplot(res,'theta');subplot(2,4,4); traceplot(res,'theta');
subplot(2,4,5); autocorrplot(res,'sig_mu_vol_1');subplot(2,4,6); densplot(res,'sig_mu_vol_1');
subplot(2,4,7); meanplot(res,'sig_mu_vol_1');subplot(2,4,8); traceplot(res,'sig_mu_vol_1');

