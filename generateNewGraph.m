function [ output_graph, depot ] = generateNewGraph( n, q, maxTime)
%% ijade sakhtare graph
   empty_graph = struct();
       empty_graph.id = 0;
       empty_graph.Q = 0;
       empty_graph.T = 0;
       empty_graph.relatedNodes = [];
       empty_graph.edgeTimes = [];
       empty_graph.edgeCost = [];
   vehicleQ = q;  %Zarfiate Vasileye Naghlie
   graph(1:n) = empty_graph;
%% tolide graph
   for i=1:n
        graph(i).id = i;
        graph(i).Q = randint(1,1,[1 fix(vehicleQ/3)]);
        graph(i).T = randint(1,1,[1 fix(maxTime/3)]);
        selection = 1:n;
        selection(i) = [];
        for k=1:size(graph(i).relatedNodes,2)
            indx =  find(selection == graph(i).relatedNodes(k));
            selection(indx) = [];
        end
        for j=1 + size(graph(i).relatedNodes,2):n-1%fix(2 + rand * (n-3))
            indx = fix( 1 + rand * size(selection,2));
            time = randint(1,1,[1 fix(maxTime/3)]);
            cost = randint(1,1,[1 10]);
            graph(i).relatedNodes(j) = selection(indx);
            graph(i).edgeTimes(j) = time;
            graph(i).edgeCost(j) = cost;
            graph(selection(indx)).relatedNodes(size(graph(selection(indx)).relatedNodes,2)+1) = i;
            graph(selection(indx)).edgeTimes(size(graph(selection(indx)).edgeTimes,2)+1) = time;
            graph(selection(indx)).edgeCost(size(graph(selection(indx)).edgeCost,2)+1) = cost;
            selection(indx) = [];
        end
   end
   output_graph = graph;
   for i=1:n
        h{i} = find([graph.relatedNodes] == i);
         l(i) = size(h{i},2);
    end
    [~, indx] = sort(l);
    depot = indx(end);
end