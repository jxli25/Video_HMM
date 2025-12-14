function plotHMMmapsGrid(nifti_file, slice_index, orientation)
% PLOTHMMMAPSGRID - Visualize all HMM states in a grid for one slice.
% Supports axial, sagittal, and coronal orientations.
%
% nifti_file  : path to 'my_maps.nii.gz'
% slice_index : slice index (defaults to middle slice)
% orientation : 'axial' (default), 'sagittal', or 'coronal'

% -----------------------------
% Load the NIfTI data
% -----------------------------
img = niftiread(nifti_file);
info = niftiinfo(nifti_file);

dims = size(img);
if numel(dims) < 4
    error('The NIfTI file does not have multiple states (4th dimension).');
end

num_states = dims(4);

% -----------------------------
% Orientation handling
% -----------------------------
if nargin < 3 || isempty(orientation)
    orientation = 'axial';  % default
end
orientation = lower(orientation);

switch orientation
    case 'axial'
        dim = 3;
    case 'coronal'
        dim = 2;
    case 'sagittal'
        dim = 1;
    otherwise
        error('Orientation must be ''axial'', ''sagittal'', or ''coronal''.')
end

% Default slice: middle of chosen dimension
if nargin < 2 || isempty(slice_index)
    slice_index = round(dims(dim)/2);
end

% -----------------------------
% Global min/max for color scaling
% -----------------------------
switch orientation
    case 'axial'
        cmin = min(img(:,:,slice_index,:), [], 'all');
        cmax = max(img(:,:,slice_index,:), [], 'all');
    case 'coronal'
        cmin = min(img(:,slice_index,:,:), [], 'all');
        cmax = max(img(:,slice_index,:,:), [], 'all');
    case 'sagittal'
        cmin = min(img(slice_index,:,:,:), [], 'all');
        cmax = max(img(slice_index,:,:,:), [], 'all');
end

% -----------------------------
% Determine grid size
% -----------------------------
cols = ceil(sqrt(num_states));
rows = ceil(num_states / cols);

figure('Name', sprintf('%s slice = %d', orientation, slice_index), ...
       'NumberTitle', 'off', 'Color', 'w', ...
       'Position', [100, 100, 300*cols, 300*rows]);

% -----------------------------
% Plot each state
% -----------------------------
for s = 1:num_states
    subplot(rows, cols, s);

    switch orientation
        case 'axial'
            slice = squeeze(img(:,:,slice_index,s));
            imagesc(slice', [cmin cmax]);  % transpose for display

        case 'coronal'
            slice = squeeze(img(:,slice_index,:,s));
            imagesc(slice', [cmin cmax]);  % transpose for display

        case 'sagittal'
            slice = squeeze(img(slice_index,:,:,s));
            imagesc(slice', [cmin cmax]);  % transpose for display
    end

    axis image; axis off;
    title(['State ' num2str(s)], 'FontSize', 12);
end

% Colormap
colormap(parula);

% Single shared colorbar
cb = colorbar('Position', [0.93 0.1 0.02 0.8]);
cb.Label.String = 'Activation';
cb.FontSize = 12;

sgtitle(sprintf('HMM maps - %s slice = %d', orientation, slice_index), 'FontSize', 16);

end
