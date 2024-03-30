function [ tour, Cost, QCount, timeLeft ] = newTour(graph, depot, q, maxTime)
    n = size(graph,2); validate = 0;
    depot = find([graph.id] == depot);
    It = 1;
    maxIt = 250;
    while (~validate)   %halgheye asli ta zamani ke javabe sahih yaft nashavad tekrar mishavad
        i=1;                 %shomarandeye halgheye dakheli
        QCount = 0;     %zarfiat haye eshghal shode dar har dor
        status = depot; %shomareye node depo
        tour = [];           %node haye peymoode shode
        indx = fix(1 + rand * (size(graph(status).relatedNodes,2)-1)); %randint(1,1,[1 size(graph(status).relatedNodes,2)]);
        tour(1) = graph(status).relatedNodes(indx);
        gIndx = find([graph.id] == tour(1));
        Cost = graph(status).edgeCost(indx);
        timeLeft = graph(status).edgeTimes(indx);
        timeLeft = timeLeft + graph(gIndx).T;
        QCount = QCount + graph(gIndx).Q;
        status = gIndx;
        while (i<=n)
            i = i + 1;
            nodes = [graph(status).relatedNodes];
            times = [graph(status).edgeTimes];
            cost = [graph(status).edgeCost];
            for k=1:size(tour,2)
                indx =  find(nodes == tour(k));
                nodes(indx) = [];
                times(indx) = [];
                cost(indx) = [];
            end
            if (size(nodes,2)<1)
                break;
            end
            %% Check kardane node ya nod haye baadi baraye harekat be samte jolo 
            possibleNodes = [];
            for k=1:size(nodes,2)
                nId = find([graph.id] == nodes(k));
                nextNode = graph(nId);
                if (graph(depot).id == nextNode.id) 
                    continue;
                end
                if (((q - QCount) > nextNode.Q) && (timeLeft+nextNode.T+times(k) < maxTime))
                   possibleNodes(end+1) = nextNode.id;
                end
            end
            %% dar soorate momken naboodan harekat be node baadi, be depo bargard
            if (size(possibleNodes,2) < 1)      
                indx = find(nodes==graph(depot).id);
                if (size(indx,2)>0)
                    gIndx = find([graph.id] == nodes(indx));
                    tour(i) = graph(gIndx).id;
                end
                break;
            %% dar gheyre in soorat yeki az node-haye momken ra be tore tasadofi entekhab kon
            else
                indx =  fix(1 + rand * (size(possibleNodes,2)));%randint(1,1,[1 size(possibleNodes,2)]);
                gIndx = find([graph.id] == nodes(indx));
                tour(i) = graph(gIndx).id;
                Cost = Cost + cost(indx);
                timeLeft = timeLeft + times(indx);
                timeLeft = timeLeft + graph(gIndx).T;
                QCount = QCount + graph(gIndx).Q;
            end
            status = gIndx;
        end
        if ((q >= QCount) && (timeLeft<maxTime) && (tour(end) == graph(depot).id))
            validate = 1;
        else
            It = It + 1;
            if (It >= maxIt)
                break;
            end
        end
    end
end