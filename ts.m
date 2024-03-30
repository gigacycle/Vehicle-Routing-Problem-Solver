clc;
clear;
%% Maghadire Avvalie
n = 10;  %teedade node-ha
m = 20;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 1200; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo
[swp, cost, T, Q, C] = sweep(g, q, m, d, maxTime); %ie-jade javabe jadid va mohasebe cost

bestSweep = swp;
bestCost = cost;
Cost=[];
tabu = {};
maxIt = 5;
tm=[];
%% halgheye asli
for It=1:maxIt
    tic;
    j=1;
    while (j <= 4)
        [neighbours{j}, nCost(j), ~, ~, ~]= neighbourhood(g, d, maxTime, swp, m, q, Q, T, C);
        if (~existInTabu(tabu, neighbours(j)))
            j=j+1;
        end
    end
    [minCostNeighbour, indx] = min(nCost);
    cost(It) = minCostNeighbour;
    %swp = neighbours{indx};
    if (cost(It) < bestCost)
        tabu{end+1} = swp;
        bestSweep = swp;
        bestCost = cost(It);
    end
    Cost(end+1) = bestCost;
    display([num2str(It) ') tedade vasayele naghlie : ' num2str(size(bestSweep,2)) ' ba hazineye kolle : '  num2str(bestCost)]);
    tm(end+1) = toc;
end
for i=1:size(bestSweep,2)
    display(['masire ' num2str(i) ') ' num2str(bestSweep{i})]);
end
plot(Cost);
drawGraph(g);
figure;
plot(tm);