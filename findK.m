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

function [FOFeCandidate_K] = findK(candidate_K, dim, HODDataCll, T, options, directories, Gamma);
disp ("----- 2)Starting function for candidate Ks-----")

%% Calculating FO and fe

FOFeCandidate_K = struct ('candidiate_K', {}, 'FO', {},'fe', {}); %structure saving likelihoods for candidiate_priors

disp ("Calculating FO and fe and saving to FOFeCandidate_K.")

%%% change data source to HOD file
files = dir(fullfile(directories.dataDir, 'HOD_fake_parcellated_sub*.txt')); 
file_num = length(files);
for i = 1:file_num;
    filename = fullfile(directories.dataDir, sprintf('HOD_fake_parcellated_sub%03d.txt', i));
    HODDataCll{i} = load(filename);  % store each loaded array in a cell array
    T{i} = 327;
end

for i = 1:length(candidate_K); %cycle through all candidiate_Ks
    disp ("calculating hmm ")
    options.K = candidate_K(i); %keeping other HMM inputs the same, change K to current candidate_K

    FOFeCandidate_K(i).candidate_K = candidate_K(i);

    %Construct HMM using HOD
    [hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(HODDataCll,T,options);

    %Save FO as array of length K x 1 to FOFeCandidate_K
    rawFO = getFractionalOccupancy(Gamma, T, options, dim);
    avgFO = mean (rawFO, 1); %average across columns (K)

    FOFeCandidate_K(i).FO = avgFO;

    %Save free energy 'fe' to FOFeCandidate_K
    data = HODDataCll;
    FOFeCandidate_K(i).fe = hmmfe(data,T,hmm,Gamma,Xi);
end

disp ("findK completed.")
