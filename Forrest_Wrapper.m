%% 0) Imports/paths

[directories] = initialiseImportsandPaths();

%% 1) Import para-fMRI data

%[pcnsDataTable, dataSet] = pcnsDataExtract(directories);

%% 2) Formatting hmmmar inputs

disp ('--------2) Formatting hmmmar inputs --------')

DataCll = cell(1,5);
T = cell(1,5);

dataDir = '/Volumes/USB_1TB/forrest_data/shenn';

for i = 1:5
    csvFilename = fullfile(dataDir, sprintf('sub-%02d_task-avmovie_run-1_bold.csv', i));
    if isfile(csvFilename)
        data = readmatrix(csvFilename,'NumHeaderLines',0);  % adjust header if needed
        DataCll{i} = data;
        T{i} = size(data,1);  % number of time points
    else
        warning('CSV file %s does not exist.', csvFilename)
    end
end

options = struct();
options.K        = 4;  % Number of states
options.order    = 0;  % Maximum order of the MAR model; if zero, an HMM with Gaussian observations is trained (mandatory, with no default).
options.zeromean = 0;  % If 1, the mean of the time series will not be used to drive the states (default to 1 if order is higher than 0, and 0 otherwise).
options.covtype  = 'full'; % Choice of the covariance matrix of the noise; "full" to have a full covariance matrix for each state (with off-diagonal elements different from zero), "sharedfull" to have one full covariance matrix for all states, "diag" to have a diagonal full covariance matrix for each state, and "shareddiag" to have one diagonal covariance matrix for all states (default to "full").
options.standardise = 0; % Standardised in pre-parcellation
options.verbose = 1;
options.Fs      = 1/0.8; %Fs is 1/0.8 (frequency is how many pictures per sec)
options.id_mixture = 1;
options.useMEX = 1;

options.plotGamma = 1;

disp (['Model set to **', num2str(options.K) , '** states.'])
disp('HMM-MAR inputs formatted.')



%% 3) HMM Estimation via hmmar

disp ('--------3) Creating HMM model via hmmmar --------')

[hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(DataCll,T,options); 

%% 4) Obtain Outputs

[TransitionProbabilites, FractionalOccupancy, ViterbiPath, SwitchingRates] = obtainOutputs(options, hmm, Gamma, T, DataCll, vpath, directories);

%% 5) Decode Brain States

% 5a) Use decodeBrainStates (python) to decode

% 5b) Use visualiseBrainStates to visualise

%visualiseBrainStates ()

%% 6) Perform Statistical Analysis

% doStats ()

% look at user guide - has built in stats

%% 7) Plot Figures