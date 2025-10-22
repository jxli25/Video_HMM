#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 13 10:12:44 2025

@author: judy
"""
from nimare.dataset import fetch_neurosynth
from nimare.decode import CorrelationDecoder
import nibabel as nib

# 1. Fetch a Neurosynth dataset
dset = fetch_neurosynth(version='7')

# 2. Load your own unthresholded fMRI map
img = nib.load('my_stat_map.nii.gz')

# 3. Initialize the decoder
decoder = CorrelationDecoder(
    features='neurosynth',  # Use terms from the Neurosynth dataset
    target_image=img
)

# 4. Fit the decoder to the dataset
decoder.fit(dset)

# 5. Run decoding
results = decoder.transform(img)

# 6. Inspect the output
print(results.sort_values(by='correlation', ascending=False).head())

#https://nbclab.github.io/nimare-paper/12_decoding.html?utm_source=chatgpt.com

#https://nimare.readthedocs.io/en/0.0.11/generated/nimare.decode.continuous.CorrelationDecoder.html#nimare.decode.continuous.CorrelationDecoder