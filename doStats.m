%% 6)

%INPUTS: 
% 
%
% OUTPUTS:
% 
%

function [] = doStats()

%% 6a) Transition Probabilities

% I) Apply threshold of 20% to identify the most frequent transitions, and visualise this.

% II) Analyse differences between the clinical and control group for each transition probability (# BS x # BS matrix) using t-tests.

%% 6b) Fractional Occupancy

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
% e.g. data = [ each participant makes one row of all their FOs in this
% segment, each column is one brain state out of K ]
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