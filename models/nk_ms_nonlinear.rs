@endogenous(log) Y , Pai, R, C, G1, G2, Pstar, Pf, Pb, D, W, N
@endogenous Z, Mu, Xi
@exogenous Ez, Emu, Exi, Ei
@parameters beta, nu, sigma, varphi, theta, gamma, zeta, eta, PaiT, rho_z, rho_mu, rho_xi,
rho_r, sig_r, policy_tp_1_2, policy_tp_2_1, sig_z, sig_mu, sig_xi
@parameters(policy,2) phi1, phi2


@model
# lambda = ((gamma*(beta*zeta+1))/((1-gamma*beta)*(1-zeta)*(1-gamma)));
1 = beta/nu*(R{t})*(C{t+1}*exp(Xi{t+1})/C{t}/exp(Xi{t}))^(-sigma)*1/exp(Z{t+1})/Pai{t+1}
# 1 = beta/nu*(R{stst})/PaiT;
C{t} = Y{t} - theta*Y{t-1};
Pf{t} = eta/(eta-1)*G1{t}/G2{t};
G1{t} = (C{t}*exp(Xi{t}))^(-sigma)*Y{t}*exp(Mu{t})*W{t} + gamma*beta*Pai{t+1}^eta*G1{t+1};
G2{t} = (C{t}*exp(Xi{t}))^(-sigma)*Y{t} + gamma*beta*Pai{t+1}^(eta-1)*G2{t+1};
Pb{t} = Pstar{t-1}*Pai{t-1};
Pstar{t} = Pf{t}^(1-zeta)*Pb{t}^zeta;
1 = gamma*Pai{t}^(eta-1) + (1-gamma)*(Pstar{t})^(1-eta);
W{t} = N{t}^varphi*C{t}^sigma;
N{t} = D{t}*Y{t};
D{t} = (1-gamma)*Pstar{t}^(-eta) + Pai{t}^eta*gamma*D{t-1};
R{t}/R{stst} = (R{t-1}/R{stst})^rho_r
*[(Pai{t}/PaiT)^phi1*(Y{t}/(Y{t-1})*exp(Z{t}))^phi2]^(1-rho_r)*exp(sig_r*Ei{t});
Z{t} = rho_z*Z{t-1} + sig_z*Ez{t};
Mu{t} = rho_mu*Mu{t-1} + lambda*sig_mu*Emu{t};
Xi{t} = rho_xi*Xi{t-1} + sig_xi*Exi{t};