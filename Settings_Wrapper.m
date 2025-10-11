%% 0) Imports/paths

directories = initialiseImportsandPaths();

%% 2) Formatting hmmmar inputs

[DataCll, T, options] = formatHmmmarInputs(directories);

%% 1) Find Dirichilet Diag

candidate_prior = [0.5, 1, 2, 5, 10];
folds = 5 % Number of sections data will be split into and tested against each other, 1 section is test section each time

[CVFeCandidate_priors] = findDDiag (candidate_prior, DataCll, T, options, directories);


%% 2) Find K

candidiate_K = [10:16];
dim = 2% dim = 1: average % FO at each time point (sums to 1 at each time point), = 2: average % FO over each trial (i.e. subject)
%dim = 2 will return FO as double array with K cols x number of
%participants rows
[FOFeCandidate_K] = findK (candidate_K, dim, DataCll, T, options, directories);

%% 3) Manually check outputs and make decision

print ("-----3)Ddiag and K analysis completed! Please check and make decision.-----")


