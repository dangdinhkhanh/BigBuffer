function [ value ] = state2value( state )
%STATE2VALUE Summary of this function goes here
%   Detailed explanation goes here
base = 100;
value = 0;
B = length(state) -1;
for i = 1:length(state)
    value = value + state(i)*base^(B+1-i);
end

end

