function [ R ] = Matrix_R( M,N )
%MATRIX_R Summary of this function goes here
%   Detailed explanation goes here

% R: matrix R (from normal state i to absorbing state j)
% M: number of messages
% N: number of nodes
index_array = Index_Mapping(M);
n = length(index_array);
% number of columns is M  where posibilitis of drops belongs (0,1,...,M-1) 

% create a matrix R of zeros
%R = zeros(n,M);
R = sparse(n,M-1);
for d = 0:(M-2)
    
       
    %from (d,2,0) to (d,1,0)
    v = d*100^2+2*100;
    i = Index_Searching(v,index_array);
    R(i,d+1) = 2/3;
    
    %from (d,0,1) to (d,1,0)
    v = d*100^2+1;
    i = Index_Searching(v,index_array);
    R(i,d+1) = 1/N;
    
end

end

