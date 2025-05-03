### IMPORTS
from nilearn import datasets
from nilearn.maskers import NiftiLabelsMasker

import matplotlib.pyplot as plt
import numpy

import os
from datetime import datetime


#### PARCELLATION

# Get example fMRI data
data1 = datasets.fetch_development_fmri(n_subjects=1, reduce_confounds=True)
fmri_filename1 = '/Users/judy/Documents/Research/Code/test_sub.nii'

#Get Atlas
dataset = datasets.fetch_atlas_yeo_2011(data_dir=None, url=None, resume=True, verbose=1)
atlas = dataset.thick_17  # Using the 17-network version
label_names = [f"Network_{i}" for i in range(1, 18)]  # Create network labels 1-17


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

#Parcellation via fit_transform function
time_series = masker.fit_transform(fmri_filename1) #array of shape (n_timepoints, n_labels), containing the "parcel-mean" values at each time point

### POST PARCELLATION

# Save parcellated data
numpy.savetxt(fname='Yeo_parcellated_test_sub.txt', X=time_series)

#Plot Heatmap Time-series across ROIs
heatmapname = 'Heatmap of Time Series Across ROIs post-parcellation for Yeo-17-thick'
plt.figure(figsize=(12, 8))
plt.imshow(time_series.T, aspect='auto', cmap='viridis', origin='lower')
plt.colorbar(label='Signal (z-score)')
plt.title(heatmapname)
plt.xlabel('Time Points')
plt.ylabel('ROIs')
# Set Y-axis ticks starting from 1
n_rois = time_series.shape[1]
plt.yticks(ticks=numpy.arange(n_rois), labels=numpy.arange(1, n_rois + 1))

# Save Heatmap
title_label = heatmapname # Retrieve the title label as a string
timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S') #create timestamp
filename = title_label.replace(" ", "_").replace(":", "") + timestamp + '.png' # Clean up the title string to be a valid filename (remove spaces, special characters, etc.)
plt.savefig(os.path.join( "/Users/judy/Video_HMM/Outputs/Parcellation_Figures", filename), format='png')

#Show
plt.show()
