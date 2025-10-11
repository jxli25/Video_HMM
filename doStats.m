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

% II) Conduct MANOVA

% III) If a significant effect is found, interpret using post-hoc t-tests. 

%% 6c) Switching Rates

% I) Perform t-test on SRs between clinical vs control groups.

%% 6d) Cardiac Response

% I) Analyse  difference between groups using mANCOVA 

% II) If a significant effect is found, interpret using post-hoc t-tests. 

%% 6e) Severity Scores

% I) Pearson's correlation coefficient between SR and PANSS, HDRS, CGI-S AND SOFAS