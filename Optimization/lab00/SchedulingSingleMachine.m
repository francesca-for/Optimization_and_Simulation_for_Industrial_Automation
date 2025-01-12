%% Solving the 1|r|SumC with MILP
%% - Single machine problem, N jobs
%% - Each job can start after its "release time" R(j)
%% - Each job requires a time P(j) on the machine
%% - The machine can process only one job at a time

clc
clear

P(1)=3; % Processing times
P(2)=2;    
P(3)=1;    
P(4)=8;  
P(5)=2;  
P(6)=3;  

R(1)=0; % Release times
R(2)=10;
R(3)=5;
R(4)=4;
R(5)=6;
R(6)=11;

N=size(P,2); % Number of machines / jobs.

% Completion times variables
% Name is C, dimension N, Type is continuous, Lower bound is 0.

C=optimvar('C',N,'Type','continuous','LowerBound',0); 


% OBJECTIVE FUNCTION TWO CHOICES
% FIRST: SUM(C)

 obj = sum(C);

% SECOND: MAX(C)
%{
Cmax=optimvar('Cmax','Type','continuous','LowerBound',0);
obj = Cmax;
for j=1:N
    CMaxDefinition(j)= Cmax >= C(j);
end
%}

% Release Time Constraint  
for j=1:N
    RelTime(j) = C(j) >= P(j) + R(j);
end
    
 % Define a binary decision variable for disj constraints
 x=optimvar('x',N,N,'Type','integer','LowerBound',0,'UpperBound',1);
     
 % Disjunctive constraints
BigM=50;   

for j=1:N 
    for i=1:N
        if not(i == j)
            D1(i,j)= C(j)-P(j)>=C(i)-BigM*(1-x(i,j));
            D2(i,j)= C(i)-P(i)>=C(j)-BigM*x(i,j);
        end
     end 
end 
   
% Define Problem Structure 

SingleMachineProblem=optimproblem;

SingleMachineProblem.Objective=obj; 

SingleMachineProblem.Constraints.RelTime=RelTime;
SingleMachineProblem.Constraints.D1=D1;
SingleMachineProblem.Constraints.D2=D2;
% UNCOMMENT FOR Cmax OBJ: SingleMachineProblem.Constraints.CMaxDefinition=CMaxDefinition;

% Run the LP solver

[Jobs fval]=solve(SingleMachineProblem,'solver','intlinprog');

% Retrieve results.

C=(Jobs.C);

if isempty(C)
    disp('Infeasible!');
end

% Plot Gantt Charts
% Note: if there are more than 14 jobs or machines, add colors

clf
M = 1; % machines    
Col = {'#0072BD','#D95319','#EDB120','#77AC30','#76BC60','#4DBEEE',...
    '#A2142F','#0062AD','#B93319','#CAB120','#87EC30','#77AC30',...
    '#4DBEEE','#A21C2F'}; 
  %*************************Jobs Vs Time Gantt Chart**********************

CMax = max(C(:));
Js = strcat('M',string(1:1:M));
figure(1)
subplot(212)
hold on
for n=1:N      %Jobs
    for m=1:M  %Machine
        xlim([0 CMax+2]);
        plot(C(n)-P(n):C(n),((N+1)-n)*ones(1,P(n)+1 ),...
        'LineWidth',12,'color',Col{m});
        text((2*C(n)-P(n))/2,((N+1)-n),Js(m),'FontSize', 8);
    end
end
Js = strcat('J',string(N:-1:1));
labelArray=Js;
tickLabels = strtrim(sprintf('%s\n', labelArray{:}));
ay = gca(); 
ay.YTick = 1:N; 
ay.YLim =  [0 N+1];
ay.YTickLabel = tickLabels;   
xticks(0:1:CMax+2)
title( 'Processing Time vs Jobs')
xlabel(' Time in min')
ylabel('Jobs')
grid
hold off
    
%*************************Machine Vs Time Gantt Chart****************** 
Js = strcat('J',string(1:1:N));
figure(1)
subplot(211)
hold off
hold on
for n=1:M
    for m=1:N
        xlim([0 CMax+2]);
        ylim([0 M+1]);
        plot(C(m)-P(m):C(m),((M+1)-n)*ones(1,P(m)+1),...
        'LineWidth',12,'color',Col{m});
        text((2*C(m)-P(m))/2,((M+1)-n),Js(m),'FontSize', 8);        
    end
end
Ms = strcat('M',string(M:-1:1));
labelArray = Ms;
tickLabels = strtrim(sprintf('%s\n', labelArray{:}));
ay = gca(); 
ay.YTick = 1:M; 
ay.YLim =  [0 M+1];
ay.YTickLabel = tickLabels; 

xticks(0:1:CMax+2)
grid
title( 'Processing time vs Machine')
xlabel(' Time in min')
ylabel('Machines')
hold off           