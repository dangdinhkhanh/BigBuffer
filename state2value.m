function [ value ] = state2value( state )
%STATE2VALUE Summary of this function goes here
%   Detailed explanation goes here
base = 100;
value = 0;

for i = 1:length(state)
    value = value + state(i)*base^(i-1);
end

end

