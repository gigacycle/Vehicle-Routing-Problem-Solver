n = 8;  %number of nodes
m = 20;  %vehicle count
q = 40;  %quantity of each vehicle
maxTime = 120; %maximum tour time
[g, d] = generateNewGraph(n, q, maxTime); % g : new graph | d = depot point
for i=1:n 
    display(['node# ' num2str(i) ' related to => ' num2str([g(i).relatedNodes]) '/']);
end
drawGraph(g);