clc
clear

% Data

C = [10  30 6    1    20  8];
W = [0.5 1  0.33 0.1  1   0.5];
MaxW = 10;
MinQ = [2 2 6 10 1 2];

% Decision variables 
N = size(C,2);
x=optimvar('x',N,'Type', 'integer', 'LowerBound',0);

% Problem definition
Problem=optimproblem('ObjectiveSense', 'Maximize');

% Obj and constraints
Problem.Objective      =   C*x;
Problem.Constraints.w =   W*x <= MaxW;

for(i=1:N)
    WConstr(i) = x(i)>=MinQ(i);
end

Problem.Constraints.Wconstr = WConstr;

% Run the LP solver

[Sol fval exitflag]=solve(Problem,'solver','intlinprog');

% Print results
fval
exitflag
Sol.x
