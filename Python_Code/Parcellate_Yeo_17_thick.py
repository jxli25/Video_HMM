### IMPORTS
from nilearn import datasets
from nilearn.maskers import NiftiLabelsMasker

import numpy

# import matplotlib.pyplot as plt

# import os
# from datetime import datetime


#### PARCELLATION

#Get Atlas
dataset = datasets.fetch_atlas_yeo_2011(data_dir=None, url=None, resume=True, verbose=1)
atlas = dataset.thick_17  # Using the 17-network version
label_names = [f"Network_{j}" for j in range(1, 18)]  # Create network labels 1-17

#Settings for NiftiLabelsMasker
masker = NiftiLabelsMasker( #class w variables and functions (e.g. fit_transform)
                           
#Preprocessing settings
    labels_img=atlas,
    standardize='zscore_sample', #"zscore_sample", #Z scores the voxels to make mean = 0
    memory="nilearn_cache",
    verbose=5,
    
#Temporal filter settings
    high_pass=0.01,  # High pass frequency in Hz
    low_pass=0.15,   # Low pass frequency in Hz
    t_r=0.8         # Repetition time in seconds
    ) 

###Create loop to go through files iteratively

print ("1. go to the loop")

for i in range (1, 5): 

    # Get fMRI data
    #fmri_filename1 = f"/Volumes/USB_1TB/x_psychosis_data/fmriprep_aroma_movie/sub-{i:03d}/func/sub-{i:03d}_task-movie_run-01_space-MNI152NLin6Asym_res-2_desc-brain_mask.nii.gz"
    fmri_filename1 = f"/Volumes/USB_1TB/x_psychosis_data/fake_data/fake_postprocessed/fake_sub_{i:03d}.nii"
    
    print (f"2. inside loop where i = {i}")
    #Parcellation via fit_transform function
    time_series = masker.fit_transform(fmri_filename1) #array of shape (n_timepoints, n_labels), containing the "parcel-mean" values at each time point
    
    # Save parcellated data
    #numpy.savetxt(fname= f"/Volumes/USB_1TB/x_psychosis_data/parcellated_subs/parcellated_sub{i:03d}", X=time_series)
    numpy.savetxt(fname= f"/Volumes/USB_1TB/x_psychosis_data/fake_data/fake_parcellated/fake_parcellated_sub{i:03d}.txt", X=time_series)
                 

### BELOW IS FURTHER VISUALISATION IF DESIRED

# #Plot Heatmap Time-series across ROIs
# heatmapname = 'Heatmap of Time Series Across ROIs post-parcellation for Yeo-17-thick'
# plt.figure(figsize=(12, 8))
# plt.imshow(time_series.T, aspect='auto', cmap='viridis', origin='lower')
# plt.colorbar(label='Signal (z-score)')
# plt.title(heatmapname)
# plt.xlabel('Time Points')
# plt.ylabel('ROIs')
# # Set Y-axis ticks starting from 1
# n_rois = time_series.shape[1]
# plt.yticks(ticks=numpy.arange(n_rois), labels=numpy.arange(1, n_rois + 1))

# # Save Heatmap
# title_label = heatmapname # Retrieve the title label as a string
# timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S') #create timestamp
# filename = title_label.replace(" ", "_").replace(":", "") + timestamp + '.png' # Clean up the title string to be a valid filename (remove spaces, special characters, etc.)
# plt.savefig(os.path.join( "/Users/judy/Video_HMM/Outputs/Parcellation_Figures", filename), format='png')

# #Show
# plt.show()
