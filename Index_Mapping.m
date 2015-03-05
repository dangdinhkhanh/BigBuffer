function [ index_array ] = Index_Mapping( M )
%INDEX_MAPPING Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping state (d,c1,c2) to an index of transional states
% M: number of messages need to be delivered to a destination

% index is assigned for state
i = 1;
% the number of drops
for d=0:(M-2)
    for c1 = 0:(M-d)
        for c2 = 0:floor((M-d-c1)/2)
            if (c1+c2)==0
                continue;
            elseif (c1==1)& (c2==0)
                    continue;
            else
                index_array(i) = d*100^2+c1*100+c2;
                i = i+1;
            end
        end
    end

end


end

