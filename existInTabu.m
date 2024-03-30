function [ similarity ] = existInTabu(tabuList, swp)
    similarity = 0;
    for i = 1:size(tabuList,2)
        if (size(tabuList{i},2) == size(swp,2))
            for j=1:size(swp,2)
                dif = setdiff(swp{j}, tabuList{i}{j});
                if (size(dif,2) == 0)
                    similarity = 1;
                    return;
                end
            end
        end
    end
end

