%% findDDiag creates a structure for input DirichletDiags (candidiate_priors) with their cv likelihoods and free energies

% INPUTS:

% candidate_prior (array) 
% folds
%
% DataCll 
% T 
% options 
% directories

% OUTPUTS:

% CVFeCandidate_priors (structure)

function [CVFeCandidate_priors] = findDDiag (candidate_prior, folds, DataCll, T, options, directories)

disp ("----- 1)Starting function for candidate DDiags-----")

%% Calculating predictive log-likelihood

% Will use HOD to estimate optimal DirichetDiag out of candidate priors
% (0.5, 1, 2, 5, 10). For each candidate_prior, fit HMM to the training set
% with the specified Dirichlet prior.

CVFeCandidate_priors = struct ('candidate_prior', {}, 'mcv', {}, 'cv', {}, 'fe', {}); %structure saving likelihoods for candidiate_priors

disp ("Calculating log-likelihoods and saving to CVFeCandidate_priors.")

for i = 1:length(candidate_prior) %cycle through all candidiate_priors

    options.DirichletDiag = candidate_prior(i); %keeping other HMM inputs the same, change DirichletDiag to current candidate_prior
    options.cvfolds = folds;
    options.cvverbose = 1;
    

    % For each HMM, compute how well it predicts the hold-out data. -
    % Predictive log-likelihood; use learned parameters to evaluate
    % likelihood of the hold-out sequence

    [mcv, cv] = cvhmmmar(DataCll, T, options);

    %Save likelihoods to CVFeCandidate_priors

    CVFeCandidate_priors(i).candidate_prior = candidate_prior(i);
    CVFeCandidate_priors(i).mcv = mcv;
    CVFeCandidate_priors(i).cv = cv;

end

%% Free energy; Evaluate the variational free energy on unseen data

disp ("Calculating free energy and saving to CVFeCandidate_priors.")

for i = 1:length(candidate_prior); %cycle through all candidiate_priors

    options.DirichletDiag = candidate_prior(i); %keeping other HMM inputs the same, change DirichletDiag to current candidate_prior

    % For each candidate_prior, create an HMM

    [hmm, Gamma, Xi] = hmmmar(DataCll,T,options); 

    %Save free energy 'fe' to CVFeCandidate_priors
    data = DataCll;
    CVFeCandidate_priors(i).fe = hmmfe(data,T,hmm,Gamma,Xi);

end

disp ("findDDiag completed.")