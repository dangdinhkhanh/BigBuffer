
%M = [2:2:36];
M = [2:2:20];

N = 21;

num_drops = [];
drops_ratio = [];

for c = 1:length(M)

    index_array= Index_Mapping(M(c));
    
    %initial state (0,M1,M2)
    %init = Index_Searching(M(c)*100,index_array);
    init = Index_Searching(M(c)/2,index_array);


    A =  Matrix_A( M(c),N );
    R = Matrix_R (M(c),N);
    I = speye(length(index_array));
    B = (I-A)\R;

%     disp(sum(B(init,:)));
%     disp(B(init,:));

    %number of drop
    num_drop = 0;
    for i = 1:(M(c)-1)
        num_drop = num_drop+B(init,i)*(i-1);
    end
    %disp(num_drop);
    num_drops = [num_drops,num_drop];
    drop_ratio = num_drop/M(c);
    drops_ratio = [drops_ratio,drop_ratio];
end

hold on;
%plot(M,num_drops);
plot(M,drops_ratio,'rs--');
