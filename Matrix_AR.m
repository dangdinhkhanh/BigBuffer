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
    A = zeros(n);
    %A = sparse(n,n);
    %rate = sparse(n,n);
    rate = zeros(n);
    
    for i = 1:n
        %identify state
        value = index_array(i);
        state = value2state(value,B);
        %disp(state);
        %all messages
        m = 0;
        for k = 1:B
            m = m+ state(k)*k;
        end
        %deliver to destination
        for j = 1:B
            if (state(j)>=1) & (m>2)  
                new_state = state;
                new_state(j) = new_state(j)-1;  
                if j>1
                    new_state(j-1) = new_state(j-1)+1;
                end
                %disp(new_state);
                new_value = state2value(new_state);
                new_index = Index_Searching(new_value,index_array);
                %disp(new_index);
                rate(i,new_index) = rate(i,new_index)+state(j); 
                %disp(sprintf('rate[%d,%d]=%d',i,new_index,rate(i,new_index)));
            end
        end


        % loss a packet
        % c[B] meets c[j]
        if state(B)>=1
            for j = 1: (B-1)
                if state(j)>=1 % c[B+2-j]>=1
                    new_state = state;

                    % d = d +1
                    new_state(B+1) = new_state(B+1)+1;

                    % c[j] = c[j]-1
                    new_state(j) = new_state(j) -1;

                    % c[j-1] = c[j-1] + 1
                    if (j>=2)
                        new_state(j-1) = new_state(j-1) + 1;
                    end
                    new_value = state2value(new_state);
                    new_index = Index_Searching(new_value,index_array);
                    rate(i,new_index) = rate(i,new_index)+state(j)*state(B)/2;
                    
                end

            end
        end
        % c[B] meets c[B]
        if state(B)>=2
            new_state = state;

            % d = d+1
            new_state(B+1) = new_state(B+1)+1;

            % c[B] = c[B]-1
            new_state(B) = new_state(B) -1;

            % c[B-1] = c[B-1] +1
            new_state(B-1) = new_state(B-1) +1;

            new_value = state2value(new_state);
            new_index = Index_Searching(new_value,index_array);
            rate(i,new_index) = rate(i,new_index)+ state(B)*(state(B)-1)/2;
        end
        % no delivery, no loss
        % node j (j>=2) meets empty node
        new_state = state; 
        for j = 2:B
            if state(j)>=1
                new_state = state;
                %c(j) = c(j) - 1;
                new_state(j) = new_state(j)-1;
                %c(j-1) = c(j-1) +1;
                new_state(j-1) = new_state(j-1)+1;
                %c(1) = c(1)+1;
                new_state(1) = new_state(1) + 1;
                new_value = state2value(new_state);
                new_index = Index_Searching(new_value,index_array);
                rate(i,new_index) = rate(i,new_index)+ state(j)*(N-sum(state(1:B)));
            end
        end
        % node j (<=B-2) meets node B
        if state(B)>=1
            for j = 1:(B-1)
                if (state(j)>=1)
                    new_state = state;
                    %c[B]= c[B]-1
                    new_state(B) = new_state(B)-1;
                    %c[B-1] = c[B-1]+1;
                    new_state(B-1) = new_state(B-1)+1;
                    % c[j] = c[j]-1;
                    new_state(j) = new_state(j) -1;
                    %c[j+1] = c[j+1] +1;
                    new_state(j+1) = new_state(j+1)+1;
                    new_value = state2value(new_state);
                    new_index = Index_Searching(new_value,index_array);
                    rate(i,new_index) = rate(i,new_index)+ state(2)*state(j)/2;
                end
            end
        end
        % node j meets node k (>=j+2)
        for j = 1:(B-2)
            if (state(j)>=1)
                for k = (j+2):(B-1)
                    
                    if state(k)>=1
                        %case 1 (node k sends msg to node j)
                        new_state = state;
                        %c[j] = c[j]-1
                        new_state(j) = state(j) -1;
                        %c[k] = c[k]-1
                        new_state(k) = state(k) - 1;
                        
                        %c[j+1] = c[j+1]-1
                        new_state(j+1) = state(j+1)+1;
                        %c[k-1] = c[k-1]-1
                        new_state(k-1) = state(k-1)+1;

                        new_value = state2value(new_state);
                        new_index = Index_Searching(new_value,index_array);
                        rate(i,new_index) = rate(i,new_index)+ state(j)*state(k)/2;
                        

                        %case 2 node j sends msg to node k
                    
                        new_state = state;
                        %c[j] = c[j]-1
                        new_state(j) = state(j) -1;
                        %c[k] = c[k]-1
                        new_state(k) = state(k) - 1;
                        if(j>1)
                            new_state(j-1) = state(j-1)+1;
                        end
                        new_state(k+1) = state(k+1)+1;
                        
%                         disp('%%');
%                         disp(state);
%                         disp('%');
%                         disp(new_state);
                        new_value = state2value(new_state);
                        new_index = Index_Searching(new_value,index_array);
                        rate(i,new_index) = rate(i,new_index)+ state(j)*state(k)/2;
                    end
                    
                end
            end
        end
        % node j meets node j+1 
        for j = 1:(B-2)
            if (state(j)>=1) & (state(j+1)>=1)
                new_state = state;
                %node j send to node j+1
                new_state(j) = new_state(j)-1;
                % increase node j-1
                if (j>1)
                    new_state(j-1) = new_state(j-1)+1;
                end
                % decrease node j+1
                new_state(j+1) = new_state(j+1)-1;
                % increase node j+2
                new_state(j+2) = new_state(j+2)+1;
                
            end
            
            new_value = state2value(new_state);
            new_index = Index_Searching(new_value,index_array);
            rate(i,new_index) = rate(i,new_index)+ state(j)*state(j+1)/2 ;
        end
        % node j meets node j
        for j = 1:(B-1)
            if (state(j)>=2)
                new_state = state;
                %node j send to node j+1
                new_state(j) = new_state(j)-2;
                % increase node j-1
                if (j>1)
                    new_state(j-1) = new_state(j-1)+1;
                end
                % increase node j+1
                new_state(j+1) = new_state(j+1)+1;

            end
            %disp(new_state);
            new_value = state2value(new_state);
            new_index = Index_Searching(new_value,index_array);
            rate(i,new_index) = rate(i,new_index)+ state(j)*(state(j)-1)/2 ;
        end

    end
    
    %disp(rate);
    s = [];
    for i = 1:n
        s(i) = sum(rate(i,:));
    end
    %R = sparse(n,M-B+1);
    R = zeros(n,M-B+1);
    %absorbing state is (1,0,0,...,d)
    for d = 0:(M-B)
        %consider state (2,0,0,....,d)
        state = zeros(1,B+1);
        state(1) = 2;
        state(B+1) = d;
        value = state2value(state);
        index = Index_Searching(value, index_array);
        s(index) = s(index) + 2;
        R(index,d+1) = 2/s(index);
        %consider state (0,1,0,...,d)
        state = zeros(1,B+1);
        state(2) = 1;
        state(B+1) = d;
        value = state2value( state);
        index = Index_Searching(value, index_array);
        s(index) = s(index) + 1;
        R(index,d+1) = 1/s(index);
    end
    %normalize matrix r to make matrix A
    for i = 1:n
        for j = 1:n
            if(s(i)>0)
                A(i,j) = rate(i,j)/s(i);
            else if s(i)==0
                A(i,j) =0;
            end
        end
    end
end
 
