function [ index_array ] = Index_Mapping(M,B)
%INDEX_MAPPING Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping state (c[1],c[2],..,c[B],d) to an index of transional states
% M: number of messages need to be delivered to a destination
% B: buffer size 
% base to make values distint and increasing
base = 100;
% index is assigned for state
i = 1;
index_array = [];
% the number of drops
for d = 0:(M-B)
    list = Generate(B,M-d);
  
    % remove 2 first elements of lists (sum = 0,1)
    list = list(3:end,:); 
    for j = 1:size(list,1)
        index_array(i) = d*base^B;
        for k = 1:B
            index_array(i) = index_array(i) + list(j,k)*base^(k-1);
        end
        i = i + 1;
    end
end


end

