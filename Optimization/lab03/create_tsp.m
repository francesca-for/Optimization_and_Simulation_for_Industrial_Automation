
function [cities, distances] = create_tsp(N_Cities, seed)
% Create a random map with N_cities using seed to init random numbers
% cities: two column matrix of type double with cities' coordinates
% distances: matrix with distances between each couple of cities
    rng(seed);

    cities = 100*rand(N_Cities,2);
    
    N_cities = size(cities,1);
    
    distances = pdist(cities);
    distances = squareform(distances);
end
