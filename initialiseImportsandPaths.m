%% 0) initialiseImportsandPaths generates paths required for rest of computation
%
%INPUTS: none
%
%OUTPUTS: 'directories' struct with paths to data required for computation
%

function directories = initialiseImportsandPaths

disp('--------0) Initialising imports and generating paths--------')

addpath(genpath(pwd)); % adds current path
addpath(genpath([pwd,'Parcellation_Figures']));
codeDir = pwd;
cd ../;
mainDir = pwd;
cd(codeDir);

[~, uid] = unix('whoami');

directories = struct();

switch uid(1: end-1)

    case 'kwellste'

        disp('User identified as kwellste.')

        options.OS = 'Mac';
        options.PC = 'Macbook';
        
        directories.dataDir    = [mainDir,filesep,'data_HMM',filesep]; % this is what I called the folder where I stored the data you sent me
        directories.toolboxDir = [mainDir,filesep,'Toolboxes',filesep,'HMM-MAR-master',filesep]; % this is where I store the toolbox but you may have oranised that differently
        addpath(genpath('/Users/judy/HMM-MAR-master')) %not sure why the above isn't working, but this line works for me
        addpath(genpath(dataDir)); 
        addpath(genpath(toolboxDir));

        disp ('directories generated.')


        % May need Tools for Nifti and ANALYZE package for Neurosynth
        % visualisation in 3)



         

    case 'judy' 
        disp('User identified as judy.')

        options.OS = 'Mac';
        options.PC = 'Macbook';
        
        directories.dataDir    = ['/Users/judy/data_HMM',filesep];
        addpath(genpath('/Users/judy/HMM-MAR-master'));
        addpath(genpath(directories.dataDir));
        addpath(genpath('/Users/judy/nilearn_data/yeo_2011/Yeo_JNeurophysiol11_MNI152'));
    
        disp ('directories generated.')
end



