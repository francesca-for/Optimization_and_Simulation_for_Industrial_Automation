
clear
clc

N_cities = 15;
[cities, distances] = create_tsp(N_cities,1);

Algorithm = 1; % 1 = Model, 2 = NN heuristic

if (Algorithm == 1)
    
    % Binary decision variable 
    x=optimvar('x',N_cities,N_cities,'Type', 'integer', 'LowerBound',0, 'UpperBound', 1);
    t=optimvar('t',N_cities, 'LowerBound',0);
    
    % Obj is the total cost
    obj = sum(sum(distances.*x));
    
    %Define optimization problem
    TProblem=optimproblem;
    
    % Define objective
    TProblem.Objective=obj;
    
    %Constraints
    CAvail = x*ones(N_cities,1) == 1;
    CDemand = ones(1,N_cities)*x == 1;
    
    for (i=2:N_cities)
        for (j=2:N_cities)
            CCycle(i,j) = t(i)-t(j)+N_cities*x(i,j)<= N_cities-1;
        end
    end
       
    %************Define Problem Constraints***********************************
    TProblem.Constraints.CAvail=CAvail;
    TProblem.Constraints.CDemand=CDemand;
    TProblem.Constraints.CCycle=CCycle;
    
    
    % Run the LP solver
    
    [Sol fval exitflag]=solve(TProblem,'solver','intlinprog');
    
    % Retrieve results.
    
    exitflag
    shortestPathLength = fval;
    Edges = 0;
    for i=1:N_cities
        for j=1:N_cities
            if (Sol.x(i,j) > 0)
                shortestPathEdges(Edges+1,1) = i;
                shortestPathEdges(Edges+1,2) = j;
                Edges = Edges + 1;
            end
        end
    end
else
    
    % Nearest Neighbor Heuristic

    shortestPathLength = realmax;
    
    for i = 1:N_cities
        
        distancesTmp = distances;
        for j=1:N_cities
            distancesTmp(j,j) = realmax;
        end
        
        startCity = i;
        Steps = 0;
        totalDistance = 0;
        
        currentCity = startCity; 
        
        for j = 1:N_cities-1
            
            [minDist,nextCity] = min(distancesTmp(:,currentCity));
            
            edges(Steps+1,1) = currentCity;
            edges(Steps+1,2) = nextCity;
            Steps = Steps + 1;
    
            totalDistance = totalDistance + distancesTmp(currentCity,nextCity);
            
            distancesTmp(currentCity,:) = realmax;
            
            currentCity = nextCity;
            
        end
        
        edges(Steps+1,1) = currentCity;
        edges(Steps+1,2) = startCity;
        totalDistance = totalDistance + distances(currentCity,startCity);
        
        disp(startCity)
        disp(totalDistance)

        if (totalDistance < shortestPathLength)
            shortestPathLength = totalDistance;
            shortestPathEdges = edges; 
        end 
    end
end    

draw_tsp(cities, shortestPathEdges, shortestPathLength);










