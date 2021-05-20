% kid_seg_a.m
% Purpose: Make a 3D image NIfTI file out of 
%          a collection of 2D PNG expert annotations 
%          from CHAOS abdominal MR dataset 
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 29 Nov 2020; Last revision: 1 Jan 2021
%
%------------- BEGIN CODE --------------% % %

clear;
addpath('nii');
% %
% % Load T1w image NIfTI file to get its header structure
nx = load_nii(strcat('./img/T1_1.nii'));
% % Displaying voxel dimensions (just checking up the data)
fprintf('%.9f, %.9f, %.9f\n', nx.hdr.dime.pixdim(2:4));
% % Initializing the ground-truth kidney volume
imGT = uint8(zeros(size(nx.img)));
% % Reading PNG expert annotations from CHAOS 
% %    /Train_Sets/MR/1/T1DUAL/Ground/ directory,
% %    (copied to /img/T1_Ground/ on GitHub)
Files = dir('./img/T1_Ground/');
for k=3:length(Files)
   % Reading the expert annotation PNG files  
   annot = imread(strcat('./img/T1_Ground/', Files(k).name));
   % Zeroing pixels of liver and spleen
   annot(annot==63|annot==252) = 0;
   % Reorientation to align x-y PNG axes with those of T1w and T2w slices
   annot = rot90(flip(annot,1));
   % Storing k-th slice kidney annotation in the GT matrix
   imGT(:,:,k-2) = annot;
end
% %
% % Setting up the groud-truth NIfTI file name
fn = strcat('/img/GT_1.nii');
% % Modifying NIfTI header for 8-bit data
nx.hdr.dime.datatype = 2;
nx.hdr.dime.bitpix = 8;
% % Assigning the ground-truth volume to NIfTI data
nx.img = imGT;
% % Saving the ground truth
save_nii(nx, strcat(pwd, fn));

% %
%------------- END OF CODE --------------