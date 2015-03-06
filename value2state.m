function [ state ] = value2state( value,B )
%VALUE2STATE Summary of this function goes here
%   Detailed explanation goes here
base = 100;
state = zeros(1,B+1);
% state(B+1) = d
state(B+1) = floor(value/base^B) ;
value = value - state(B+1)*base^B;

for i = B:-1:1
    state(i) = floor(value/base^(i-1));
    value = value -  state(i)*base^(i-1);
end

end

