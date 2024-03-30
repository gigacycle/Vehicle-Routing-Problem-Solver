function [ output, totalCost, timeLeft, qCount, cost] = sweep(graph,q, m, depot, maxTime)
% tabeye sweep majmoo-e ie az masirhaye peymoode shode tavasote vasayele
% naghlie ra bar migardanad zeman tedade vasayele naghlie niz dar an moshakhas khahad
% shod. khorooji-ha : output: sweep, totalCost: coste mohasebe shode baraye
% safar-haye vasayele naghlie, timeLeft: list zaman-haye separi shode
% baraye har vasileye naghlie, qCount: liste zarfiat-haye eshghal shode
% baraye har vasileye naghlie, cost: liste cost-haye masir baraye har khodro
% voroodi-ha: graph: graphe asli, q: zarfiate har vasile, m: maximum tedade
% vasayele naghlie, depot: depo, maxTime: maximum zamane mojaz baraye har
% vasileye naghlie
    g = graph;
    cnt = 1;
    while (size(g,2) > 1)
        if (cnt>m)
            break;
        end
        if (size(g(1).relatedNodes,2)>0)
            [tour{cnt}, cost(cnt), qCount(cnt), timeLeft(cnt)] = newTour(g, depot, q, maxTime);
            for i=1:size(tour{cnt},2)-1
                g = removeNode(g, tour{cnt}(i), depot);
            end
        else  %
            tour{cnt} = -1;
            cost(cnt) = 100;
            qCount(cnt) = 100;
            timeLeft(cnt) = 100;
            break;
        end
        cnt = cnt+1;
    end
%% Mohasebeye coste nahaie
    vCount = cnt; %tedade vasayele naghlie
    totalCost = vCount*(sum(timeLeft)/sum(cost));
    output = tour;
end

