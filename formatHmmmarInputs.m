%% 1) Formating hmmmar inputs
%
%INPUTS: 
% directories
% manual editing of options below
%
%OUTPUTS:
% DataCll
% T
% Options

function [DataCll, T, options] = formatHmmmarInputs(directories)

disp ('--------1) Formatting hmmmar inputs --------')

% 1a) Format "DataCll" (subject data)
%%% Initialise "DataCll" cell w correct dimensions
% DataCll = cell(1,1);
%%%% Load individual parcellated subject files into "DataCll"
% format needs to be no timepoint X no channels


DataCll = load([directories.dataDir,'/Yeo_parcellated_test_sub.txt'], "-ascii");
DataCll = {DataCll};

% 1b) Format "T" (time)
%%% Initialise "T" cell w correct dimensions
T = cell(1,1);

%%% Populate "T" w number of slices through time
T{1,1} = 327;

% 1c) Format "options"
options = struct();
options.K        = 6;  % Number of states
options.order    = 0;  % Maximum order of the MAR model; if zero, an HMM with Gaussian observations is trained (mandatory, with no default).
options.zeromean = 0;  %
options.covtype  = 'full'; %choice of the covariance matrix of the noise; "full" to have a full covariance matrix for each state (with off-diagonal elements different from zero), "sharedfull" to have one full covariance matrix for all states, "diag" to have a diagonal full covariance matrix for each state, and "shareddiag" to have one diagonal covariance matrix for all states (default to "full").
options.standardise = 0;
options.verbose = 1;
options.Fs      = 1/0.8; %Fs is 1/0.8 (frequency is how many pictures per sec)
options.id_mixture = 1;
%Initialisation and training
options.initrep = 10;
options.initcyc = 10;
options.cyc = 300;
%DirichletDiag makes states more sticky
%cyc, initrep, initcyc incr can incr number of iterations
%pca does dimensionality reduction from initial number (e.g. to number
%specified)
disp (['Model set to **', num2str(options.K) , '** states.'])
disp('HMM-MAR inputs formatted.')

