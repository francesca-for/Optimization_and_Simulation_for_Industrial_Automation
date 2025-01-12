clc
clear

%To use Gurobi uncomment (after checking your gurobi path)
%addpath(fullfile('C:\gurobi1103', 'win64', 'examples', 'matlab'));
%addpath(fullfile('C:\gurobi1103', 'win64', 'matlab'));

P = [ 22 13 17 16 24 19 31 78 37 39 53 82 77 44 92 15 17 30 16 21 10 23 43 52 34];
R = [ 654 756 222 162 364 888 325 5 347 357 864 10 100 469 856 517 72 993 430 593 885 810 802 415 116];

N=size(P,2); % Number of machines / jobs.

Model = 1;

if (Model == 1)

    % Completion Times Variables
    C=optimvar('C',N,'Type','continuous','LowerBound',0); 
    
    obj = sum(C);
    
    % Release Time Constraint  
    for j=1:N
        RelTime(j) = C(j) >= P(j) + R(j);
    end
        
     % Define a binary decision variable for disj constraints
     x=optimvar('x',N,N,'Type','integer','LowerBound',0,'UpperBound',1);
         
     % Disjunctive constraints (for every different two jobs)
    BigM=1200;   
    
    for j=1:N 
        for i=j+1:N
                D1(i,j)= C(j)-P(j)>=C(i)-BigM*(1-x(i,j));
                D2(i,j)= C(i)-P(i)>=C(j)-BigM*x(i,j);
         end 
    end 
       
    % Define Problem Structure 
    
    SingleMachineProblem=optimproblem;
    SingleMachineProblem.Objective=obj; 
    SingleMachineProblem.Constraints.RelTime=RelTime;
    SingleMachineProblem.Constraints.D1=D1;
    SingleMachineProblem.Constraints.D2=D2;

else

    % Variables
    C=optimvar('C',N,'Type','continuous','LowerBound',0); 
    x=optimvar('x',N,N,'Type','integer','LowerBound',0,'UpperBound',1);
    
    obj = sum(C);
    
    % Assignment constraints
    Assignment1 = sum(x,2) == 1;
    Assignment2 = sum(x) == 1;
    
    % Release Time Constraint

    RelTime1 = C(1) == (P+R)*x(:,1);

    for j=2:N
        RelTime(j) = C(j) >= (P+R)*x(:,j);
    end
    
    % Non overlapping constraint
    for j=2:N
        Sequence(j) = C(j) >= C(j-1) + P*x(:,j);
    end
       
    % Define Problem Structure 
    
    SingleMachineProblem=optimproblem;
    SingleMachineProblem.Objective=obj;
    SingleMachineProblem.Constraints.Assignment1=Assignment1;
    SingleMachineProblem.Constraints.Assignment2=Assignment2;    
    SingleMachineProblem.Constraints.RelTime1=RelTime1;
    SingleMachineProblem.Constraints.RelTime=RelTime;
    SingleMachineProblem.Constraints.Sequence=Sequence;

end

% Run the LP solver

[Jobs fval]=solve(SingleMachineProblem,'solver','intlinprog');

disp('Objective function')
disp(fval)

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