function [ farzandan ] = crossOver( valed1, valed2, depo, g, maxTime, q)
    % crossOver tabe-ie ast ke az valedeyne voroode 4 farzand be vojood miavarad
    % voroodi ha : valed1, valed2, depo, g  -  khorooji: farzandan
    %Rikhtane node-haye peymoode shode tavasote vasayele naghlie dar yek araye (valed 1)
    nodes1 = [];    
    for i=1:size(valed1,2)
        nodes1 = [nodes1 valed1{i}];
    end
    %hazfe depo az majmoo-eye node-haye peymoode shode
    [~, indx]= setdiff(nodes1, depo);
    indx = setdiff(1:size(nodes1,2), indx);
    for i=1:size(indx,2)
        nodes1(indx(i)-(i-1)) = [];
    end
    %Rikhtane node-haye peymoode shode tavasote vasayele naghlie dar yek araye (valed 2)
    nodes2 = [];
    for i=1:size(valed2,2)
        nodes2 = [nodes2 valed2{i}];
    end
    %hazfe depo az majmoo-eye node-haye peymoode shode
    [~, indx]= setdiff(nodes2, depo);
    indx = setdiff(1:size(nodes2,2), indx);
    for i=1:size(indx,2)
        nodes2(indx(i)-(i-1)) = [];
    end

    n = size(nodes1,2);
    crossPoint1= 1 + floor(rand * (n-1));
    crossPoint2= 1 + floor(rand * (n-1));
    % sakhtane farzandane 1,2 ba estefade az 2 valed va noghteye taghato-e 1
    expand_sweep1 = [nodes1(1:crossPoint1) nodes2(crossPoint1+1:end)];
    expand_sweep2 = [nodes2(1:crossPoint1) nodes1(crossPoint1+1:end)];
    % jologiri az tekrari shodane node-ha dar tarkibate jadid
    [expand_sweep1, expand_sweep2] = swapDuplicates(expand_sweep1, expand_sweep2, crossPoint1);
    % sakhtane farzandane 3,4 ba estefade az 2 valed va noghteye taghato-e 2
    expand_sweep3 = [nodes1(1:crossPoint2) nodes2(crossPoint2+1:end)];
    expand_sweep4 = [nodes2(1:crossPoint2) nodes1(crossPoint2+1:end)];
    % jologiri az tekrari shodane node-ha dar tarkibate jadid
    [expand_sweep3, expand_sweep4] = swapDuplicates(expand_sweep3, expand_sweep4, crossPoint2);

    
    [farzandan{1,1}, farzandan{1,2}] = makeSweep(g, expand_sweep1, q, maxTime, depo);
    [farzandan{2,1}, farzandan{2,2}] = makeSweep(g, expand_sweep2, q, maxTime, depo);
    [farzandan{3,1}, farzandan{3,2}] = makeSweep(g, expand_sweep3, q, maxTime, depo);
    [farzandan{4,1}, farzandan{4,2}] = makeSweep(g, expand_sweep4, q, maxTime, depo);
end

