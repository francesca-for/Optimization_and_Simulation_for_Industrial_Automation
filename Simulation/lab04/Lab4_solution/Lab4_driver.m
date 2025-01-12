clear
close all
clc

% Queueing network of point 1

gamma1 = 0.5;
gamma2 = 0.5;

mu1 = 4;
mu2 = 12;
mu3 = 4;
mu_vec = [mu1;mu2;mu3];

p21 = 0.4;
p31 = 1-p21;
p12 = 0.3;
p22 = 1-p12;
p13 = 0.4;
p33 = 0.2;

R = [0,p12,p13;p21,p22,0;p31,0,p33];
gamma1_vec = [gamma1;gamma2;0];

lambda1_vec = (eye(3) - R)^(-1) * gamma1_vec;

rho1_vec = lambda1_vec ./ mu_vec;
EL1 = rho1_vec.^2 ./ (1-rho1_vec);

open_system('Lab4a')
sim_out_a = sim('Lab4a');

% Queueing network of point 3

gamma1 = 1;
gamma2_vec = [gamma1;gamma2;0];

lambda2_vec = (eye(3) - R)^(-1) * gamma2_vec;

rho2_vec = lambda2_vec ./ ([2;1;1] .*  mu_vec);
EL2 = rho2_vec.^2 ./ (1-rho2_vec);
EL2(1) = 2 * rho2_vec(1).^3 / (1 - rho2_vec(1)^2);

open_system('Lab4b')
sim_out_b = sim('Lab4b');

% Queueing network of point 4
open_system('Lab4c')
sim_out_c = sim('Lab4c');




