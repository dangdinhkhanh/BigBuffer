M = 4; 
B = 2;
a = Index_Mapping(M,B);
for i = 1: length(a)
    disp(value2state(a(i),B));
end