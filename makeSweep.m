function [sweep, cost] = makeSweep(g, expand_sweep, q, maxTime, depot)
   
   cnt = 1;T=0;C=0;Q=0;sweep = {};
   dIndx = find([g.id]==depot); %depot index
   status = dIndx;
   for i=1:size(expand_sweep,2)
       eIndx = find([g(status).relatedNodes]==expand_sweep(i)); %edge index
       gIndx = find([g.id]==expand_sweep(i)); %graph node index
       if ((q >= Q(end)+g(gIndx).Q) && (T(end)+g(status).edgeTimes(eIndx)+g(gIndx).T <= maxTime))
           T(cnt) = T(cnt) + g(status).edgeTimes(eIndx);
           C(cnt) = C(cnt) + g(status).edgeCost(eIndx);
           if (size(sweep,2) == 0)
               sweep{cnt} = expand_sweep(i);
           else
               sweep{cnt}(end +1) = expand_sweep(i);
           end
           status = gIndx;
           T(cnt) = T(cnt) + g(status).T;
           Q(cnt) = Q(cnt) + g(status).Q;
       else
           if (size(sweep,2) == 0)
               sweep{cnt} = g(dIndx).id;
           else
                sweep{cnt}(end +1) = g(dIndx).id;
           end
           status = dIndx;
           cnt=cnt+1;
           eIndx = find([g(status).relatedNodes]==expand_sweep(i)); %edge index
           gIndx = find([g.id]==expand_sweep(i)); %graph node index
           sweep{cnt} = expand_sweep(i);
           T(cnt) = g(status).edgeTimes(eIndx);
           C(cnt) = g(status).edgeCost(eIndx);
           status = gIndx;
           T(cnt) = T(cnt) + g(status).T;
           Q(cnt) = g(status).Q;
       end
   end
   if (sweep{end}(end) ~= depot)
       sweep{end}(end+1) = depot;
   end
   vCount = size(sweep,2);
   cost = vCount*(sum(T)/sum(C));
end