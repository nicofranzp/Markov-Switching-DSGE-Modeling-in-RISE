clear all; load('MCMC_NKUS5725_20_Jan_2026_19_33_58');
priornames = fieldnames(me.estimation.priors);
ndraw = 100000;
res = mcmc(results,priornames,{1:5:ndraw,1:2});
[summary_tables, MyQuantiles] = summary(res);
figure('Name','Diagnostics')
subplot(2,4,1); autocorrplot(res,'theta');subplot(2,4,2); densplot(res,'theta');
subplot(2,4,3); meanplot(res,'theta');subplot(2,4,4); traceplot(res,'theta');
subplot(2,4,5); autocorrplot(res,'sig_mu_vol_1');subplot(2,4,6); densplot(res,'sig_mu_vol_1');
subplot(2,4,7); meanplot(res,'sig_mu_vol_1');subplot(2,4,8); traceplot(res,'sig_mu_vol_1');

