% Generate data with known underlying hidden states to test hmmmar model

%% 0) Inputs

num_hidden_states = 3; % change to desired number of hidden states for test data

%% 1) Generate transition probability matrix

% Initialise Nan transition probability matrix of required size (currently
% 3x3)

mtrx_transProb = nan(num_hidden_states,num_hidden_states); 

% Create matrix of probabilities with same rows and columns - 1 to mtrx_transProb,
% sum probability of rows = 1

mtrx_Prob = rand(min(size(mtrx_transProb)), min(size(mtrx_transProb))-1);
rowsums_mtrx_Prob = sum(mtrx_Prob, 2);

for i = 1:max(size(mtrx_Prob)) % row counter for mtrx_Prob
    for j = 1:min(size(mtrx_Prob))% column counter for mtrx_Prob
        mtrx_Prob(i,j) = mtrx_Prob(i,j)/rowsums_mtrx_Prob(i);
    end
end


% Populate mtrx_transProb with mtrx_Prob, set diagonals to 0

k = 1; %initialising k for nested loop below

for i = 1:min(size(mtrx_transProb)) % row counter for transition probability matrix
    for j = 1:min(size(mtrx_transProb)) % column counter for transition probability matrix
        % for i,j of mtrx_transProb:
        if i == j % set diagonals to zero
            mtrx_transProb(i,j) = 0;
        else % set i,j to corresponding i,k
            if k == min(size(mtrx_Prob)) + 1 % column counter for mtrx_Prob
                k = 1;
            end
            mtrx_transProb(i,j) = mtrx_Prob(i,k);
            k = k + 1;
        end
    end
end
          

%% 2) Generate ???
