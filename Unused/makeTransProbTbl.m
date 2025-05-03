%% 3a) Transition probabilities Table
%
%INPUTS: 
% options
% hmm
%
%OUTPUTS:
% table in figure pop out window

function makeTransProbTbl(options, hmm)

ColumnNms  = cell(options.K,1);
for ColNum = 1:options.K
    ColumnNms{ColNum} = ['Transition to State ', num2str(ColNum)];
end
TransitionWndw = uifigure('Position', [100, 100, 500, 300]); %Creates new figure window
t = uitable(TransitionWndw, 'Data', getTransProbs(hmm), 'ColumnName', ColumnNms, 'Position', [20, 20, 460, 220]); %Greates new table in window

t.FontSize = 12;  % Increase font size
t.FontName = 'Arial';  % Change font
t.RowName = 'numbered';  % Add numbered row names

% Save table

disp(' 3a)Transition Probabilities table created.')