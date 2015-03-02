M = 3;
N = 4; 
A = Matrix_A(M,N);
R = Matrix_R(M,N);
for i = 1: size(A,1)
    disp(sum(A(i,:))+sum(R(i,:)));
end