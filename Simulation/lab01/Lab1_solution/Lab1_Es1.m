clear 
close all
clc

k = 1;
c = 1;
m = 1;

x0 = 1;
v0 = 0;

A = 1;
f0 = 2*pi;

K1 = 1/2 - 1i/2/sqrt(3);
K2 = 1/2 + 1i/2/sqrt(3);

open_system('mass_spring_damper')

Ts = 0.1;
M = 5;

open_system('moving_average')