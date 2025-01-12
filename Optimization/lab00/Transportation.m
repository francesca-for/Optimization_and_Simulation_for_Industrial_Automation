%% Transportation problem
%% T sources, S destinations
%% Quantity of products Avail(i) ready at source i
%% Quantity of products Demand(i) requested by dest. i
%% Cost matrix: C(i,j) is the unitary transportation cost i->j
%% Minimize the total transportation cost.

%% NOTE: actually, using PL for a transportation is inefficient.
%% Transportation can be solved in pseudopolynomial time
%% with an adapted simplex algorithm proposed by Dantzig.

clc
clear

C=[20 25 15 5;
   12 14 18 30;
   19 11 40 12;
   ]; 

Demand=[100000 150000 50000 70000];
Avail =[125000; 180000; 70000];

[T S] = size(C); % Numero di centri di smistamento e tipografie.

% Binary decision variable 
x=optimvar('x',T,S,'LowerBound',0);

% Obj is the total cost
obj = sum(sum(C.*x));

%Define optimization problem
TProblem=optimproblem;

% Define objective
TProblem.Objective=obj;

%Constraints
CAvail = x*ones(S,1) <= Avail;
CDemand = ones(1,T)*x >= Demand;
   
%************Define Problem Constraints***********************************
TProblem.Constraints.CAvail=CAvail;
TProblem.Constraints.CDemand=CDemand;

% Run the LP solver

[Sol fval exitflag]=solve(TProblem,'solver','intlinprog');

% Retrieve results.

exitflag
fval
Sol.x
