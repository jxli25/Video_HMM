%% CURRENTLY CODED FOR 1 TEST SUBJECT

%% 0) Imports/paths

directories = initialiseImportsandPaths();

%% 1) Formating hmmmar inputs

[DataCll, T, options] = formatHmmmarInputs(directories);

%% 2) HMM Estimation via hmmar

disp ('--------2) Creating HMM model via hmmmar --------')

[hmm, Gamma, Xi, vpath, GammaInit, residuals, fehist] = hmmmar(DataCll,T,options); 

%% 3) Results Analysis

disp( '--------3) Creating outputs from hmm model --------')

% 3a) Transition probabilities Table

makeTransProbTbl(options, hmm)

% 3b) Fractional Occupancy
dim = 1; %1 = average fractional occupancy across all trials, 2 = fractional occupancy in each state for a single subject
FractionalOccupancy = getFractionalOccupancy(Gamma, T, options,dim);
disp(' 3b) Fractional occupancy extracted.')

% 3c) Viterbi path
[Gamma,Xi] = hmmdecode(DataCll,T,hmm,0); 
[viterbipath] = hmmdecode(DataCll,T,hmm,1);
disp( ' 3c) Viterbi path generated.')

% % 3d) Visualising Brain States
k = [1:options.K]; %specifies which states to visualise
%parcellation_struct = load_nii('/Users/judy/nilearn_data/yeo_2011/Yeo_JNeurophysiol11_MNI152/Yeo2011_17Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz');
%parcellation_file = parcellation_struct.img;
parcellation_file = load_nii('/Users/judy/nilearn_data/yeo_2011/Yeo_JNeurophysiol11_MNI152/Yeo2011_17Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz');
%parcellation_file = load([directories.dataDir,'yeo_2011/Yeo_JNeurophysiol11_MNI152/Yeo2011_17Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz'], "")
onconnectivity = 0;
maps = makeMap(hmm,k,parcellation_file,onconnectivity)
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