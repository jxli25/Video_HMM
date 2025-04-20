%% 1) Setting parameters
nrep = 1;
sim_state_tcs_only = 0;


%% 2) Creating simulation
[genX,genT,genGamma] = simhmmmar(T{1},hmm,Gamma,nrep,sim_state_tcs_only);

%% 3) Graphing simulated and actual observations

figure;
for ch = 1:17
    subplot(5, 4, ch);  % 5x4 grid for 17 subplots
    plot(DataCll{1}(:, ch), 'b');
    hold on;
    plot(genX(:, ch), 'r');
    title(['ROI ', num2str(ch)]);
    xlabel('Time');
    ylabel('Signal');
    if ch == 1
        legend('Actual Observations', 'simhmmmar Observations');
    end
end


%% 4) Statistically testing datapoints from simulation compared to actual data

% Using two sample t-test (independent)

% (could use hmmtest however one of the inputs is hmm which would be
% difficult to construct given second sample is from simhmmmar)


p_values = zeros(17,1);
for ch = 1:17
    [h, p] = ttest2(DataCll{1}(:, ch), genX(:, ch));
    p_values(ch) = p;
end

% Display significant channels
disp('Significant channels (p < 0.05):');
find(p_values < 0.05)