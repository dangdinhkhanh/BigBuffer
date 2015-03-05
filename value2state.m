function [ state ] = value2state( value,B )
%VALUE2STATE Summary of this function goes here
%   Detailed explanation goes here
base = 100;
state = [];
% state(1) = d
state(1) = floor(value/base^B) ;
value = value - state(1)*base^B;

for i = 1:B
    state(i+1) = floor(value/base^(B-i));
    value = value -  state(i+1)*base^(B-i);
end

end

