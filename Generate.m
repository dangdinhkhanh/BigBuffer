function [ list ] = Generate( B,k )
%GENERATE Summary of this function goes here
%   Detailed explanation goes here
% Generate all combinations (cB,...,c1) such that
% c1+2*c2+....+B*cB<=k in the ascending order
% when apply, we will remove 2 first elements of list (c_i = 0, c1={0,1}) 
% for all i>1
    list = [];
    if B ==1
        list = [0:k]';
    elseif B>1
        for cB = 0:floor(k/B)
            n = size(Generate(B-1,k-cB*B),1);
            list_B = [ones(n,1)*cB,Generate(B-1,k-cB*B)];
            list = [list;list_B];
        end
    end

end

