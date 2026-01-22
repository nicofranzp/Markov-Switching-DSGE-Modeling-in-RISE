function [y_,newp,retcode] = nk_nonlinear_ssfile(obj, y_, p, d, id)
retcode = 0;
if nargin == 1
% list of endogenous variables to be calculated
y_ = {'Y', 'Pai', 'R', 'C', 'G1', 'G2', 'Pstar', 'Pf', 'Pb', 'D', 'W', 'N'};
% list of parameters to be computed during steady state calculation
newp = {};
else % provide steady state for everything except LMs
% no parameters to update or create in the steady state file
newp = [];
Pai = p.PaiT;
Pstar = ((1-p.gamma*p.PaiT^(p.eta-1))/(1-p.gamma))^(1/(1-p.eta));
Pb = Pstar*p.PaiT;
Pf = (Pstar*Pb^(-p.zeta))^(1/(1-p.zeta));
W = (1-p.gamma*p.beta*p.PaiT^p.eta)/(1-p.gamma*p.beta*p.PaiT^(p.eta-1))*(p.eta-1)/p.eta*Pf;
D = (1-p.gamma)*Pstar^(-p.eta)/(1-p.PaiT^p.eta*p.gamma);
Y = (W*(1-p.theta)^(-p.sigma)*D^(-p.varphi))^(1/(p.varphi+p.sigma));
C = (1-p.theta)*Y;
G1 = ((C^(-p.sigma)*W*Y)/((1-p.gamma*p.beta*p.PaiT^p.eta)));
G2 = ((C^(-p.sigma)*Y)/((1-p.gamma*p.beta*p.PaiT^(p.eta-1))));
R = p.nu*p.PaiT/p.beta;
N = D*Y;

ys = [Y, Pai, R, C, G1, G2, Pstar, Pf, Pb, D, W, N].'; % DO NOT INCLUDE IMPOSED VARIABLE HERE

% check the validity of the calculations
if ~utils.error.valid(ys) retcode = 1; else y_(id) = ys; end
end
end