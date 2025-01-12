clear
close all
clc

mG = 2;
mS = 1;
K = 5;
m = 20;

open_system('Queueing_system')
sim("Queueing_system.slx")