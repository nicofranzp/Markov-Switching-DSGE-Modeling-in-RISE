clear all; load('Estimation_NKUS5425_20_Jan_2026_15_29_36');
[objective,lb,ub,mu,SIG]=pull_objective(me,...
'solve_check_stability',false,'fix_point_TolFun',1e-6);
scale=0.15;
myOpts=struct(); myOpts.tunedCov=scale*SIG;myOpts.nchain=2; myOpts.N=100000;
energy=@(varargin)-objective(varargin{:});
results=sample(rsamplers.rwmh(energy,mu,lb,ub,myOpts));
mddobj=mdd(results,energy,lb,ub,[],[],true); mdd_bridge = bridge(mddobj,true);
rndName1=['MCMC_NKUS5725_',replace(char(datetime("now")),{'-',':',' '},{'_','_','_'})];
save(rndName1,'pmode','priors','me','filtration','m','db','results','objective',...
'lb','ub','mdd_bridge');