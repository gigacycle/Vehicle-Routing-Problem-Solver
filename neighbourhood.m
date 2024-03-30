function [swp, totalCost, timeLeft, qCount, cost]=neighbourhood(graph, depot, maxTime, Sweep, m, q, Q, T, C)
    g = graph;
    for i=1: min(size(Sweep,2),m)
        qCalc(i) = abs(q - Q(i));
    end
    %negah dashtane bakhshi az javab ke dar an vehicle kamtarin fazaye khali ra dashte-ast
    [minSpace, indx] = min(qCalc);
    swp{1} = Sweep{indx};
    qCount(1) = Q(indx);
    timeLeft(1)= T(indx);
    cost(1) = C(indx);
    for i=1:size(Sweep{indx},2)
        g = removeNode(g, Sweep{indx}(i), depot);
    end
    [tour, ~, qCount1, timeLeft1, cost1] = sweep(g, q, m-1, depot, maxTime);
    for i=1:size(tour,2)
        swp{i+1} = tour{i};
        qCount(i+1) = qCount1(i);
        timeLeft(i+1) = timeLeft1(i);
        cost(i+1) = cost1(i);
    end
    vCount = size(tour,2);
    totalCost = vCount*(sum(timeLeft)/sum(cost));
end