%% 1) Formating hmmmar inputs
%
%INPUTS: 
% directories
%
%OUTPUTS:
% DataCll
% T
% Options

function [DataCll, T, options] = formatHmmmarInputs(directories);

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
T{1,1} = [327];

% 1c) Format "options"
options = struct();
options.K        = 6;  % Number of states
options.order    = 0;  % Order of the MAR model
options.zeromean = 0;  
options.covtype  = 'full';
options.standardise = 1;
options.verbose = 1;
options.Fs      = 1/0.8; %Fs is 1/0.8 (frequency is how many pictures per sec)
%DirichletDiag makes states more sticky
%cyc, initrep, initcyc incr can incr number of iterations
%pca does dimensionality reduction from initial number (e.g. to number
%specified)

disp('HMM-MAR inputs formatted.')