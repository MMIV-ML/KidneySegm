% kid_seg_b.m
% Purpose: Extract the right-kidney VOI from T1w and T2w images, 
%          save them as rkT1 and rkT2 MAT files.  
%          Save ROIs of PNG ground-truth slices as rkGT.mat file
%          Making NIfTI copies rkT1.nii, rkT2.nii, rkGT.nii.
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 31 Dec 2020; Last revision: 2 Jan 2021
%
%------------- BEGIN CODE --------------% % %

clear;
addpath('nii');
% %
% % T1w right-kidney in 52x56x26 VOI;
rkT1 = crop_volume('T1_1', 60, 115, 124, 175, 10, 35);
save('./mat/rkT1.mat', 'rkT1');
% % %
% % % T2w right-kidney 52x56x26 VOI;
rkT2 = crop_volume('T2_1r', 60, 115, 124, 175, 10, 35);
save('./mat/rkT2.mat', 'rkT2');
% % %
% % % Ground-truth right-kidney 52x56x26 VOI - a stack of PNG file ROIs
nx = load_nii(strcat('./img/T1_1.nii'));
% % % Displaying voxel dimensions (just checking up the data)
fprintf('%.9f, %.9f, %.9f\n', nx.hdr.dime.pixdim(2:4));
% % % Reading PNG expert annotations from CHAOS 
% % %    /Train_Sets/MR/1/T1DUAL/Ground/ directory,
% % %    (copied to /img/T1_Ground/ on GitHub).
% % %    Combining into 52x56x26 VOI.
% % % Initializing the ground-truth kidney VOI volume
rkGT = uint8(zeros(52,56,26));
for i=10:35
    kk = i - 9;
    seg = imread(strcat('./img/T1_Ground/IMG-0004-000', ...
                        num2str(2*i), '.png'));
    lkid = uint8(zeros(size(seg)));
    lkid(seg==126) = 1;
    rkGT(:,:,kk) = lkid(124:175,60:115);
end
save('./mat/rkGT.mat', 'rkGT');
% % %
% % % Saving the right-kidney VOIs NIfTI files
nv = make_nii(rkT1, nx.hdr.dime.pixdim(2:4), [], 4); 
save_nii(nv, './img/rkT1.nii');
nv = make_nii(rkT2, nx.hdr.dime.pixdim(2:4), [], 4); 
save_nii(nv, './img/rkT2.nii');
nv = make_nii(rkGT, nx.hdr.dime.pixdim(2:4), [], 2); 
save_nii(nv, './img/rkGT.nii');
% %
% % % Checking up visual appearance of selected slices
% % %   Selected slice numbers in rows. 
% % %   Left colum: T1w, middle collumn: T2w, right column: ground truth.
%
slices = [11 16 21 26 29]; % Slice numbers (z-value in original images)
for i=1:5
    nn = 3*(i-1);
    subplot(5,3,nn+1)
    imshow(rkT1(:,:,slices(i)-9),[]);
    subplot(5,3,nn+2)
    imshow(rkT2(:,:,slices(i)-9),[]);
    subplot(5,3,nn+3)
    imshow(rkGT(:,:,slices(i)-9),[])
end

% % %
%------------- END OF CODE --------------