function [ A ] = Matrix_A( M,N )
%MATRIX_A Summary of this function goes here
%   Detailed explanation goes here
% A: matrix A
% M: number of messages
% N: number of nodes
index_array = Index_Mapping(M);
% size of matrix A
n = length(index_array);
%A = zeros(n);
A = sparse(n,n);
for i = 1:n
    d = floor(index_array(i)/100^2);
    c1 = floor((index_array(i)-d*100^2)/100);
    c2 = index_array(i)-d*100^2-c1*100;
    %vector of transitional rates
    r = zeros(1,6);
    %vector of values
    v = zeros(1,6);
    %(d,c1,c2)  ---------2 nodes of c1 meet
    if(c1>=2)
        r(1) = c1*(c1-1)/2;
        v(1) = d*100^2+(c1-2)*100+(c2+1);
    end
    %(d,c1+2,c2-1) ------------1 node of c2 and 1 node of c0 meet
    if(c2>=1)
        r(2) = c2*(N-c1-c2);
        v(2) = d*100^2+(c1+2)*100+(c2-1);
    end
    %(d+1,c1-1,c2) ---------1 node of c1 and 1 node of c2 meet
    if(c1>=1) & (c2>=1)
        r(3) = c1*c2/2;
        v(3) = (d+1)*100^2 + (c1-1)*100 + c2;
    end
    %(d+1,c1+1,c2-1) -------------2 nodes of c2 meet
    if (c2>=2)
        r(4) = c2*(c2-1)/2;
        v(4) = (d+1)*100^2 + (c1+1)*100 + (c2-1);
    end
    %(d,c1-1,c2)-- 1 nodes c1 meets the destionation
    if (c1>=2)
        r(5) = c1;
        v(5) = d*100^2 + (c1-1)*100 + c2;
    end
    %(d,c1+1,c2-1)-- 1 nodes c2 meets the destionation
    if (c2>=1)
        r(6) = c2;
        v(6) = d*100^2 + (c1+1)*100 + (c2-1);
    end
    %denominator
    denom = sum(r);
    for j = 1:6
        %k = Index_Searching(v(j),d_arr,c1_arr,c2_arr);
        k = Index_Searching(v(j),index_array);
        if (r(j)>0) &&(k>0)
            A(i,k) = r(j)/denom;
        end
    end
end

