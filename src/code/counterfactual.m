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
load(getEstimationFilename(Path.examples, 'MCMC_NKUS5725', 'latest'));
% Dimensions and variable names
T = me.options.data.NumberOfObservations; chain_id = 1; K = 100;rng(123);
exo_names = get(me,'exo_list'); endo_names = get(me,'endo_list');
for indx = 1:K
for ki = 1:20 % max re-draws (pick a small-ish cap)
[draw, me_draw] = draw_parameter(me, results{chain_id}.pop);
[filt, ~] = filter(me_draw,'data',db);
if ~isempty(filt), break; end
end
if isempty(filt), error('filter returned empty after max re-draws.'); end
% Build regime path from smoothed probabilities
[~, pol_path] = max([filt.smoothed_state_probabilities.policy_1.data,...
filt.smoothed_state_probabilities.policy_2.data],[],2);
[~, vol_path] = max([filt.smoothed_state_probabilities.vol_1.data,...
filt.smoothed_state_probabilities.vol_2.data],[],2);
regime_path = 2*(pol_path-1) + vol_path; % (1,1)->1 ... (2,2)->4
% Construct plan with initial conditions
end_hist = 1; end_forecast = T; init_reg = regime_path(end_hist);
plan_hist = simplan(me_draw,[end_hist,end_forecast],init_reg);
% Initialise all endogenous vars (incl. forward-looking ones)
for k = 1:numel(endo_names)
v = endo_names{k}; x0 = filt.Expected_smoothed_variables.(v).data(1);
plan_hist = append(plan_hist,{v,end_hist,x0});
end
% And exogenous shocks
for k = 1:numel(exo_names)
v = exo_names{k}; x0 = filt.Expected_smoothed_shocks.(v).data(1);
plan_hist = append(plan_hist,{v,end_hist,x0});
end
% Pin regime and smoothed shocks for t = 1..T
plan_hist = append(plan_hist,{'regime',end_hist+1:end_forecast,...
regime_path(end_hist+1:end_forecast)});
for j = 1:numel(exo_names)
sj = filt.Expected_smoothed_shocks.(exo_names{j}).data(:);
plan_hist = append(plan_hist,{exo_names{j},end_hist+1:end_forecast,...
sj(end_hist+1:end_forecast)});
end
% Historical simulation
sim_hist = simulate(me_draw,'simul_historical_data',plan_hist);
R_obs_sim(indx,:) = sim_hist.R_obs.data; Pai_obs_sim(indx,:) = sim_hist.Pai_obs.data;
Dy_obs_sim(indx,:) = sim_hist.Dy_obs.data;

plan_cf = plan_hist; % start from the historical plan
pol_path_cf = pol_path; % copy historical policy state
pol_path_cf(270:end) = 1; % force hawkish state from 2021Q4
regime_path_cf = 2*(pol_path_cf - 1) + vol_path; % rebuild regime index
plan_hist_cf = append(plan_cf, {'regime', 270:end_forecast, ...
regime_path_cf(270:end_forecast)});
sim_hist_cf = simulate(me_draw,'simul_historical_data',plan_hist_cf);
R_obs_cf(indx,:) = sim_hist_cf.R_obs.data; Pai_obs_cf(indx,:) = sim_hist_cf.Pai_obs.data;
Dy_obs_cf(indx,:) = sim_hist_cf.Dy_obs.data;
fprintf('Stored draw %d (after %d attempt(s)).\n', indx, ki);
end
%% Posterior summaries (means and 90% credible bands)
pct = [5 50 95]; R_obs_sim_q = prctile(R_obs_sim,pct,1);
Pai_obs_sim_q = prctile(Pai_obs_sim,pct,1); Dy_obs_sim_q = prctile(Dy_obs_sim,pct,1);
R_obs_cf_q = prctile(R_obs_cf,pct,1);
Pai_obs_cf_q = prctile(Pai_obs_cf,pct,1); Dy_obs_cf_q = prctile(Dy_obs_cf,pct,1);

%% plotting 
start_dt = datetime(1954,7,1); % 1954Q3 starts July 1954
timevec = start_dt + calquarters(0:T-1);
t         = 1:T;
stst_i = 4.61;
stst_pi = 3.87;
stst_dy = 0.76;
figure('Name','Historical replication check','Color','w');

subplot(3,1,1);
fill([t, fliplr(t)], [stst_i+R_obs_sim_q(1,:), fliplr(stst_i+R_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none'); hold on;
plot(t, stst_i+R_obs_sim_q(2,:), 'k-',1:T, stst_i+db.R_obs.data, 'k--', 'LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([1 T]);
title('A: Interest rate','FontSize',14); xlim([t(1) t(end)]);

subplot(3,1,2);
fill([t, fliplr(t)], [stst_pi+Pai_obs_sim_q(1,:), fliplr(stst_pi+Pai_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none'); hold on;
plot(t, stst_pi+Pai_obs_sim_q(2,:), 'k-',1:T, stst_pi+db.Pai_obs.data, 'k--', 'LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([1 T]);
title('B: Inflation','FontSize',14); xlim([t(1) t(end)]);

subplot(3,1,3);
fill([t, fliplr(t)], [stst_dy+Dy_obs_sim_q(1,:), fliplr(stst_dy+Dy_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none'); hold on;
plot(t, stst_dy+Dy_obs_sim_q(2,:), 'k-',1:T, stst_dy+db.Dy_obs.data, 'k--', 'LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([1 T]);
title('C: Output Growth Rate','FontSize',14); xlim([t(1) t(end)]);


figure('Name','Cosy of Living Crisis','Color','w');

subplot(1,3,1);
fill([t, fliplr(t)], [stst_i+R_obs_sim_q(1,:), fliplr(stst_i+R_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.7); hold on;
fill([t, fliplr(t)], [stst_i+R_obs_cf_q(1,:), fliplr(stst_i+R_obs_cf_q(3,:))], 0.6*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.35); hold on;
plot(t, stst_i+R_obs_sim_q(2,:), 'k-',t, stst_i+R_obs_cf_q(2,:), 'k-.','LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([260 T]);
title('A: Interest rate','FontSize',14);

subplot(1,3,2);
fill([t, fliplr(t)], [stst_pi+Pai_obs_sim_q(1,:), fliplr(stst_pi+Pai_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.7); hold on;
fill([t, fliplr(t)], [stst_pi+Pai_obs_cf_q(1,:), fliplr(stst_pi+Pai_obs_cf_q(3,:))], 0.6*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.35); hold on;
plot(t, stst_pi+Pai_obs_sim_q(2,:), 'k-',t, stst_pi+Pai_obs_cf_q(2,:), 'k-.', 'LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([260 T]);
title('B: Inflation','FontSize',14); 

subplot(1,3,3);
fill([t, fliplr(t)], [stst_dy+Dy_obs_sim_q(1,:), fliplr(stst_dy+Dy_obs_sim_q(3,:))], 0.9*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.7); hold on;
fill([t, fliplr(t)], [stst_dy+Dy_obs_cf_q(1,:), fliplr(stst_dy+Dy_obs_cf_q(3,:))], 0.6*[1 1 1], 'EdgeColor','none', 'FaceAlpha',0.35); hold on;
plot(t, stst_dy+Dy_obs_sim_q(2,:), 'k-',t, stst_dy+Dy_obs_cf_q(2,:), 'k-.','LineWidth', 1);
% Relabel x-axis with quarterly dates (say every 20th quarter)
xticks(1:20:T);
xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));
xlim([260 T]);
title('C: Output Growth Rate','FontSize',14); 