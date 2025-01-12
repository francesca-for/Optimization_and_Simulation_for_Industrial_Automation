clear
close all
clc

a = 1;
b = 2;
a1 = 1;
n = 10;
p = 0.1;
mu = 0;
sigma = 1;
K = 4;

open_system('Lab3')
sim_out = sim('Lab3');

% Exponential
dx = 0.01;
x_vec = 0:dx:(10/a);
y_exp_vec = exppdf(x_vec,1/a);
sim_length = length(sim_out.sim_expo.Data);

y_exp_sim_vec = hist(sim_out.sim_expo.Data, x_vec);
figure
plot(x_vec, y_exp_vec)
hold on
plot(x_vec, y_exp_sim_vec/sim_length/dx)

% Uniform
x_vec = a:dx:b;
y_unif_sim_vec = hist(sim_out.sim_unif.Data, x_vec);
figure
plot(x_vec, y_unif_sim_vec/sim_length/dx)

% Pareto
x_vec = a1:dx:(10/a1);
y_pareto_vec = gppdf(x_vec,1/a1,1/a1,1);

y_pareto_sim_vec = hist(sim_out.sim_pareto.Data, x_vec);
figure
plot(x_vec, y_pareto_vec)
hold on
plot(x_vec, y_pareto_sim_vec/sim_length/dx)

% Weibull
x_vec = 0:dx:(10^(1/b)*a);
y_weib_vec = wblpdf(x_vec,a,b);

y_weib_sim_vec = hist(sim_out.sim_weib.Data, x_vec);
figure
plot(x_vec, y_weib_vec)
hold on
plot(x_vec, y_weib_sim_vec/sim_length/dx)

% Geometrical
x_vec = 0:100;
y_geom_vec = geopdf(x_vec,p);

y_geom_sim_vec = hist(sim_out.sim_geom.Data, x_vec);
figure
plot(x_vec, y_geom_vec);
hold on
plot(x_vec, y_geom_sim_vec/sim_length);

% Erlang
x_vec = 0:dx:(10/a);
y_erlang_vec = gampdf(x_vec, K, a);

y_erlang_sim_vec = hist(sim_out.sim_erlang.Data, x_vec);
figure
plot(x_vec, y_erlang_vec);
hold on
plot(x_vec, y_erlang_sim_vec/sim_length/dx);

% Laplace
x_vec = -(10/a):dx:(10/a);
y_laplace_vec = zeros(size(x_vec));
y_laplace_vec(x_vec >= 0) = 1/2 * exppdf(x_vec(x_vec >= 0),1/a);
y_laplace_vec(x_vec < 0) = 1/2 * exppdf(-x_vec(x_vec < 0),1/a);

y_laplace_sim_vec = hist(sim_out.sim_laplace.Data, x_vec);
figure
plot(x_vec,y_laplace_vec)
hold on
plot(x_vec, y_laplace_sim_vec/sim_length/dx)

% Gaussian
x_vec = (mu-5*sigma):dx:(mu+5*sigma);
y_gauss_pdf = normpdf(x_vec, mu, sigma);

y_gauss_sim_pdf = hist(sim_out.sim_normal.Data, x_vec);
figure
plot(x_vec,y_gauss_pdf)
hold on
plot(x_vec, y_gauss_sim_pdf/sim_length/dx)

% Poisson
x_vec = 0:100;
y_poiss_vec = poisspdf(x_vec, a);

y_poiss_sim_vec = hist(sim_out.sim_poiss.Data, x_vec);
figure
plot(x_vec, y_poiss_vec);
hold on
plot(x_vec, y_poiss_sim_vec/sim_length);

% Binomial
x_vec = 0:n;
y_bino_vec = binopdf(x_vec, n, p);

y_bino_sim_vec = hist(sim_out.sim_binomial.Data, x_vec);
figure
plot(x_vec, y_bino_vec);
hold on
plot(x_vec, y_bino_sim_vec/sim_length);

mG = 2;
open_system('MG1')
sim_out1 = sim('MG1');

