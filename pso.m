clc;
clear;
%% Maghadire Avvalie
n = 8;  %teedade node-ha
m = 20;  %tedade vasayele naghlie
q = 40;  %zarfiate har vasile
maxTime = 120; %hadde aksare zaman baraye harekat az mabdaa ta maghsad
[g, d] = generateNewGraph(n, q, maxTime); % g : Graphe Jadid | d : Depo
[swp, cost, ~, ~, ~] = sweep(g, q, m, d, maxTime); %e-jade javabe jadid va mohasebe cost
populationCount=100;    %mizane jamiate zarrat
varCount=100;   %range entekhabe jamiat
maxit=50;
w=1;                
wdamp=0.99;     %zaribe kahande 
c1=2;
c2=2;
xmin=-10;
xmax=10;
dx=xmax-xmin;
vmax=0.1*dx;
newParticle.position=[];
newParticle.swp=[];
newParticle.velocity=[];
newParticle.cost=[];
newParticle.bestAns=[];
newParticle.bestCost=[];
particle=repmat(newParticle,populationCount,1);
gbest=zeros(maxit,varCount);
gbestcost=zeros(maxit,1);
gbestSWP= cell(maxit,1);
tm=[];
%% halgheye asli
for it=1:maxit
    tic;
    if it==1 %Jamiate avvalie . . .
        gbestcost(1)=inf;
        for i=1:populationCount
            particle(i).velocity=zeros(1,varCount);
            particle(i).position=xmin+(xmax-xmin)*rand(1,varCount);
            [particle(i).swp, particle(i).cost, ~, ~, ~] = sweep(g, q, m, d, maxTime);
            
            particle(i).bestAns=particle(i).position;
            particle(i).bestCost=particle(i).cost;
            
            if particle(i).bestCost<gbestcost(it)
                gbest(it,:)=particle(i).bestAns;
                gbestcost(it)=particle(i).bestCost;
                gbestSWP{it} = particle(i).swp;
            end
        end
    else   %amaliate asli
        gbest(it,:)=gbest(it-1,:);
        gbestcost(it)=gbestcost(it-1);
        gbestSWP{it}=gbestSWP{it-1};
        for i=1:populationCount
            particle(i).velocity=w*particle(i).velocity+c1*rand*(particle(i).bestAns-particle(i).position)+c2*rand*(gbest(it,:)-particle(i).position);
            particle(i).velocity=min(max(particle(i).velocity,-vmax),vmax);
            particle(i).position=particle(i).position+particle(i).velocity;
            particle(i).position=min(max(particle(i).position,xmin),xmax);
            [particle(i).swp, particle(i).cost, ~, ~, ~] = sweep(g, q, m, d, maxTime);
            if particle(i).cost<particle(i).bestCost
                particle(i).bestAns=particle(i).position;
                particle(i).bestCost=particle(i).cost;
                if particle(i).bestCost<gbestcost(it)
                    gbest(it,:)=particle(i).bestAns;
                    gbestcost(it)=particle(i).bestCost;
                    gbestSWP{it} = particle(i).swp;
                end
            end
        end
    end
    disp(['# ' num2str(it) '=> behtarin hazineye kol : ' num2str(gbestcost(it)) ' - tedad vasayele naghlie : ' num2str(size(gbestSWP{it},2))]);
    w=w*wdamp; %eemale zaribe kahande
    tm(end+1) = toc;
end
%% 
 for i=1:size(gbestSWP{end},2)
    display(['masire ' num2str(i) ') ' num2str(gbestSWP{end}{i})]);
 end
 plot(gbestcost);
drawGraph(g);
figure;
plot(tm);