function [ newGraph ] = removeNode( graph, nodeNumber, depot )
% Hazfe yek node az Graph va Hefze Node Depo
    cnt = 1;
%% bedast avardane node depo va zakhireye 
    indx =  find([graph.id] == depot);   
    newGraph(1) = graph(indx);
    indx =  find([graph(indx).relatedNodes] == nodeNumber);
%% hazfe yalha-ie az depo ke be node hazfi mottesl ast
    if (size(indx,2)>0)
        newGraph(1).relatedNodes(indx) = [];
        newGraph(1).edgeTimes(indx) = [];
        newGraph(1).edgeCost(indx) = [];
    end
%% Zakhire kardane tamame node ha be joz nodi ke ghara ast hazf shavad
    for i=1:size(graph,2)
        if (graph(i).id ~= depot)
            indx =  find([graph(i).relatedNodes] == nodeNumber);
            if (size(indx,2)>0) % hazfe relation haie ke be on node khatm mishavad
                graph(i).relatedNodes(indx) = [];
                graph(i).edgeTimes(indx) = [];
                graph(i).edgeCost(indx) = [];
            end
            if (graph(i).id ~= nodeNumber)
                cnt=cnt+1;
                newGraph(cnt) = graph(i);
            end
        end
    end
end