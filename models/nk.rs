@endogenous
Y, Pai, R, C, Omega, Z, Mu, Xi

@exogenous
Ez, Emu, Exi, Ei

@parameters
beta, sigma, varphi, theta, gamma, zeta, rho_z, rho_mu, rho_xi, rho_r,
phi1, phi2, sig_z, sig_mu, sig_xi, sig_r

@model
% Definitions
# varkappa = gamma*(1+beta*zeta);
# chi_f = gamma*(1-zeta*(1-gamma))/varkappa;
# chi_b = zeta/varkappa;
# kappa = (sigma/(1 - theta) + varphi)*(1-gamma)*(1-zeta)*(1-gamma*beta)/varkappa;

% Equations
C{t} = (Y{t} - theta*Y{t-1} ) / (1 - theta);
C{t} = C{t+1} - (1/sigma)*( R{t} - Pai{t+1} - Z{t+1} ) - Xi{t} + Xi{t+1};
Pai{t} = chi_f*beta*Pai{t+1} + chi_b*Pai{t-1} + kappa*Omega{t} + Mu{t};
Omega{t} = Y{t} - sigma*theta*Y{t-1}/(sigma +(1 - theta)*varphi);
Z{t} = rho_z*Z{t-1} + sig_z*Ez{t};
Mu{t} = rho_mu*Mu{t-1} + sig_mu*Emu{t};
Xi{t} = rho_xi*Xi{t-1} + sig_xi*Exi{t};
R{t} = rho_r*R{t-1} + (1 - rho_r)*( phi1*Pai{t} + phi2*( Y{t} - Y{t-1} + Z{t}) ) + sig_r*Ei{t};