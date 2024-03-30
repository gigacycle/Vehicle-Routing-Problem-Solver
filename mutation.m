function [ farzand, cost ] = mutation( input, depo, g, maxTime, q)
    %tabeye ei-jade jaheshe genetic
    %Rikhtane node-haye peymoode shode tavasote vasayele naghlie dar yek araye (input)
    nodes = [];
    for i=1:size(input,2)
        nodes = [nodes input{i}];
    end
    %hazfe depo az majmoo-eye node-haye peymoode shode
    [~, indx]= setdiff(nodes, depo);
    indx = setdiff(1:size(nodes,2), indx);
    for i=1:size(indx,2)
        nodes(indx(i)-(i-1)) = [];
    end

    mp1 = fix(1 + rand * (size(nodes,2)-1));
    mp2 = fix(1 + rand * (size(nodes,2)-1));
    tmp = nodes(mp1);
    nodes(mp1) = nodes(mp2);
    nodes(mp2) = tmp;
    
    [farzand, cost] = makeSweep(g, nodes, q, maxTime, depo);
end

