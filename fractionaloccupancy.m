%% 3b) Generate Fractional Occupancy
%
%INPUTS: 
% Gamma, T, options, dim
%
%OUTPUTS:
% FractionalOccupancy
%

dim = 1; %1 = average fractional occupancy across all trials, 2 = fractional occupancy in each state for a single subject
FractionalOccupancy = getFractionalOccupancy(Gamma, T, options,dim);
disp(' 3b) Fractional occupancy extracted.')
