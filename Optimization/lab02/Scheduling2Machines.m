%% Solving the F2|r|SumC with MILP

clc
clear

P(1,1)=72; P(2,1)=43;   % Processing times (machine,job)
P(1,2)=53;  P(2,2)=33;   
P(1,3)=97;  P(2,3)=23;   
P(1,4)=16;  P(2,4)=55; 
P(1,5)=24;  P(2,5)=38; 
P(1,6)=19;  P(2,6)=43; 

R(1)=14; % Release times
R(2)=190;
R(3)=120;
R(4)=169;
R(5)=96;
R(6)=37;

[M N]=size(P); % Number of machines / jobs.

