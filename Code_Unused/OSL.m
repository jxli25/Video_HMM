%% ==========================
%  OSL Startup Patch for macOS
%% ==========================

% 1. Clear previous environment variables
setenv('OSLDIR','');
setenv('OSLCONF','');

% 2. Define OSL core and config folders
osl_core = '/Users/judy/osl-core/';       % your OSL installation
osl_config_folder = '/Users/judy/osl-config/';  % writable folder for config

% 3. Add OSL to MATLAB path
addpath(genpath(osl_core));

% 4. Create config folder if it doesn't exist
if ~exist(osl_config_folder,'dir')
    mkdir(osl_config_folder);
end

%% 5. Patch +osl_conf/find.m for macOS writable config
find_file = fullfile(osl_core,'+osl_conf','find.m');

% Read original file
fid = fopen(find_file,'r');
if fid == -1
    error('Cannot open %s', find_file);
end
lines = textscan(fid,'%s','Delimiter','\n','Whitespace','');
lines = lines{1};
fclose(fid);

% Look for the line that contains "if ~osl_util.isfile(f)"
idx = find(contains(lines,'if ~osl_util.isfile(f)'));

if isempty(idx)
    warning('Could not find the creation block to patch. Please check find.m manually.');
else
    % Insert patch immediately after that line
    patch_lines = {
        '        if isempty(f)'
        sprintf('            f = fullfile(''%s'',''osl.conf'');', osl_config_folder)
        '        end'
        };
    lines = [lines(1:idx); patch_lines; lines(idx+1:end)];
    
    % Write back to file (overwrite)
    fid = fopen(find_file,'w');
    fprintf(fid,'%s\n',lines{:});
    fclose(fid);
    
    disp('Patched +osl_conf/find.m to write osl.conf to a writable folder.');
end

%% 6. Ensure environment variables are clear
setenv('OSLCONF','');
setenv('OSLDIR', osl_config_folder);

% Replace with your actual FSL install path
setenv('FSLDIR','/Users/judy/fsl');
setenv('PATH',[getenv('FSLDIR') '/bin:' getenv('PATH')]);


%% 7. Start OSL
osl_startup;

%% 8. Verify functions are available
disp('Verifying key OSL functions...');
which parcellation
which osl_braingraph

disp('OSL startup complete. You can now run makeMap or makeBrainGraph.');


