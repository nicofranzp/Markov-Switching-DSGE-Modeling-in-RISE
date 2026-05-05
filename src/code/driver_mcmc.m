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
load(getEstimationFilename(Path.examples, 'Estimation_NKUS5425', 'latest'));

[objective,lb,ub,mu,SIG]=pull_objective(me, 'solve_check_stability', false, 'fix_point_TolFun', 1e-6);
scale=0.15;
myOpts=struct();
myOpts.tunedCov=scale*SIG;
myOpts.nchain=2;
myOpts.N=100;
energy=@(varargin)-objective(varargin{:});
results=sample(rsamplers.rwmh(energy,mu,lb,ub,myOpts));
mddobj=mdd(results,energy,lb,ub,[],[],true); mdd_bridge = bridge(mddobj,true);
rndName1=fullfile(Path.examples,['MCMC_NKUS5725_',replace(char(datetime("now")),{'-',':',' '},{'_','_','_'})]);
save(rndName1, 'pmode', 'priors', 'me', 'filtration', 'm', 'db', 'results', 'objective', 'lb', 'ub', 'mdd_bridge');