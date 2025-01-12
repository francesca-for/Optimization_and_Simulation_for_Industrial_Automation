%% Example

clc
clear

% Decision variables 
x=optimvar('x',6,'Type', 'integer', 'LowerBound',0);

% Problem definition
Problem=optimproblem('ObjectiveSense', 'Maximize');

% Obj and constraints
Problem.Objective      =   10*x(1)+30*x(2)+6*x(3)+3*x(4)+20*x(5)+8*x(6);
Problem.Constraints.c1 =   0.5*x(1)+x(2)+0.33*x(3)+0.1*x(4)+x(5)+0.5*x(6) <= 10;
Problem.Constraints.c2 =   x(1)>=2;
Problem.Constraints.c3 =   x(2)>=2;
Problem.Constraints.c4 =   x(3)>=6;
Problem.Constraints.c5 =   x(4)>=10;
Problem.Constraints.c6 =   x(5)>=1;
Problem.Constraints.c7 =   x(6)>=2;
   
% Run the LP solver

[Sol fval exitflag]=solve(Problem,'solver','intlinprog');

% Print results
fval
exitflag
Sol.x
