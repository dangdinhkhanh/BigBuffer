
%M = [2:2:36];
M = [2:2:20];
%M = 10;
Buf = 3;
%Buf = 5;
%N = 4;
N = 21;

num_drops = [];
drops_ratio = [];

for c = 1:length(M)
    if M(c)<=Buf
        num_drop = 0;
    else
        index_array= Index_Mapping(M(c),Buf);

        state = zeros(1,Buf+1);
        state(1) = M(c);
        value = state2value(state);
        init = Index_Searching(value,index_array);
        %disp(init);

        [A,R] =  Matrix_AR( M(c),N,Buf);
        I = speye(length(index_array));
        B = (I-A)\R;

    %     disp(sum(B(init,:)));
    %     disp(B(init,:));

        %number of drop
        num_drop = 0;
        for i = 1:(M(c)-Buf)
            num_drop = num_drop+B(init,i)*(i-1);
        end
    end
    %disp(num_drop);
    num_drops = [num_drops,num_drop];
    drop_ratio = num_drop/M(c);
    drops_ratio = [drops_ratio,drop_ratio];
end

hold on;
%plot(M,num_drops);
plot(M,drops_ratio,'rs--');
