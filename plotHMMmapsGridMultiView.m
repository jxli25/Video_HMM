function plotHMMmapsGridMultiView(nifti_file, slice_sag, slice_cor)
% PLOTHMMMAPSGRIDMULTIVIEW - Visualize sagittal & coronal views 
% for all HMM states in a grid.
%
% nifti_file : path to 'my_maps.nii.gz'
% slice_sag  : X-index for sagittal slice
% slice_cor  : Y-index for coronal slice

% Load data

img = niftiread(nifti_file);
info = niftiinfo(nifti_file);

dims = size(img);
if numel(dims) < 4
    error('Expected a 4D NIfTI file with states in 4th dim.');
end

num_states = dims(4);

% Default slice choices
if nargin < 2 || isempty(slice_sag)
    slice_sag = round(dims(1)/2);
end
if nargin < 3 || isempty(slice_cor)
    slice_cor = round(dims(2)/2);
end


% Global min/max for color scaling

cmin = min(img, [], 'all');
cmax = max(img, [], 'all');


% Figure setup

figure('Name', 'Sagittal + Coronal Views', 'Color', 'w', ...
       'Position', [100 100 1100 300*num_states]);

% Grid: states down rows, 2 views across columns
for s = 1:num_states

    % ---- SAGITTAL SLICE (X fixed) ----
    sliceSag = squeeze(img(slice_sag,:,:,s));
    sliceSag = flipud(sliceSag);  % orientation correction

    subplot(num_states, 2, (s-1)*2 + 1);
    imagesc(sliceSag, [cmin cmax]);
    axis image off;
    title(sprintf('State %d – Sagittal (X=%d)', s, slice_sag), 'FontSize', 12);

    % ---- CORONAL SLICE (Y fixed) ----
    sliceCor = squeeze(img(:,slice_cor,:,s));
    sliceCor = flipud(sliceCor);  % orientation correction

    subplot(num_states, 2, (s-1)*2 + 2);
    imagesc(sliceCor, [cmin cmax]);
    axis image off;
    title(sprintf('State %d – Coronal (Y=%d)', s, slice_cor), 'FontSize', 12);

end


% Shared colormap + colorbar

colormap(parula);

cb = colorbar('Position', [0.93 0.1 0.02 0.8]);
cb.Label.String = 'Activation';
cb.FontSize = 12;

sgtitle('HMM State Maps – Sagittal + Coronal Views', 'FontSize', 18);

end
