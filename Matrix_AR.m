function [ A, R ] = Matrix_AR( M,N,B )
%MATRIX_A Summary of this function goes here
%   Detailed explanation goes here
% A: matrix A
% M: number of messages
% N: number of nodes
% B: buffer of nodes
index_array = Index_Mapping(M, B);
% size of matrix A
n = length(index_array);
%A = zeros(n);
A = sparse(n,n);
R = sparse(M-B+1,n);
for i = 1:n
   
end

