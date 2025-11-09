%% Plot Figures

%input
% options

% sort Gamma into healthy vs psychosis groups

% compute start and end indices per subject
Tvector = [T{:}]-1;

endIdx   = cumsum(Tvector);
startIdx = cumsum([1, Tvector(1:end-1)]);

%% sort Gamma into groups
group_id = pcnsDataTable.group;
Gamma_group1health = [];
Gamma_group2psych = [];

for i = 1:length(T)
    rows = startIdx(i):endIdx(i);
    if group_id(i) == 1
        Gamma_group1health = [Gamma_group1health; Gamma(rows, :)];
    elseif group_id(i) == 2
        Gamma_group2psych = [Gamma_group2psych; Gamma(rows, :)];
    end
end


%%
T_group1health = repmat(327,sum(pcnsDataTable.group == 1),1);
T_group2psych = repmat(327,sum(pcnsDataTable.group == 2,1),1);

order_trials = false;  % order the trials?
behaviour = [];  % behaviour with respect to which order the trials 

cm = jet(options.K);

%% plot figures
% HEALTHY
continuous = length(T_group1health)==1 || any(T_group1health(1)~=T_group1health); % show it as continuous data? 

figure;
plot_Gamma(Gamma_group1health,T_group1health, continuous, order_trials, behaviour, cm);
sgtitle('Controls', 'FontSize', 16, 'FontWeight', 'bold');
% Get all axes in the figure
axs = findall(gcf, 'type', 'axes');

% axs might be in reverse order (last subplot first), but xlim works regardless
for ax = axs'
    xlim(ax, [0 262]);   % set x-axis limits for both subplots
end

% PSYCHOSIS
continuous = length(T_group2psych)==1 || any(T_group2psych(1)~=T_group2psych); % show it as continuous data? 

figure;
plot_Gamma(Gamma_group2psych,T_group2psych, continuous, order_trials, behaviour, cm);
sgtitle('Schizophrenia/Schizoaffective Disorder Diagnosis', 'FontSize', 16, 'FontWeight', 'bold');
xlim([0,262])
% Get all axes in the figure
axs = findall(gcf, 'type', 'axes');

% axs might be in reverse order (last subplot first), but xlim works regardless
for ax = axs'
    xlim(ax, [0 262]);   % set x-axis limits for both subplots
end

%% colour legend

% Number of states
K = options.K;

% Get the default colormap used by plot_Gamma
cm = jet;  % default is parula
idx = round(linspace(1, size(cm,1), K));
colors = cm(idx,:);  % 9x3 RGB matrix

% Create figure for color key
figure('Color','w'); 
hold on;

% Plot colored rectangles for each state
for k = 1:K
    rectangle('Position',[k,0,1,1], 'FaceColor', colors(k,:), 'EdgeColor','k');
    text(k+0.5, 0.5, sprintf('State %d', k), 'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', 'FontSize', 12);
end

xlim([0 K+1]);
ylim([0 1]);
axis off;
title('HMM State Color Key','FontSize',14);
hold off;
