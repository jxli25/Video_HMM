%% CURRENTLY CODED FOR 1 TEST SUBJECT

%% 0) Imports/paths

% 1)
addpath(genpath(pwd)); % adds current path
addpath(genpath([pwd,'Parcellation_Figures']));
codeDir = pwd;
cd ../;
mainDir = pwd;
cd(codeDir);
dataDir    = [mainDir,filesep,'data_HMM',filesep]; % this is what I called the folder where I stored the data you sent me
%toolboxDir = [mainDir,filesep,'Toolboxes',filesep,'HMM-MAR-master',filesep]; % this is where I store the toolbox but you may have oranised that differently
addpath(genpath('/Users/judy/HMM-MAR-master')) %not sure why the above isn't working, but this line works for me
addpath(genpath(dataDir)); 
addpath(genpath(toolboxDir)); 

%2)

%3)
addpath(genpath('/Users/judy/nilearn_data/yeo_2011/Yeo_JNeurophysiol11_MNI152')

%% 1) Formating hmmar inputs

% 1a) Format "DataCll" (subject data)
%%% Initialise "DataCll" cell w correct dimensions
% DataCll = cell(1,1);
%%%% Load individual parcellated subject files into "DataCll"
% format needs to be no timepoint X no channels
DataCll = load([dataDir,'/Yeo_parcellated_test_sub.txt'], "-ascii");
DataCll = {DataCll};

% 1b) Format "T" (time)
%%% Initialise "T" cell w correct dimensions
% T = cell(1,1);

%%% Populate "T" w number of slices through time
% T{1,1}=327;
% Setting T to be a (no. of subjects X 1) cell with each element 
% containing a vector (no. of trials X 1) reflecting the length of the trials for that particular subject.

T=cell(1,1);
T{1,1} = [327];

% 1c) Format "options"
options = struct();
options.K        = 6;  % Number of states
options.order    = 0;  % Order of the MAR model
options.zeromean = 0;  
options.covtype  = 'full';
options.standardise = 1;
options.verbose = 1;
options.Fs      = 1/0.8;

%DirichletDiag makes states more sticky

%cyc, initrep, initcyc incr can incr number of iterations

%pca does dimensionality reduction from initial number (e.g. to number
%specified)

%Fs is 1/0.8 (frequency is how many pictures per sec)
%% 2) HMM Estimation via hmmar
% I couldnt figure out where this function comes from?
[hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(DataCll,T,options); 

%% 3) Results Analysis

%Transition probabilities Table
ColumnNms = {};
for ColNum = 1:options.K
    ColumnNms{ColNum} = ['Transition to State ', num2str(ColNum)];
end
TransitionWndw = uifigure('Position', [100, 100, 500, 300]); %Creates new figure window
t = uitable(TransitionWndw, 'Data', getTransProbs(hmm), 'ColumnName', ColumnNms, 'Position', [20, 20, 460, 220]); %Greates new table in window

t.FontSize = 12;  % Increase font size
t.FontName = 'Arial';  % Change font
t.RowName = 'numbered';  % Add numbered row names

%Fractional Occupancy
dim = 1; %1 = average fractional occupancy across all trials, 2 = fractional occupancy in each state for a single subject
FractionalOccupancy = getFractionalOccupancy(Gamma, T, options,dim);

% Viterbi path
[Gamma,Xi] = hmmdecode(DataCll,T,hmm,0); 
[viterbipath] = hmmdecode(DataCll,T,hmm,1);

% %Visualising Brain States
k = [1:options.K] %specifies which states to visualise
%parcellationfile = load_nii('/Users/judy/nilearn_data/yeo_2011/Yeo_JNeurophysiol11_MNI152/Yeo2011_17Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz
onconnectivity = 0
maps = makeMap(hmm,k,parcellationfile,onconnectivity)
% load_nii('path_to_yeo2011_parcellation.nii');
% %If parcellationfile (which contains the original parcellation or ICA decomposition) is a NIFTI 
% file, then also a maskfile needs to be specified, and OSL needs to be installed an in the path; 
% if it is a CIFTI file, then it has to be a dtseries.nii file (see below to convert from func.gii to dtseries.nii). 
% 
% % Assuming `data` contains time series data for each brain region
% % and you want to create a CIFTI time series file
% 
% % Create a CIFTI structure with the data
% ciftiData = struct();
% 
% % Assuming your data is for 1 brain surface (Cortex), we can store it in the CIFTI structure
% % Add the data to the CIFTI structure (replace 'data' with your actual data variable)
% ciftiData.cdata = DataCll{1,1};  % Set the data (time series or connectivity matrix)
% 
% % You need to define the CIFTI metadata, like the brain regions
% % If using the brain's cortical surface, you can use the CIFTI structure for the surface
% ciftiData.brainstructure = 'Cortex';  % Example, can be 'Subcortex', 'Cortex', etc.
% 
% % Define the 'diminfo' field
% % diminfo typically describes the data dimensions (e.g., regions, timepoints)
% ciftiData.diminfo = struct();
% ciftiData.diminfo.dimnames = {'Regions'};  % Modify as per your data structure
% ciftiData.diminfo.dimvals = {1:6};  % Modify based on your data's size
% 
% % Now, you can write the CIFTI file
% cifti_write(ciftiData, 'output_file.dconn.nii');  % Replace with desired output filename