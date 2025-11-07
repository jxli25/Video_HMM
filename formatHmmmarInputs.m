%% 1) Formating hmmmar inputs
%
%INPUTS: 
% directories
% manual editing of options below
%
%OUTPUTS:
% DataCll
% HODDataCll
% T
% Options

function [DataCll, T, options] = formatHmmmarInputs(directories,dataSet)

disp ('--------2) Formatting hmmmar inputs --------')

% 1a) Format "DataCll" and "HODDataCll" (subject data)
dataSet = getDataSetInfo(directories);

%%%% Load individual parcellated main datafiles into "DataCll"
% format needs to be no timepoint X no channels (327 x 17)

files = dir(fullfile(directories.dataDir, 'sub*.txt')); 
%file_num = length(files);

for i = 1:dataSet.nParticipants

    filename = [directories.dataDir, dataSet.fileNames(i,:)];
    if ~isempty(filename)
        DataCll{i} = load(filename);  % store each loaded array in a cell array
        T{i} = 327;

    end
end

% % 1b) Format "T" (time)
% %%% Initialise "T" cell w correct dimensions
% T = cell(1,1);
% 
% %%% Populate "T" w number of slices through time
% T{1,1} = 327;

% 1c) Format "options"
options = struct();
options.K        = 5;  % Number of states
options.order    = 1;  % Maximum order of the MAR model; if zero, an HMM with Gaussian observations is trained (mandatory, with no default).
%options.zeromean = 0;  % If 1, the mean of the time series will not be used to drive the states (default to 1 if order is higher than 0, and 0 otherwise).
options.covtype  = 'diag'; % Choice of the covariance matrix of the noise; "full" to have a full covariance matrix for each state (with off-diagonal elements different from zero), "sharedfull" to have one full covariance matrix for all states, "diag" to have a diagonal full covariance matrix for each state, and "shareddiag" to have one diagonal covariance matrix for all states (default to "full").
options.standardise = 0; % Standardised in pre-parcellation
options.verbose = 1;
options.Fs      = 1/0.8; %Fs is 1/0.8 (frequency is how many pictures per sec)
options.id_mixture = 1;
%Initialisation and training
options.initrep = 10;
options.initcyc = 10;
options.cyc = 300;
options.useParallel = 0;
options.DirichletDiag = 2; %DirichletDiag makes states more sticky
%cyc, initrep, initcyc incr can incr number of iterations
%pca does dimensionality reduction from initial number (e.g. to number
%specified)
disp (['Model set to **', num2str(options.K) , '** states.'])
disp('HMM-MAR inputs formatted.')

