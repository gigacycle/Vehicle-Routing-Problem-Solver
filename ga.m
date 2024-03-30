clc;
clear;
%% Maghadire Avvalie
n = 10;  %teedade node-ha
m = 300;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 120; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo

popCount = 10;

maxIt = 100;
jamiat = cell(popCount,2); 

for i=1:10 %taarife jamiate avvalie
    [jamiat{i,1}, jamiat{i,2}, ~, ~, ~] = sweep(g, q, m, d, maxTime); %ie-jade javab va cost-e jadid
end

% morattab sazi bar hasbe cost jamiat
jamiat = sortrows(jamiat, 2);

%entekhabe valedein (2 valed mojood dar sadre liste jamiat)
valed1 = jamiat{1,1};
valed2 = jamiat{2,1};
Cost(1) = jamiat{1,2};
bestCost = Cost(1);
minCost = bestCost;
farzandan = cell(4,2);
tm=[];
%%
for It=1:maxIt
    tic;
     farzandan = crossOver(valed1, valed2, d, g, maxTime, q);
     for i=1:size(farzandan,1)
         [farzandan{i,1}, farzandan{i,2}] = mutation(farzandan{i,1}, d, g, maxTime, q);
     end
     
     % morattab sazi bar hasbe cost farzandan
     farzandan = sortrows(farzandan, 2);
     Cost(It) = farzandan{1,2};
     if (bestCost > Cost(It))
        bestCost = Cost(It);
        minCost(end + 1) = bestCost;
        bestAnswer = farzandan{1,1};
     end
     
     %entekhabe valedein (2 valed mojood dar sadre liste farzandan)
     valed1 = farzandan{1,1};
     valed2 = farzandan{2,1};
     display(['Tekrar : ' num2str(It) ') behtarin hazine : ' num2str(bestCost)]);
     tm(end+1) = toc;
     pause(0.001);
end
for i=1:size(bestAnswer,2)
    display(['masire vasileye naghliyeye ' num2str(i) ') : ' num2str(bestAnswer{i})]);
end
drawGraph(g);
figure;
plot(minCost, 'color', 'b');
figure;
plot(tm);