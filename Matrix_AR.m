function [ A, R ] = Matrix_AR( M,N,B )
%MATRIX_A Summary of this function goes here
%   Detailed explanation goes here
% A: matrix A
% M: number of messages
% N: number of nodes
% B: buffer of nodes

base = 100;

index_array = Index_Mapping(M, B);
% size of matrix A
n = length(index_array);
%A = zeros(n);
A = sparse(n,n);
rate = sparse(n,n);
R = sparse(M-B+1,n);
for i = 1:n
    %identify state
    value = index_array(i);
    state = value2state(value,B);
    %deliver to destination
    for j = 2:(B+1)
        if state(j)>=1 % c[B+2-j]>=1
            new_state = state;
            new_state(j) = new_state(j)-1; % c[B+2-j]
            new_value = state2value(new_state);
            new_index = Index_Searching(new_value);
            rate(i,new_index) = state(j); % c[B+2-j)*lambda
        end
    end
    % loss a packet
    % c[B] meets c[j]
    if state(2)>=1
        for j = 3: (B+1)
            if state(j)>=1 % c[B+2-j]>=1
                new_state = state;
                % d = d +1
                new_state(1) = new_state(1)+1;
                % c[B] = c[B]-1
                new_state(j) = new_state(j) -1;
                % c[B+2-j] = c[B+2-j] +1
                new_value = state2value(new_state);
                new_index = Index_Searching(new_value);
                rate(i,new_index) = state(2)*state(j)/2;
            end

        end
    end
    % c[B] meets c[B]
    if state(2)>=2
        new_state = state;
        % d = d+1
        new_state(1) = new_state(1)+1;
        % c[B] = c[B]-1
        new_state(2) = new_state(2) -1;
        % c[B-1] = c[B-1] +1
        new_state(3) = new_state(3) +1;
        
        new_value = state2value(new_state);
        new_index = Index_Searching(new_value);
        rate(i,new_index) = state(2)*(state(2)-1)/2;
    end
    % no delivery, no loss
    % node j (j>=2) meets empty node
    new_state = state; 
    for j = 2:B
        
        new_state = state;
        %c(B+2-j) = c(B+2-j) - 1;
        new_state(j) = new_state(j)-1;
        %c(B+1-j) = c(B+1-j) +1;
        new_state(j+1) = new_state(j+1)+1;
        %c(1) = c(1)+1;
        new_state(B+1) = new_state(B+1) + 1;
        new_value = state2value(new_state);
        new_index = Index_Searching(new_value);
        rate(i,new_index) = state(j)*(N-sum(state(2:end)));
    end
    % node j meets node B
    if state(2)>=1
        for j = 3:(B+1)
            if (state(j)>=1)
                new_state = state;
                %c[B]= c[B]-1
                new_state(2) = new_state(2)-1;
                %c[B+2-j] = c[B+2-j]-1;
                new_state(j) = new_state(j) -1;
                %c[B+3-j] = c[B+3-j] +1;
                new_state(j-1) = new_state(j-1)+1;
                new_value = state2value(new_state);
                new_index = Index_Searching(new_value);
                rate(i,new_index) = state(2)*state(j)/2;
            end
        end
    end
    % node j meets node k (>=j+2)
    for j = 3:B
        if state(j)>=1
            for k = (j+2):(B+1)
                if state(k)>=1
                    
                    new_state = state;
                    %c[B+2-j] = c[B+2-j]-1
                    new_state(j) = state(j) -1;
                    %c[B+2-k] = c[B+2-k]-1
                    new_state(k) = state(k) - 1;
                    %case 1
                    %c[B+1-j] = c[B+1-j]-1
                    new_state(j+1) = state(j+1)+1;
                    %c[B+3-k] = c[B+3-k]-1
                    new_state(k-1) = state(k-1)+1;
                    
                    new_value = state2value(new_state);
                    new_index = Index_Searching(new_value);
                    rate(i,new_index) = state(j)*state(k)/2;
                    
                    
                    %case 2
                    %c[B+3-j] = c[B+3-j]-1
                    new_state(j-1) = state(j-1)+1;
                    %c[B+1-k] = c[B+1-k]-1
                    new_state(k+1) = state(k+1)+1;
                    
                    new_value = state2value(new_state);
                    new_index = Index_Searching(new_value);
                    rate(i,new_index) = state(j)*state(k)/2;
                end
            end
        end
    end
    % node j meets node j+1
    for j = 3:(B+1)
        if (state(j)>=1)
            new_state = state;
            %c[B+2-j] = c[B+2-j]-1
            new_state(j) = new_state(j)-1;
            %c[B+3-j] = c[B+3-j]+1
            new_state(j-1) = new_state(j-1)+1;
            %c[B+1-j] = c[B+1-j]+1
            if j<(B+1)
                new_state(j+1) = new_state(j+1)+1;
            end
        end
        %
        new_value = state2value(new_state);
        new_index = Index_Searching(new_value);
        rate(i,new_index) = state(j)*state(j-1)/2;
    end
   
end

