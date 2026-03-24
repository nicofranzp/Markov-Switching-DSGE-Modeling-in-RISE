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
load('MCMC_NKUS5725_20_Mar_2026_17_51_14');
% --- Settings ---
Nd = 100; % number of posterior draws to use
chain_id = 1; % which chain in 'results' to use
horizon = 20; % IRF horizon (used below for deterministic IRFs)
pct = [5 50 95]; % credible bands
vnames_db = fieldnames(db); %
T = db.(vnames_db{1}).NumberOfObservations; % Sample length
t = 1:T; % Time axis
% --- Storage for probabilities and smoothed gap across draws ---
prob_dove = NaN(Nd,T); % P(policy state = 2)
prob_volhi = NaN(Nd,T); % P(volatility state = 2)
gap_smooth = NaN(Nd,T); % smoothed output gap (omega)
% --- Storage for decompositions per draw (kept as cells; summarize later) ---
vardec_store = cell(Nd,1);
histdec_store= cell(Nd,1);

% --- Main loop over posterior draws ---
for d = 1:Nd
for k = 1:20 % max re-draws (pick a small-ish cap)
[draw, me_draw] = draw_parameter(me, results{chain_id}.pop);
[filt, ~] = filter(me_draw,'data',db);
if ~isempty(filt), break; end
end
if isempty(filt), error('filter returned empty after max re-draws.'); end
% Collect smoothed probabilities and smoothed output gap
prob_dove(d,:) = filt.smoothed_state_probabilities.policy_2.data;
prob_volhi(d,:) = filt.smoothed_state_probabilities.vol_2.data;
gap_smooth(d,:) = filt.Expected_smoothed_variables.Omega.data;

% variance decomposition at this draw
[vardec, ~]       = variance_decomposition(me_draw);
vardec_store{d}  = vardec;
end

% --- Posterior summaries (means and 90% credible bands) ---
prob_dove_q = prctile(prob_dove, pct, 1); % 3-by-T (5th, 50th, 95th)
prob_volhi_q = prctile(prob_volhi, pct, 1);
gap_q = prctile(gap_smooth,pct, 1);
% --- Plot probabilities and gap with 90% bands (simple skeleton) ---
start_dt = datetime(1954,7,1); % 1954Q3 starts July 1954
timevec = start_dt + calquarters(0:T-1);
figure('Name','Posterior probabilities and output gap','Color','w');
subplot(3,1,1);fill([t, fliplr(t)],[gap_q(1,:),fliplr(gap_q(3,:))],...
0.9*[1 1 1],'EdgeColor','none'); hold on;
plot(t, gap_q(2,:), 'k', 'LineWidth', 1);
xticks(1:20:T); xticklabels(datestr(timevec(1:20:T),'yyyyQQ')); xlim([1 T]);
title('A: Output Gap','FontSize',14);
subplot(3,1,2);fill([t, fliplr(t)],[prob_dove_q(1,:),fliplr(prob_dove_q(3,:))],...
0.9*[1 1 1],'EdgeColor','none');hold on;
plot(t, prob_dove_q(2,:), 'k', 'LineWidth', 1);
xticks(1:20:T);xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));xlim([1 T]);
title('B: Probability to be in Dovish policy state','FontSize',14);
subplot(3,1,3);fill([t, fliplr(t)],[prob_volhi_q(1,:),fliplr(prob_volhi_q(3,:))],...
0.9*[1 1 1],'EdgeColor','none');hold on;
plot(t, prob_volhi_q(2,:), 'k', 'LineWidth', 1);
xticks(1:20:T);xticklabels(datestr(timevec(1:20:T),'yyyyQQ'));xlim([1 T]);
title('C: Probability to be in High volatility state','FontSize',14);

%% historical decomposition
hd=historical_decomposition_switch(me);