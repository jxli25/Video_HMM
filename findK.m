%% findK creates a structure for input Ks (candidiate_priorsK) with their FO and Fes

% INPUTS:

% candidiate_K (array) 
% dim
%
% DataCll 
% T 
% options 
% directories

% OUTPUTS:

% FOFeCandidate_K (structure)

function [FOFeCandidate_K] = findK (candidate_K, DataCll, T, options, directories);
print ("----- 2)Starting function for candidate Ks-----")

%% Calculating FO and fe

FOFeCandidate_K = struct ('candidiate_K', {}, 'FO', {},'fe', {}); %structure saving likelihoods for candidiate_priors

print ("Calculating FO and fe and saving to FOFeCandidate_K.")

for i = 1:length(candidate_K) %cycle through all candidiate_Ks

    [DataCll, T, options] = formatHmmmarInputs(directories); %format HMM inputs

    options.K = candidate_K(i) %keeping other HMM inputs the same, change K to current candidate_K

    FOFeCandidate_K(i).candidate_K = candidate_K(i)

    %Save FO as array of length K x 1 to FOFeCandidate_K
    rawFO = getFractionalOccupancy(Gamma, T, options, dim);
    avgFO = mean (rawFO, 1); %average across columns (K)

    FOFeCandidate_K(i).FO = avgFO;

    %Save free energy 'fe' to FOFeCandidate_K
    FOFeCandidate_K(i).fe = hmmfe(data,T,hmm,Gamma,Xi);
end

print ("findK completed.")
