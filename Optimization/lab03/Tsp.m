
clear
clc

N_cities = 10;
[cities, distances] = create_tsp(N_cities,1);

shortestPathEdges = [1 2;
                     2 3;
                     3 4;
                     4 5;
                     5 6;
                     6 7;
                     7 8;
                     8 9;
                     9 10;
                     10 1];

Obj = 0;
for i=1:N_cities
    Obj = Obj + distances(shortestPathEdges(i,1),shortestPathEdges(i,2))
end

draw_tsp(cities, shortestPathEdges, Obj);










