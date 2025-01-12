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

Algorithm = 3; % 1 = MODEL, 2 = Model with free sequence on M2, 3 = Heuristic

if (Algorithm < 3)

    % Completion times variables
    C=optimvar('C',M,N,'Type','continuous','LowerBound',0); 
    Cmax=optimvar('Cmax','Type','continuous','LowerBound',0 )
    
    %Define F2 as optimization problem
    F2=optimproblem;
    
    % Define objective
    F2.Objective=sum(C(2,:));
    
    %Problem Job Sequence Constraints  
    for j=1:N
        RelTime(j) = C(1,j) >= P(1,j) + R(j);
        OpSequence(j) = C(2,j) >= C(1,j) + P(2,j);
    end
        
     % Define a binary decision variable for disj constraints
     x=optimvar('x',M,N,N,'Type','integer','LowerBound',0,'UpperBound',1);
         
     % Disjunction constraints
    BigM=1000;   
    
    for m=1:M 
      for i=1:N 
        for j=i+1:N
                D1(m,i,j)= C(m,j)-P(m,j)>=C(m,i)-BigM*(1-x(m,i,j));
                D2(m,i,j)= C(m,i)-P(m,i)>=C(m,j)-BigM*x(m,i,j);
         end 
      end 
    end 
    
    %************Define Problem Constraints***********************************
      F2.Constraints.RelTime=RelTime;
      F2.Constraints.OpSequence=OpSequence;
      F2.Constraints.D1=D1;
      F2.Constraints.D2=D2;
    
    % "Permutation" constraint: is the second machine FIFO or Random Access?
    if (Algorithm == 1)
        for i=1:N 
          for j=i+1:N
            SameSequence(i,j) = x(1,i,j) == x(2,i,j);
          end
        end
        F2.Constraints.SameSequence = SameSequence;
    end
    
    % Run the LP solver
    
    [Jobs fval]=solve(F2,'solver','intlinprog');
    
    % Retrieve results.
    
    C=(Jobs.C);
else
    C = zeros(2,N);
    
    % SRPT implementation - M1
    currT = 0; finished = 0;
    while(finished == 0)
        MinP = 10000; MinI = 0;
        for i = 1:N
            if and(R(i) <= currT, C(1,i) == 0)
                if (P(1,i)+P(2,i) < MinP)
                  MinP = P(1,i)+P(2,i);
                  MinI = i;
                end
            end
        end
        
        if (MinI > 0)
            C(1,MinI) = currT + P(1,MinI);
            currT = C(1,MinI);
        else
           % check for the first unreleased job
           minRel = 10000;
           for i=1:N
               if and(R(i)>currT, R(i) < minRel)
               minRel = R(i);
               end
           end

           if (minRel == 10000)
               finished = 1;
           else
               currT = minRel;
            end
        end
    end

    % SRPT implementation - M2
    currT = 0; finished = 0;
    while(finished == 0)
        MinP = 10000; MinI = 0;
        for i = 1:N
            if and(C(1,i) <= currT, C(2,i) == 0)
                if (P(2,i) < MinP)
                  MinP = P(2,i);
                  MinI = i;
                end
            end
        end
        
        if (MinI > 0)
            C(2,MinI) = currT + P(2,MinI);
            currT = C(2,MinI);
        else
           % check for the first unreleased job from M1
           minRel = 10000;
           for i=1:N
               if and(C(1,i)>currT, C(1,i) < minRel)
               minRel = C(1,i);
               end
           end

           if (minRel == 10000)
               finished = 1;
           else
               currT = minRel;
            end
        end
    end

    fval = 0;
    for i=1:N
        fval = fval + C(2,i);
    end
end


if isempty(C)
    disp('Infeasible!');
else
    disp('Objective Function')
    disp(fval)
    % Plot Gantt Charts
    % Note: if there are more than 14 jobs or machines, add colors
    
    clf
    
    Col = {'#0072BD','#D95319','#EDB120','#77AC30','#76BC60','#4DBEEE',...
        '#A2142F','#0062AD','#B93319','#CAB120','#87EC30','#77AC30',...
        '#4DBEEE','#A21C2F'}; 
        
      %*************************Jobs Vs Time Gantt Chart**********************
    CMax = max(C(2,:));
    Js = strcat('M',string(1:1:M));
    figure(1)
    subplot(212)
    hold on
    for n=1:N      %Jobs
        for m=1:M  %Machine
            xlim([0 CMax+2]);
            plot(C(m,n)-P(m,n):C(m,n),((N+1)-n)*ones(1,P(m,n)+1 ),...
            'LineWidth',12,'color',Col{m});
            text((2*C(m,n)-P(m,n))/2,((N+1)-n),Js(m),'FontSize', 8);
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
            plot(C(n,m)-P(n,m):C(n,m),((M+1)-n)*ones(1,P(n,m)+1),...
            'LineWidth',12,'color',Col{m});
            text((2*C(n,m)-P(n,m))/2,((M+1)-n),Js(m),'FontSize', 8);        
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
end