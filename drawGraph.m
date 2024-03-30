function [] = drawGraph(graph)
    n = size(graph,2);
    nodesPos=zeros(n,2);
    for i=1:n
        h{i} = find([graph.relatedNodes] == i);
         l(i) = size(h{i},2);
    end
    [~, indx] = sort(l);
    figure;
    hold on;
    axis off;
    fontSize = 10 + (10 * (5/n));
    radius = 20;
    cx=radius+10;cy=radius+10;
    plot(cx,cy,'O','color','black');
    text(cx+1,cy,['n' num2str(indx(end))], 'FontSize',fontSize);
    nodesPos(indx(n),1) = cx;
    nodesPos(indx(n),2) = cy;
    for i = 1:n-1
        x = cx+(radius*sin((360/(n-1)*i)*pi/180));
        y = cy+(radius*cos((360/(n-1)*i)*pi/180));
        nodesPos(indx(i),1) = x;
        nodesPos(indx(i),2) = y;
        plot(x,y,'O','color','black');
        text(x+1,y,['n' num2str(indx(i))],'FontSize',fontSize);
    end
    for i=1:n
        for j=1:size(graph(i).relatedNodes,2)
            dest = graph(i).relatedNodes(j);
            x1 = nodesPos(i,1);
            y1 = nodesPos(i,2);
            x2 = nodesPos(dest,1);
            y2 = nodesPos(dest,2);
            plot([x1 x2], [y1 y2],'black');
            tx = (x1+x2)/2 - 0.5;
            ty = (y1+y2)/2;
            cx = tx;
            cy = ty - 1;
            text(tx,ty,['t=' num2str(graph(i).edgeTimes(j)) 'm'],'FontSize',fontSize/2, 'color', 'r');
            text(cx,cy,['c=' num2str(graph(i).edgeCost(j))],'FontSize',fontSize/2, 'color', 'b');
        end
    end
    hold off;
end