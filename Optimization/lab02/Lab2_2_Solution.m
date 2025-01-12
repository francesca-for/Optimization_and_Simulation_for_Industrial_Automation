%% Solving the P2|r|SumC with MILP

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

% Completion times, assignment and sequence variables
C=optimvar('C',N,'Type','continuous','LowerBound',0); 
x=optimvar('x',M,N,'Type','integer','LowerBound',0,'UpperBound',1);
y=optimvar('y',N,N,'Type','integer','LowerBound',0,'UpperBound',1);
    
%Define P2 as optimization problem
P2=optimproblem;
    
% Define objective
P2.Objective=sum(C);
    
% Release time Constraints  
for j=1:N
    for m=1:M
        RelTime(m,j) = C(j) >= x(m,j)*(P(m,j) + R(j));

    end
end

for j=1:N
    AssignConst(j) = sum(x(:,j)) == 1;
end

% Disjunction constraints
BigM=1000;   
    
    for m=1:M 
      for i=1:N 
        for j=i+1:N
                D1(m,i,j)= C(j)-P(m,j)>=C(i)-BigM*(1-y(i,j))-BigM*(1-x(m,j))-BigM*(1-x(m,i));
                D2(m,i,j)= C(i)-P(m,i)>=C(j)-BigM*y(i,j)-BigM*(1-x(m,j))-BigM*(1-x(m,i));
         end 
      end 
    end 
    
    %************Define Problem Constraints***********************************
      P2.Constraints.RelTime=RelTime;
      P2.Constraints.AssignConst=AssignConst;
      P2.Constraints.D1=D1;
      P2.Constraints.D2=D2;
    
    % Run the LP solver
    
    [Sol fval]=solve(P2,'solver','intlinprog');
    
    % Retrieve results.
    
    C=(Sol.C)
       