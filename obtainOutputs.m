%% 3) Analyse Results

%INPUTS: 
% 3a) options, hmm
% 3b) Gamma, T, options
% 3c) DataCll, T
% 3d) @@ WIP @@
%
% OUTPUTS:
% 3a) Transition probabilities (table will be saved to specified filepath)
% 3b) FractionalOccupancy
% 3c) Viterbi path vector
% 3d) Switching Rates
%

function [TransitionProbabilities, FractionalOccupancy, ViterbiPath, SwitchingRates] = obtainOutputs(options, hmm, Gamma, T, DataCll,vpath)

disp( '--------3) Creating outputs --------')

%% 3a) Transition probabilities & Table

TransitionProbabilties = getTransProbs(hmm)

ColumnNms = {};
for ColNum = 1:options.K
    ColumnNms{ColNum} = ['Transition to State ', num2str(ColNum)];
end
TransitionWndw = uifigure('Position', [100, 100, 500, 300]); %Creates new figure window
t = uitable(TransitionWndw, 'Data', getTransProbs(hmm), 'ColumnName', ColumnNms, 'Position', [20, 20, 460, 220]); %Greates new table in window

t.FontSize = 12;  % Increase font size
t.FontName = 'Arial';  % Change font
t.RowName = 'numbered';  % Add numbered row names

% Save table

% Extract and convert
tableData = t.Data;
TableToSave = array2table(tableData);
TableToSave.Properties.VariableNames = t.ColumnName;
% Add column labels to saved table: TableToSave = [table( cell2mat(ColumnNms) , 'VariableNames', {'Current State'}), T];
% Save location
folderPath = '/Users/judy/Video_HMM/Outputs/OutputsFromHMM_Wrapper';
fileName = ['TransitionProbabilities_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.csv'];
fullPath = fullfile(folderPath, fileName);
% Save the table
writetable(TableToSave, fullPath);


disp([' 3a) Transition Probabilities table created and saved to', folderPath])

%% 3b) Fractional Occupancy
dim = 2; 
FractionalOccupancy = getFractionalOccupancy(Gamma, T, options, dim);
filename = ['/Users/judy/Video_HMM/Outputs/OutputsFromHMM_Wrapper/FractionalOccupancy_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.txt'];
writematrix(FractionalOccupancy, filename)
if dim == 1
    disp (' 3b) Fractional occupancy **at each time point** saved to same path.')
else
    disp (' 3b) Fractional occupancy **for each trial (i.e. individual)** saved to same path.')
end

%% 3c) Viterbi path

ViterbiPath = vpath

filename = ['/Users/judy/Video_HMM/Outputs/OutputsFromHMM_Wrapper/ViterbiPath_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.txt'];
writematrix(vpath, filename)
disp( ' 3c) Viterbi path saved to same path.')

%% 3d) Switching Rates

SwitchingRates = getSwitchingRate
