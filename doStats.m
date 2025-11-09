%% 6)

%INPUTS: 
% options
% pcnsDataTable
%
% OUTPUTS:
% 
%

%function [] = doStats(FractionalOccupancy)

%% 6a) Transition Probabilities

% I) Apply threshold of 20% to identify the most frequent transitions, and visualise this.

% II) Analyse differences between the clinical and control group for each transition probability (# BS x # BS matrix) using t-tests.

%% 6b.I) T tests - across entire video

% I)Sort Data
% X = Data = FractionalOccupancy
% group = group vector
    %group_id = pcnsDataTable.group;
% alpha = significance level
    alpha = 0.05;

% II) Conduct t tests

% sort data into psychosis vs healthy cells

combined_FO = ['participant_id','group_id', cellstr(compose("FO%d", 1:options.K));
     num2cell(pcnsDataTable.ID), num2cell(pcnsDataTable.group), num2cell(FractionalOccupancy)];
psychosis_FO = ['participant_id','group_id', cellstr(compose("FO%d", 1:options.K))];
healthy_FO = ['participant_id','group_id', cellstr(compose("FO%d", 1:options.K))];

for i = 2:size(combined_FO,1); 
    if combined_FO{i,2} == 1; %if participant is healthy
        healthy_FO = [healthy_FO; combined_FO(i,:)];
    else
        psychosis_FO = [psychosis_FO; combined_FO(i,:)];
    end
end

% convert cells into structures ...



%% loop through all K FOs and do t tests

% Create an empty table
varNames = {'FO_num','h','p','ci', 'tstat', 'df', 'sd'};

FO_tstatsTable = table('Size',[0,length(varNames)], ...    % 0 rows, number of columns
          'VariableTypes', {'double','double','double','double','double','double', 'double'}, ...
          'VariableNames', varNames);

for i = 3:options.K+2
    % t test for this FO
    [h,p,ci,stats] = ttest([healthy_FO{2:33,i}], [psychosis_FO{2:33,i}]);

    % save to FO_tstats
    newRow = table(i-2, h, p, ci, stats.tstat, stats.df, stats.sd,  ...
    'VariableNames', FO_tstatsTable.Properties.VariableNames);
    FO_tstatsTable = [FO_tstatsTable; newRow];
end

%% FDR

pvals = FO_tstatsTable.p;
% Suppose pvals is a vector of your 9 p-values
adj_p = mafdr(pvals, 'BHFDR', true);  % Benjamini-Hochberg FDR correction
FO_tstatsTable.adj_p = [adj_p];

% Determine which are significant at alpha = 0.05
h_fdr = adj_p < 0.05;
FO_tstatsTable.h_fdr = [h_fdr];
% correct for FDR

%% Make table
writetable(FO_tstatsTable, 'FO_tstatsTable.xlsx');






%[d, p, stats] = manova1(FractionalOccupancy, group_id, alpha)

%% NOT VALID - 6b.II) Fractional Occupancy - by segment

% I) Get segmented data and calculate FO of each BS for each segment within each group. 

% There are 9 segments and 327 time points

% Divide the 327 time points into 9 segments

% Take each segment, divide into psychosis vs healthy (FO of each brain
% state is intact)

% II) Conduct MANOVA 9 times (9 segments)

% 2 groups - psychosis vs healthy

% K dependent variables - FO of each brain state (sum to K) for this
% segment

% input data:
% data = n x K matrix where n = # observations (ie # of time points in segment), p = # dependent
% variables
% e.g. data = [each participant makes one row of all their FOs in this
% segment, each column is one brain state out of K]
% group = vector indicating which group each participant (ie each row)
% belongs to

% run MANVOA for each segment (9 times)
% output = d = manova1(data, group);

% After all 9 MANOVA are run, apply correction


% III) If a significant effect is found, interpret using post-hoc t-tests. 


%% 6c) Switching Rates

% I) Perform t-test on SRs between clinical vs control groups.

%% 6d) Cardiac Response

% I) Analyse  difference between groups using mANCOVA 

% II) If a significant effect is found, interpret using post-hoc t-tests. 

%% 6e) Severity Scores

% I) Pearson's correlation coefficient between SR and PANSS, HDRS, CGI-S AND SOFAS