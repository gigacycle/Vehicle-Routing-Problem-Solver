clc;
clear;
%% Maghadire Avvalie
n = 10;  %teedade node-ha
m = 20;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 120; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo


nZanboor = 200;
maxCount = 100;

solution=struct();
solution.id=0;
solution.sweep = {};
solution.expand_sweep = [];
solution.cost=inf;

zanboor(1:nZanboor) = solution;
nPishro = ceil(nZanboor/20);
Pishro(1:nPishro) = solution;
javab = solution;

tm=[];
for cnt=1:maxCount
    tic;
    if (cnt==1)
        % harekat be samte shahde gol
        for i=1:nZanboor
            area = 1:n;
            for j=1:n
                if (j==d)
                    continue;
                end
                indx = fix(1+rand*(size(area,2) - 1)); 
                zanboor(i).expand_sweep(end+1) = area(indx);
                area(indx) = [];
            end
            [zanboor(i).sweep, zanboor(i).cost] = makeSweep(g,zanboor(i).expand_sweep,q,maxTime,d);
            zanboor(i).id=i;
        end
        % bargashtane zanboorha be kandoo
        %moratab sazi bar hasbe barazandegi
        tempCost(:,1) = [zanboor.id];
        tempCost(:,2) = [zanboor.cost];
        tempCost = sortrows(tempCost, 2);
        if (javab.cost > tempCost(1,2))
            javab = zanboor(tempCost(1,1));
        end
        for i=1:size(Pishro,2)  %entekhabe zanboore pishro
            Pishro(i) = zanboor(tempCost(i,1));
        end
    else
        % harekat be samte shahde gol
        for i=1:nZanboor
            fnd = find([Pishro.id]==i);
            if (size(fnd,2)>0)
                continue;
            end
            zanboor(i) = solution;
            follow = 1;
            indx = fix(1+rand*(size(Pishro,2)-1)); %entekhabe zanboore pishro
            pishro = Pishro(indx);
            p = 1/(pishro.cost+0.01);
            if (rand>p)
                follow=0;
            end
            for j=1:n
                if (j==d)
                    continue;
                end
                if (~follow) %entekhabe rahe pishro ya yek rahe jadid (zanboorhaye gheyre pishro)
                    area = 1:n;
                    area = setdiff(area, [zanboor(i).expand_sweep d]);
                    indx = fix(1+rand*(size(area,2)-1));
                    x = find(zanboor(i).expand_sweep==area(indx));
                    if (x>0)
                    end
                    zanboor(i).expand_sweep(j) = area(indx);
                else  %
                    x = find(zanboor(i).expand_sweep==pishro.expand_sweep(j));
                    if (x>0)
                    end
                    zanboor(i).expand_sweep(j) = pishro.expand_sweep(j);
                    if (rand>p)
                        follow=0;
                    end
                end
            end
            [zanboor(i).sweep, zanboor(i).cost] = makeSweep(g,zanboor(i).expand_sweep,q,maxTime,d);
            zanboor(i).id=i;
        end
        % bargashtane zanboorha be kandoo
        %zanboor share their cost to others at hive
        tempCost(:,1) = [zanboor.id];
        tempCost(:,2) = [zanboor.cost];
        tempCost = sortrows(tempCost, 2);
        if (javab.cost > tempCost(1,2))
            javab = zanboor(tempCost(1,1));
        end
        for i=1:size(Pishro,2) %selecting pishro zanboor
            Pishro(i) = zanboor(tempCost(i,1));
        end
    end
    Cost(cnt) = javab.cost;
    display([num2str(cnt) ')  tedade vasayele naghlie : ' num2str(size(javab.sweep,2)) ' -  hazineye koll : ' num2str(javab.cost)]);
     tm(end+1) = toc;
end
 for i=1:size(javab.sweep,2)
    display(['masire ' num2str(i) ') ' num2str(javab.sweep{i})]);
 end
plot(Cost);
drawGraph(g);
figure;
plot(tm);