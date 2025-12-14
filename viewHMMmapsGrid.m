function viewHMMmapsGrid(nifti_file)
% VIEWHMMMAPSGRID - Interactive viewer for 3D/4D HMM maps in a grid
% White background and parula colormap
%
% nifti_file : path to 'my_maps.nii.gz'

% Load NIfTI data
img = niftiread(nifti_file);
info = niftiinfo(nifti_file);

dims = size(img);
if numel(dims) < 4
    img = reshape(img, [dims 1]); % treat as single-state
end

num_states = dims(4);
slice_idx = round(dims(3)/2);

% Precompute global min/max for color scaling
cmin = min(img(:));
cmax = max(img(:));

% Create figure with white background
f = figure('Name','HMM Maps Grid Viewer','NumberTitle','off','Color','w',...
           'KeyPressFcn', @keyPress);

% Compute grid size (rows x cols)
cols = ceil(sqrt(num_states));
rows = ceil(num_states/cols);

% Display initial slice
h = gobjects(num_states,1);
for s = 1:num_states
    h(s) = subplot(rows, cols, s);
    imagesc(squeeze(img(:,:,slice_idx,s)), [cmin cmax]);
    axis image off;
    set(gca,'Color','w');          % Set axes background to white
    colormap(gca, parula);         % Set colormap to parula
    title(['State ' num2str(s)], 'Color', 'k');  % Title in black
end

% Add a single shared colorbar on the right
cb = colorbar('Position',[0.92 0.1 0.02 0.8]);
caxis([cmin cmax]);
ylabel(cb,'Activation');

% Keypress callback
function keyPress(~, event)
    switch event.Key
        case 'uparrow'
            slice_idx = min(slice_idx+1, dims(3));
        case 'downarrow'
            slice_idx = max(slice_idx-1, 1);
        otherwise
            return
    end
    for s = 1:num_states
        subplot(rows, cols, s);
        imagesc(squeeze(img(:,:,slice_idx,s)), [cmin cmax]);
        axis image off;
        set(gca,'Color','w');          % White background
        colormap(gca, parula);         % Parula colormap
        title(['State ' num2str(s)], 'Color', 'k');
    end
    suptitle(['Slice Z = ' num2str(slice_idx)]);
end

disp('Use arrow keys: ↑/↓ to change slice. All states shown in a grid.');
end
