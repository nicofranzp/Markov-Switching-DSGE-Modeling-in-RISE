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
estimationFile = getEstimationFilename(Path.examples, 'Estimation_NKUS5425', 'latest');
load(estimationFile);
plot_probabilities(me); print_estimation_results(me);
[myfilt_e, LogLik_e] = filter(me); % The model is parameterized by estimated parameters

%%
gap_upd_e = myfilt_e.Expected_updated_variables.Omega;
gap_smo_e = myfilt_e.Expected_smoothed_variables.Omega;
dove_upd_e = myfilt_e.updated_state_probabilities.policy_2;
dove_smo_e = myfilt_e.smoothed_state_probabilities.policy_2;
hvol_upd_e = myfilt_e.updated_state_probabilities.vol_2;
hvol_smo_e = myfilt_e.smoothed_state_probabilities.vol_2;



%
gap_true_100 = readmatrix('GDPC1_GDPPOT.xlsx','Sheet',2,'Range','B24:B307');
gap_true = (gap_true_100-mean(gap_true_100));


vname  = readcell('GDPC1_GDPPOT.xlsx','Sheet',2,'Range','B1:B1');
start='1954Q3';
gap_true_ts=ts(start,gap_true);

corr([gap_upd_e.data,gap_smo_e.data,gap_true_ts.data])

figure('name','results imm','Color','w')
subplot(3,1,1)
plot(gap_upd_e,'k-.','LineWidth',1)
hold on
plot(gap_smo_e,'k--','LineWidth',1)
hold on
plot(gap_true_ts,'k-','LineWidth',1)
hold on
legend('updated variables','smoothed variables','CBO output gap (FRED)','FontSize',14,...
    'Orientation','horizontal','EdgeColor','none','Interpreter','latex')

title('A: Output Gap','FontSize',14,'Interpreter','latex')
subplot(3,1,2)
plot(dove_upd_e,'k-.','LineWidth',1)
hold on
plot(dove_smo_e,'k--','LineWidth',1)
title('B: Probability to be in Dovish policy state','FontSize',14,'Interpreter','latex')
subplot(3,1,3)
plot(hvol_upd_e,'k-.','LineWidth',1)
hold on
plot(hvol_smo_e,'k--','LineWidth',1)
title('C: Probability to be in High volatility state','FontSize',14,'Interpreter','latex')

figure('name','results imm')
subplot(3,1,1)
plot(gap_upd_e,'r-.','LineWidth',1)
hold on
plot(gap_smo_e,'b--','LineWidth',1)
title('A: Output Gap','FontSize',14,'Interpreter','latex')
hold on
subplot(3,1,2)
plot(dove_upd_e,'r-.','LineWidth',1)
hold on
plot(dove_smo_e,'b--','LineWidth',1)
title('B: Probability to be in Dovish policy state','FontSize',14,'Interpreter','latex')
subplot(3,1,3)
plot(hvol_upd_e,'r-.','LineWidth',1)
hold on
plot(hvol_smo_e,'b--','LineWidth',1)
title('C: Probability to be in High volatility state','FontSize',14,'Interpreter','latex')
legend('updated variables','smoothed variables')