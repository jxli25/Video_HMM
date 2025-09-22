%% CURRENTLY CODED FOR 1 TEST SUBJECT

%% 0) Imports/paths

directories = initialiseImportsandPaths();

%% 1) Formating hmmmar inputs

[DataCll, T, options] = formatHmmmarInputs(directories);

%% 2) HMM Estimation via hmmar

disp ('--------2) Creating HMM model via hmmmar --------')

[hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(DataCll,T,options); 

%% 3) Obtain Outputs

[FractionalOccupancy] = obtainOutputs(options, hmm, Gamma, T, DataCll, vpath);

%% 4) Perform Statistical Analysis
