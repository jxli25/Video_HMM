function maps = makeMap_custom(hmm, k, parcellation_file, maskfile, centermaps, scalemaps, outputfile)
% Custom makeMap for shareddiag HMMs
% Projects HMM state maps into voxel space using the parcellation
%
% hmm: HMM struct (shareddiag)
% k: states to map (e.g., 1:9)
% parcellation_file: nifti parcellation (voxels x parcels)
% maskfile: brain mask for nifti
% centermaps: 0/1, subtract mean across states
% scalemaps: 0/1, scale to unit variance across states
% outputfile: path to save voxel maps (.nii.gz)

if nargin < 5 || isempty(centermaps), centermaps = 0; end
if nargin < 6 || isempty(scalemaps), scalemaps = 0; end
if nargin < 7 || isempty(outputfile), outputfile = './map'; end

% Load NIfTI parcellation
NIFTI = parcellation(parcellation_file);
spatialMap = NIFTI.to_matrix(NIFTI.weight_mask); % voxels x parcels
num_voxels = size(spatialMap,1);
num_parcels = size(spatialMap,2);

% Normalize parcellation columns
for j = 1:num_parcels
    spatialMap(:,j) = spatialMap(:,j) / max(spatialMap(:,j));
end

% Select states
if isempty(k), k = 1:length(hmm.state); end
K = length(k);

% Preallocate
mapsParc = zeros(num_parcels, K);

% Fill in mapsParc with diagonal of Mu_W (mean activation per parcel)
for idx = 1:K
    state_idx = k(idx);
    mapsParc(:,idx) = diag(hmm.state(state_idx).W.Mu_W);
end

% Project to voxel space
maps = spatialMap * mapsParc;

% Center maps if requested
if centermaps
    maps = maps - mean(maps,2);
end

% Scale maps if requested
if scalemaps
    maps = maps ./ std(maps,[],2);
end

% Save as NIfTI
[mask,res,xform] = nii.load(maskfile);
nii.save(matrix2vols(maps,mask), res, xform, outputfile);

end
