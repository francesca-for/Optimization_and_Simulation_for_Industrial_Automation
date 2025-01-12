% In order to use gurobi, uncomment the following two commands
% checking the path of your Gurobi installation  
% Every time you restart Matlab, the path is reset to its original state.
% Use "savepath" if you with to make the change permanent.

%addpath(fullfile('C:\gurobi1103', 'win64', 'examples', 'matlab'));
%addpath(fullfile('C:\gurobi1103', 'win64', 'matlab'));

% ----------------------------------------

% Set covering problem: select the minimal 
% number of rows of M having at least one 
% "1" for each column.

M=[1 0 0 1 0 0 0;
   0 0 1 0 1 0 1;
   0 1 0 0 1 0 1;
   1 0 0 1 0 1 0;
   0 1 1 0 0 1 0;
   ];

[N N] = size(M); 

% Binary decision variable 
x=optimvar('x',N,1,'Type','integer','LowerBound',0,'UpperBound',1);

% Obj is the number of covered columns
obj = sum(x);

%Define optimization problem
WarehouseProblem=optimproblem;
WarehouseProblem.Objective=obj;

%Constraints
Cover = M*x >= 1;
WarehouseProblem.Constraints.Cover=Cover;

% Run the LP solver

[Sol, fval, exitflag]=solve(WarehouseProblem,'solver','intlinprog');

% Retrieve results.

exitflag
fval

x=(Sol.x);
if isempty(x)
    disp('Infeasible!');
end
x
