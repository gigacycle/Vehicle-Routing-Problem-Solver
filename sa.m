clc;
clear;
%% Maghadire Avvalie
n = 10;  %teedade node-ha
m = 20;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 120; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo
[swp, cost, T, Q, C] = sweep(g, q, m, d, maxTime); %ie-jade javabe jadid va mohasebe cost

Cost(1) = cost;
Sweep{1} =swp;
bestState.sweep = swp;
bestState.cost = Cost(1);
Tem = 100;
maxCount = 100;
It = 1;
hold on;
tm=[];
while (It<=maxCount)
    tic;
    It = It +1;
    [Sweep{It}, Cost(It), T, Q, C]= neighbourhood(g, d, maxTime, Sweep{It-1}, m, q, Q, T, C);
    delta=Cost(It)-Cost(It-1);
    if delta<=0
        bestState.sweep=Sweep{It};
        bestState.cost = Cost(It);
    else
        p=exp(-delta/Tem);
        if rand<p
            bestState.sweep=Sweep{It};
            bestState.cost = Cost(It);
        end
    end
    
    Tem=Tem*0.8;
    
    display([num2str(It-1), ') tedade vasayele naghlie : ' num2str(size(bestState.sweep,2)) ' - hazineye kol : ' num2str(bestState.cost)]);
    tm(end+1) = toc;
    plot(It,Tem,'.');
end
hold off;
[bestCost,indx] = min(Cost);
display(['behtarin halat : ', num2str(size(Sweep{indx},2)), ' vasile ba hazineye kolle : ' , num2str(bestCost)]);
 for i=1:size(bestState.sweep,2)
    display(['masire ' num2str(i) ') ' num2str(Sweep{indx}{i})]);
 end
drawGraph(g);
figure;
plot(tm);