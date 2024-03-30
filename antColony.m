clc;
clear;
%% Maghadire Avvalie
n = 10;  %teedade node-ha
m = 20;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 120; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo
%[swp, cost, T, Q, C] = sweep(g, q, m, d, maxTime); %ie-jade javabe jadid va mohasebe cost
dIndx = find([g.id]==d);  %makane feeli dar depo mibashad
i = dIndx;
Cost=[];
tm=[];
for k=1:n
    tic;
     for j=1:size(g(dIndx).relatedNodes,2)
         if (j<=size(g(i).relatedNodes,2))
             nodesMatrix(k,j) = g(i).relatedNodes(j);
              timesMatrix(k,j) = g(i).edgeTimes(j);
              costsMatrix(k,j) = g(i).edgeCost(j);
         else
             nodesMatrix(k,j) = 0;
              timesMatrix(k,j) = 0;
              costsMatrix(k,j) = 0;
         end
     end
     qVector(k) = g(i).Q;
     tVector(k) = g(i).T;
     if (i<n)
         i=i+1;
     else
         i=1;
     end
end
nNodes=size(nodesMatrix,2);
etha=1./(nodesMatrix+1);
tau0=1;
tau=tau0*ones(n,nNodes);
alpha=1;
beta=2;
rho=0.055;
nAnt=nNodes;
empty_ant=struct();
empty_ant.tour=[]; %masir
empty_ant.Q=0; %Majmoo-e Q-haye moshtari-ha 
empty_ant.T=0; %Time masir
empty_ant.C=0;%Hazineye masir
empty_ant.P=[];
empty_ant.sweep={};
empty_ant.swpQ=[];
empty_ant.swpT=[];
empty_ant.swpC=[];
empty_ant.visited=[];
empty_ant.Len = 0;
empty_ant.cost = 0;

max_it=100;
best_cost=inf;
%minCost.arrange = [];
%%
for t=1:max_it
        %% ersale moorche-ha (vasayele naghlie)
        % halgheye avval entekhabe avalin node pas az depo mibashad
        ant=repmat(empty_ant,nAnt,1);
        for k=1:nAnt
            ind = fix(1+rand*(size(g(dIndx).relatedNodes,2)-1));
            ant(k).tour = g(dIndx).relatedNodes(ind);
            ant(k).C = ant(k).C + g(dIndx).edgeCost(ind);
            ant(k).T = ant(k).T + g(dIndx).edgeTimes(ind);
            ind = find([g.id]==ant(k).tour); 
            ant(k).Q = ant(k).Q + g(ind).Q;
            ant(k).T = ant(k).T + g(ind).T;
            ant(k).visited = ant(k).tour;
            ant(k).Len = 1;
            currentNode(k) = ind;
        end
        cnt=1;
        while (cnt<=nAnt)
            for k=1:nAnt
                if (ant(k).Len >= n-1)
                    cnt=cnt+1;
                    continue;
                end
                N=setdiff(g(currentNode(k)).relatedNodes, ant(k).visited);
                if (size(N,2)<1)
                    break;
                end
                ant(k).P=zeros(1,size(N,2));
                %ii=i; %size(ant(k).tour,2);
                i = ant(k).Len;
                for j=1:numel(N)
                    %jj=N(j);
                    ant(k).P(j)=tau(i,j)^alpha*etha(i,j)^beta;
                end
                ant(k).P=ant(k).P/sum(ant(k).P);
                pSelect = SelectByP(ant(k).P);
                selected_node = N(pSelect);
                selected_index = find([g.id]==selected_node);
                if (selected_index == dIndx)             %dar soorate entekhabe depo harekat dar masir khateme miabad
                    ant(k).tour(end+1) = g(selected_index).id;
                    currentNode(k) = dIndx;
                    ant(k).sweep{end+1} = ant(k).Len;
                    ant(k).swpT(end+1) = ant(k).T; ant(k).T=0;
                    ant(k).swpC(end+1) = ant(k).C;ant(k).C=0;
                    ant(k).swpQ(end+1) = ant(k).Q;ant(k).Q=0;
                    continue;
                end
                ind = find([g(ant(k).tour(end)).relatedNodes]==selected_index);
                 if ((ant(k).Q+g(selected_index).Q<q) && (ant(k).T+g(ant(k).tour(end)).edgeTimes(ind)+g(selected_index).T <maxTime)) %check kardane sharte zarfiat va zaman
                    ant(k).tour(end+1) = g(selected_index).id;
                    currentNode(k) = selected_index;
                    ant(k).Q = ant(k).Q + g(selected_index).Q;
                    ant(k).T = ant(k).T + g(selected_index).T;
                    ind = find([g.id]==ant(k).tour(end-1));
                    if (ind ~= dIndx)
                        indx = find([g(ind).relatedNodes]==ant(k).tour(end));
                        ant(k).C = ant(k).C + g(ind).edgeCost(indx);
                        ant(k).T = ant(k).T + g(ind).edgeTimes(indx);
                    end
                    ant(k).Len = ant(k).Len+1;
                    ant(k).visited(end+1) = ant(k).tour(end);
                 else
                    ant(k).tour(end+1) = g(dIndx).id;
                    currentNode(k) = dIndx;
                    ant(k).sweep{end+1} = ant(k).Len;
                    ant(k).swpT(end+1) = ant(k).T; ant(k).T=0;
                    ant(k).swpC(end+1) = ant(k).C; ant(k).C=0;
                    ant(k).swpQ(end+1) = ant(k).Q; ant(k).Q=0;
                    continue;
                 end
            end
        end
    for k=1:nAnt    %mohasebeye hazineha va taghierate pheromon
        if (ant(k).tour(end)~=g(dIndx).id)
            nVehicles = size(ant(k).sweep,2)+1;
            ant(k).swpT(end+1) = ant(k).T; 
            ant(k).swpC(end+1) = ant(k).C;
        else
            nVehicles = size(ant(k).sweep,2);
        end
        ant(k).cost=nVehicles*(sum(ant(k).swpT)/sum(ant(k).swpC));
        set=[];
        for j=1:size(ant(k).tour,2)
            if (ant(k).tour(j)~=g(dIndx).id)
               set(end+1) = ant(k).tour(j);
            end
        end
        for i=1:size(set,2)
            ii=set(i);
            if i<size(set,2)
                jj=set(i+1);
            else
                jj=set(1);
            end
            tau(ii,jj)=tau(ii,jj)+(1/ant(k).cost);
            tau(jj,ii)=tau(ii,jj);
        end
    end
    tau=(1-rho)*tau;
    [minCost.cost index] = min([ant.cost]);
    if (minCost.cost<best_cost)
        best_cost = minCost.cost;
        minCost.nVehicle = size(ant(index).sweep,2);
        bestSweep = ant(index).sweep;
    end
    Cost(end+1) = best_cost;
    disp(['Tekrar ' num2str(t) ') tedade vasayele naghlie : ' num2str(minCost.nVehicle) ' - hazine kol = ' num2str(best_cost)]);
    tm(end+1) = toc;
end
plot(Cost);
drawGraph(g);
figure;
plot(tm);