function draw_tsp(cities, edges, obj)
    %% Draw the TSP solution
    % cities: two column matrix of type double with cities' coordinates
    % edges: two column matrix of the selected edges (from->to)

    N_cities = size(cities,1);

    figure
    x_min = min(cities(:,1)) - 3;
    x_max = max(cities(:,1)) + 3;
    y_min = min(cities(:,2)) - 3;
    y_max = max(cities(:,2)) + 3;
    plot(cities(:,1),cities(:,2),'bo');
    axis([x_min x_max y_min y_max]);
    axis equal;
    grid on;
    hold on;
    
    % plot path
    for i = 1:N_cities
        x(1)=cities(edges(i,1),1);
        y(1)=cities(edges(i,1),2);
        x(2)=cities(edges(i,2),1);
        y(2)=cities(edges(i,2),2);
        line(x,y,'Color','Black');
    end
 
    title(['Path length = ',num2str(obj)]);
    hold off;

end
