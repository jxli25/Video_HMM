%% CURRENTLY CODED FOR 1 TEST SUBJECT

%% 0) Imports/paths

[directories] = initialiseImportsandPaths();

%% 1) Import para-fMRI data

[pcnsDataTable] = pcnsDataExtract(directories);

%% 2) Formatting hmmmar inputs

[DataCll, HODDataCll, T, options] = formatHmmmarInputs(directories);

%% 3) HMM Estimation via hmmar

disp ('--------2) Creating HMM model via hmmmar --------')

[hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(DataCll,T,options); 

%% 4) Obtain Outputs

[TransitionProbabilities, FractionalOccupancy, ViterbiPath, SwitchingRates] = obtainOutputs(options, hmm, Gamma, T, DataCll,vpath)

%% 5) Decode Brain States

% 5a) Use decodeBrainStates (python) to decode

% 5b) Use visualiseBrainStates to visualise

visualiseBrainStates ()

%% 6) Perform Statistical Analysis

doStats ()

% look at user guide - has built in stats
