function index=SelectByP(P)
    set=cumsum(P);
    i=find(set>=rand);
    index=i(1);
end