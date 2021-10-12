# Kidney MRI segmentation examples #

> Accompanying publication: https://ieeexplore.ieee.org/document/9427136

To illustrate the properties of kidney MR images, as well as the operation and performance of selected methods for their segmentation, numerical examples were presented in Section III of the review paper [1]. To work them out, a volume of interest (VOI) containing the subject right-kidney was segmented using intensity thresholding, seeded region growing, level-set algorithms and basic mathematical morphology operations. The results are presented in Figs. 3-9 [1] and discussed in detail there. They were then quantitatively compared with the ground-truth information in Table 1 [1], using the metrics defined in Section IV [1]. The purpose of this repository is to provide the interested readers with the processed image data and developed code - for deeper understanding of the background and to facilitate further experimentation in this hot topic. 

In the examples, the selected methods of image segmentation were applied to T1-weighted (T1w) and T2-weighted (T2w) images stored in the publicly available CHAOS database https://zenodo.org/record/3431873#.X8SwTM1KiUk [2]:   

![CHAOS image datasets logo](https://github.com/am-49/pierwsze/blob/main/png/CHAOS-1.png)

There are 40 CT and MR 3D abdominal images in CHAOS datasets, acquired for healthy subjects, split evenly into train and test sets. The DICOM files stored for subject #1 in the train set, along with the corresponding ground-truth PNG slices, were used for analysis here.

The code was split into short scripts saved as m-files, easily identifiable with the elements of Sections III and IV of [1]:

File name  | Purpose | Uses
------------- | ------------- | -------------
kid_seg_a.m  | Make NIFTI files |
kid_seg_b.m  | Extract VOI |
kid_seg_c.m  | Process images for Fig. 4 in [1] |
kid_seg_d.m  | ... Fig. 5 |
kid_seg_e.m  | ... Fig. 6 |
kid_seg_f.m  | ... Fig. 7, Fig. 8, Tab. 1 | largestCC.m, objCentroid.m, regionGrowing.m, segMetrics.m, getContour2D.m
kid_seg_g.m  | ... Tab. 1 | getContour3D.m

## Materials and methods

The example computations were done in 3 steps: collecting 3D image NIFTI files, extracting right-kidney VOIs, VOI analysis and segmentation. 

### 1. Collecting NIfTI volumes

T1w, T2w and ground-truth (GT) 3D volumes were first extracted from the downloaded compressed data **CHAOS_Train_Sets.zip**, as follows.

**1.1** The ITK-SNAP [3] application was used to read the 35 DCM files contained in the unpacked directory **Train_Sets/MR/1/T1DUAL/DICOM_anon/InPhase/**  and to save the corresponding image as **T1_1.nii** volume. It contains 35 slices, each of 256x256 pixels, with voxel size of 1.894531250 mm x 1.894531250 mm x 5.5 mm. The top-left picture in the figure below is the slice #16, visualized in the example window of the ITK-SNAP program.

![T1_1.nii file opened in ITK-SNAP window](https://github.com/am-49/pierwsze/blob/main/png/T1_1_x.png)

**1.2** In the same way, **T2_1.nii** volume was extracted from **Train_Sets/MR/1/T2SPIR/DICOM_anon/** and saved. This volume is composed of 36, 7.7-mm-thick slices, each containing 256 x 256 square pixels, of 1.54297 mm side length.

**1.3** The ITK-SNAP software was used again to co-register the T2w volume with T1w one. The T2w was the "moving" image, mutual information served as the similarity metric. The "multiresolution schedule" comprised scales from 8x downto 1x. The moving image was finally resampled with the use of linear interpolation to the T1w mesh and saved as **/img/T2_1r.nii**. Example sections of this volume opened in ITK-SNAP is shown below.

![T2_1r.nii file opened in ITK-SNAP window](https://github.com/am-49/pierwsze/blob/main/png/T2_1r_x.png)

Thus obtained three 256x256x35 MR images are available in this repository inside the **/img/** folder.

**1.4** A MATLAB:registered: code was written to save the CHAOS expert ground-truth PNG annotations in a NIfTI file, of the same structure as the T1w (**/img/T1_1.nii**) and T2w (**/img/T2_1r.nii**) files. The code is stored in the **kid_seg_a.m** script. It makes use of selected functions available from Mathworks:registered: [4], stored in **/nii/** folder. There are four organ regions labelled by the experts: liver (_I_=63), right kidney (_I_=126), left kidney (_I_=189) and spleen (_I_=252), where _I_ is the PNG image intensity. After setting down the intensity of liver and spleen regions to zero, the script saves the two kidneys ground-truth segmentation for subject #1 in **/img/GT_1.nii** file. 

The following figure shows the **/img/T1_1.nii** image opened in ITK-SNAP, with **/img/GT_1.nii** added as "another file".

![T1_1.nii + GT_1.nii files opened in ITK-SNAP window](https://github.com/am-49/pierwsze/blob/main/png/T1_1_plus_GT_1x.png)

<!-- ![T2_1r.nii + GT_1.nii files opened in ITK-SNAP window](https://github.com/am-49/pierwsze/blob/main/png/T2_1r_plus_GT_1x.png) -->


### 2. Extracting the right-kidney VOI

The **kid_seg_b.m** script was written to extract a VOI comprising the right kidney region from the **/img/T1_1.nii**, **/img/T2_1r.nii** and **/img/GT_1.nii** images. It calls a function crop_volume(fname, i1, i2, j1, j2, k1, k2), where fname is the corresponding NIfTI filename, and the other parameters define the VOI location and size inside the original image. For the right kidney case in this example, their values were 60, 115, 124, 175, 10, 35. In result, three matrices were obtained: rkT1, rkT2r and rkGT, each of size [52 56 26], where **rk** stands for **right kidney**, **T2r** is the T2w image coregistered and **resampled** on the T1w mesh. These matrices were saved in **/img/rkT1.nii**, **/img/rkT2.nii**, **/img/rkGT.nii** NIfTI files and **/mat/rkT1.mat**, **/mat/rkT2.mat**, **/mat/rkGT.mat** binaries. 

```diff
@@ Please notice that in what follows the symbol "r" is no longer included @@
@@   at the end of T2w file name, for brevity. @@
@@ Despite that, in the text below, CO-REGISTERED and RESAMPLED T2w images @@
@@   are referred to only. @@
```  

The VOI cuboid shape and the right kidney region located in it are shown on the rightmost panel in Fig. 3 [1]. The blue-colored kidney surface represents the ground truth 3D object. This surface was generated with the use of ITK-SNAP. To do that, first the **/img/rkGT.nii** image was segmented (Active contour mode - the greyed button, fifth from the left). Then, the level-set procedure was initiated using the _Segment 3D_ option, _Presets|Supersample by 2_, _Linear interpolation_ and the middle button for _Threshold mode_ options. After a few hundred iterations, the result was saved via _Segmentation|Export as Surface Mesh_ in the form of a VTK file, **/vtk/rkGT.vtk**. The VOI visualized in Fig. 3 was displayed with the use of Paraview application [5]. 


### 3. VOI analysis

The extracted VOIs were first used to point out inherent differences between the T1w and T2w image histograms of the kidneys surrounded by their neighboring abdominal tissues and organs. For each T1w and T2w modality of subject #1 right kidney image, the histograms were calculated using three sets of voxels:
- all the voxels in VOI (their count is 75,712),
- the voxels located inside the ground-truth mask (10,076),
- those making the background of the organ of interest (65,636).

The **kid_seg_c.m** script was used for the purpose. Plots of the histograms are shown below and in Fig. 4 [1] with a discussion.

![VOI histograms](https://github.com/am-49/pierwsze/blob/main/png/VOI_histogramsx.png)

Comparing the middle and lower histogram plots on the left pannel of the above figure, one can see that the kidney region and background voxel distributions for T1w overlap significantly. In fact, it can be easily demonstrated that thresholding T1w for segmentation produces a rather inacurate organ extraction, with some parts of neighboring organs interpreted as the kidney. 

Much more accurate kidney segmentation can be obtained with thresholding T2w images. This is illustrated by VOI histograms in the right panel of the figure. The kidney-region voxels form a bell-shaped distribution in the middle-right panel, whose mode is quite well separated from the voxel intensity distributions of the background region (bottom-right plot). This observation leads to a selection of T2w for the preliminary segmentation of the kidney shape, described in point 4 below.


### 4. 2D slices segmentation

The first VOI plane starts with k1 = 10 in the original image, see point 2 above. Then, the slice number in that image is equal to the VOI slice number plus 9. For the considered example, the slices 11, 16, 21, 26 and 29 were selected to illustrate a collection of representative shapes and intensity profiles of the kidney MR plane sections. They are shown in the following figure. These slices correspond to VOI xy images located at z = (2, 7, 12, 17, 20) multiplied by the slice thickness (5.5 mm).

![kid_seg_2 slices](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_rk_Slices.png)

The **kid_seg_d.m** script reads the **/mat/rkT1.mat**, **/mat/rkT2.mat** and **/mat/rkGT.mat** files. For a given value of slice number, the MR images are thresholded at fixed values of lower and upper intensity threshold. The resulting images are displayed in a row, corresponding to respective column of Fig. 5 [1]. An example for slice #21 is shown below. 

![kid_seg_fig5_column](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_Fig5_col.png)

The **kid_seg_e.m** script reads the **/mat/rkT1.mat** and **/mat/rkT2.mat** files. For a given value of slice number, the MR images are thresholded at fixed values of lower and upper threshold. Four-connected binary components are identified in the resulting images and the largest among them are found. They are displayed side-by-side, corresponding to respective column of Fig. 6 [1]. An example for slice #21 is shown here: 

![kid_seg_fig6_column](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_Fig6_col.png)

The **kid_seg_f.m** script reads the **/mat/rkT1.mat**, **/mat/rkT2.mat** and **/mat/rkGT.mat** files. For a given value of slice number, the T2w image is thresholded at fixed values of lower and upper threshold. The largest connected-componenet of this binary image is found and, then, its centroid is computed (marked red in the figure below). Next, region growing algorithm is applied to T2w, starting from the centroid as seed point. The condition for pixel inclusion is the intensity value in the range <m(1-d),m(1+d)>, where m is the mean value of the current region and d is a fixed parameter, d=0.2 for slices 11, 16, 21, 26 and d=0.16 for slice 29. The image obtained after region growing is subjected to close-opening morphological operation, with a 5-pixel binary cross structuring element.  

Finally, the T1w image is thresholded within the mask defined by the segmented T2w slice - for renal cortex extraction. This is shown in the rightmost picture below.

![kid_seg_fig7_column](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_Fig7_col.png)

The **kid_seg_f.m** script computes also the similarity metrics for 2D images (Tab. 1 in [1]:

![kid_seg_2D_metrics](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_2D_metrics.png)


### 5. T2w 3D segmentation

In this example, in **Step 1**, the T2w volume was segmented with the use of a level-set (L-S) algorithm implemented in ITK-SNAP. The double threshold L-S version was used, _I_>530 and _I_<790, where _I_ is the image intensity. In this way, **/img/T2_1r.nii** was segmented and saved as **/img/T2w_LS.nii**. Its surface was approximated by a triangular mesh via saving it in the form of **/vtk/T2w_LS.vtk** file (see point 2 above for a more detailed description of the technique). This file is visualized below with Paraview [5], in the second picture from the left. 

In **Step 2**, the level-set segmentation was manually corrected with ITK-SNAP to cut protrusions visible in the picture. Then it was saved as **/img/T2w_LS-x.nii** and, respectively **/vtk/T2w_LS-x.vtk** (second picture from the right). 

In **Step 3**, the manually prunned segmentation object was processed with mathematical morphology closing operation using a "spherical" structuring element of radius 3. A standard Image Processing Toolbox function of MATLAB:registered: was used for the purpose. The result was saved as **/img/T2w_LS-x-C.nii** and, respectively **/vtk/T2w_LS-x-C.vtk** (the rightmost picture). 

![T2w segmentations surface](https://github.com/am-49/pierwsze/blob/main/png/3D_surf_allx.png)


### 6. Quantitative evaluation

The **kid_seg_f.m** and **kid_seg_g.m** scripts allow computation of various similarity metrics, to compare the segmentation results with the ground truth, for 2D and 3D images respectively. The Dice, Jackard, PPV, TPR, TNR, VE similarity coefficients and the Hausdorff distances defined in Section IV [1] are computed and placed in Table 1 [1]. An example below is a list of entries in the rightmost column of Table 1 [1] that correspond to the segmentation volume obtained in **Step 3** above, being an output of **kid_seg_g.m**. 

![kid_seg_3D_metrics](https://github.com/am-49/pierwsze/blob/main/png/kid_seg_3D_metrics.png)

### References

[1] F. G. Zöllner, M. Kociński, L. Hansen, A. K. Golla, A. Šerifović-Trbalić, A. Lundervold, A. Materka, and P. Rogelj, "Kidney segmentation in renal magnetic resonance imaging - current status and prospects", IEEE Access, vol. 9, pp. 71577-71605, 2021, doi: 10.1109/ACCESS.2021.3078430. [[link](https://ieeexplore.ieee.org/document/9427136)]

[2] A. E. Kavur, N. S. Gezer, M. Barıs, S. Aslan, P.-H. Conze, V. Groza, D. D. Pham, S. Chatterjee, P. Ernst, S. Özkan, B. Baydar, D. Lachinov, S. Han, J. Pauli, F. Isensee, M. Perkonigg, R. Sathish, R. Rajan, D. Sheet, G. Dovletov, O. Speck, A. Nürnberger, K. H. Maier-Hein, G. Bozdagı Akar, G. Ünal, O. Dicle, and M. A. Selver, “Chaos challenge - combined (CT-MR) healthy abdominal organ segmentation,” Medical Image Analysis, vol. 69, p. 101950, 2021. [[arXiv:2001.06535](https://arxiv.org/abs/2001.06535)]

[3] P. A. Yushkevich and G. Gerig, "ITK-SNAP: An interactive medical image segmentation tool to meet the need for expert-guided segmentation of complex medical images," IEEE Pulse, vol. 8, no. 4, pp. 54-57, 2017. [[link](https://ieeexplore.ieee.org/document/7979667)]

[4] Jimmy Shen (2020). Tools for NIfTI and ANALYZE image (https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image), MATLAB Central File Exchange. Retrieved December 6, 2020.

[5] U. Ayachit, "The ParaView Guide: A Parallel Visualization Application", Kitware, 2015, ISBN 978-1930934306. [[https://www.paraview.org/paraview-guide](https://www.paraview.org/paraview-guide)]

[6] A. Klepaczko, E. Eikefjord, A. Lundervold. "Healthy Kidney Segmentation in the DCE-MR Images Using a Convolutional Neural Network and Temporal Signal Characteristics", Sensors 2021, 21, 6714. (https://doi.org/10.3390/s21206714)
