%% Warehouses problem

clc
clear

M = sparse(20,20);
M(1, 1)= 1; M(1, 2)= 1; M(1, 12)= 1; M(1, 16)= 1
M(2, 2)= 1; M(2, 3)= 1; M(2, 1)= 1; M(2, 12)= 1
M(3, 3)= 1; M(3, 4)= 1; M(3, 9)= 1; M(3, 10)= 1; M(3, 13)= 1; M(3, 12)= 1; M(3, 2)= 1
M(4, 4)= 1; M(4, 5)= 1; M(4, 7)= 1; M(4, 9)= 1; M(4, 3)= 1
M(5, 5)= 1; M(5, 6)= 1; M(5, 7)= 1; M(5, 4)= 1;	
M(6, 6)= 1; M(6, 17)= 1; M(6, 7)= 1; M(6, 5)= 1;
M(7, 7)= 1; M(7, 4)= 1; M(7, 5)= 1; M(7, 6)= 1; M(7, 17)= 1; M(7, 18)= 1; M(7, 8)= 1; M(7, 9)= 1;
M(8, 8)= 1; M(8, 7)= 1; M(8, 18)= 1; M(8, 11)= 1; M(8, 10)= 1; M(8, 9)= 1; 
M(9, 9)= 1; M(9, 4)= 1; M(9, 7)= 1; M(9, 8)= 1; M(9, 10)= 1; M(9, 3)= 1;
M(10, 10)= 1; M(10, 3)= 1; M(10, 9)= 1; M(10, 8)= 1; M(10, 11)= 1; M(10, 13)= 1; M(10, 12)= 1;
M(11, 11)= 1; M(11, 8)= 1; M(11, 18)= 1; M(11, 19)= 1; M(11, 20)= 1; M(11, 14)= 1; M(11, 15)= 1; M(11, 13)= 1; M(11, 10)= 1;
M(12, 12)= 1; M(12, 2)= 1; M(12, 3)= 1; M(12, 10)= 1; M(12, 13)= 1; M(12, 16)= 1; M(12, 1)= 1;
M(13, 13)= 1; M(13, 12)= 1; M(13, 3)= 1; M(13, 10)= 1; M(13, 11)= 1; M(13, 15)= 1; M(13, 16)= 1;
M(14, 14)= 1; M(14, 15)= 1; M(14, 11)= 1; M(14, 20)= 1;
M(15, 15)= 1; M(15, 16)= 1; M(15, 13)= 1; M(15, 11)= 1; M(15, 14)= 1;
M(16, 16)= 1; M(16, 1)= 1; M(16, 12)= 1; M(16, 13)= 1; M(16, 15)= 1;
M(17, 17)= 1; M(17, 6)= 1; M(17, 7)= 1; M(17, 18)= 1;
M(18, 18)= 1; M(18, 17)= 1; M(18, 7)= 1; M(18, 8)= 1; M(18, 11)= 1; M(18, 19)= 1;
M(19, 19)= 1; M(19, 18)= 1; M(19, 11)= 1; M(19, 20)= 1;
M(20, 20)= 1; M(20, 19)= 1; M(20, 11)= 1; M(20, 14)= 1;

Cost=[15 9 15 15 25 19 34 39 15 15 25 25 29 25 25 49 39 34 15 15];

[N, N] = size(M); % Number of districts.

Model = 1; % MODEL 1 = Question 2 (minimal number of warehouses)
           % MODEL 2 = Question 3a (Max budget)
           % MODEL 3 = Question 3b (Max covered districts)


% Binary decision variable (y is used in model 3 only)
x=optimvar('x',N,1,'Type','integer','LowerBound',0,'UpperBound',1);
y=optimvar('y',N,1,'Type','integer','LowerBound',0,'UpperBound',1);

% Models
switch Model 
    case 1
        WarehouseProblem=optimproblem('ObjectiveSense','minimize');
        obj = sum(x);
        Cover = M*x >= 1;
    case 2
        WarehouseProblem=optimproblem('ObjectiveSense','minimize');
        obj = Cost*x;
        Cover = M*x >= 1;
        Maxcost = Cost*x <= 55;
    case 3
        WarehouseProblem=optimproblem('ObjectiveSense','maximize');
        obj = sum(y);
        Cover = M*x >= y;
        Maxcost = Cost*x <= 55;
        % Note: Alternative 1 by 1 Cover constraints implementation
        % for i = 1:N
        %    Expr = 0;
        %    for j = 1:N
        %        if M(i,j)==1
        %            Expr = Expr + x(j);
        %        end
        %    end
        %    Cover(i) = Expr >= y(i);
        % end
end


%************ Setup the model *********************************
WarehouseProblem.Objective=obj;
WarehouseProblem.Constraints.Cover=Cover;
if Model > 1
    WarehouseProblem.Constraints.Maxcost=Maxcost;
end

% Run the LP solver

[Sol, fval]=solve(WarehouseProblem,'solver','intlinprog');

% Retrieve results.

x=(Sol.x);
if Model == 3
    y=(Sol.y);
end

if isempty(x)
    disp('Infeasible!');
else
    disp('Opened Warehouses:')
    for i=1:N
        if x(i)==1
         disp(i)
        end
    end

    if (Model == 3)
        disp('Non covered districts:')
        for i=1:N
            if y(i)==0
             disp(i)
            end
        end
    end
    disp('Objective Function value:')
    disp(fval)
end

