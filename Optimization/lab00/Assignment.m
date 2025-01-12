%% Assignment problem

clc
clear

C=[20 25 15 5;
   12 14 18 30;
   19 11 40 12;
   20 10 15 23;
   ]; 


[N N] = size(C); % matrix dimension (must be square).

% Binary decision variable 
x=optimvar('x',N,N,'Type', 'integer', 'LowerBound',0, 'UpperBound', 1);

% Objective function (two alternative implementations)  

%FIRST
%{
obj = sum(sum(C.*x));
%}
%%{
obj = 0;
for(i=1:N)
    for(j=1:N)
        obj = obj + C(i,j)*x(i,j);
    end
end
%}

%Define optimization problem
TProblem=optimproblem;

% Define objective
TProblem.Objective=obj;

%Constraints (three alternative equivalent implementation)

% FIRST
%{
  TProblem.Constraints.CAvail  = x*ones(N,1) == 1;
  TProblem.Constraints.CDemand = ones(1,N)*x == 1;
%}

% SECOND
%{
  TProblem.Constraints.CAvail  = sum(x,2) == 1;
  TProblem.Constraints.CDemand = sum(x) == 1;
%}

% THIRD
%%{

for(i=1:N)
    expr = 0;
    for(j=1:N)
        expr = expr + x(i,j);
    end
    CAvail(i) = expr == 1;
end
for(j=1:N)
    expr = 0;
    for(i=1:N)
        expr = expr + x(i,j);
    end
    CDemand(j) = expr == 1;
end

TProblem.Constraints.CAvail = CAvail;
TProblem.Constraints.CDemand = CDemand;
%}


% Run the LP solver

[Sol, fval, exitflag] = solve(TProblem,'solver','intlinprog');

% Retrieve results.

exitflag
fval
Sol.x
