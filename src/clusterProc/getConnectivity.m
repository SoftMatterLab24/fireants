function [K] = getConnectivity(I)

%% takes network I returns the network's connectivity K
T1 = I(1).pairlist(:,1);
T2 = I(1).pairlist(:,2);
uniquelist = unique(T1);
unique1 = length(uniquelist);
C = (2 * length(T1))/unique1; %formula comes from cell paper petridou et al 2021
Cmax = (8 + 16 * (sqrt(unique1) - 2) + 6 * (sqrt(unique1) - 2)^2)/unique1; % comes from cell paper methods
K = C/Cmax
end
