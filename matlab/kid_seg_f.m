% kid_seg_e.m
% Purpose: Region-growing segmentation of right-kidney T2w slice.
%          1) Find centroid of the largest CC in thresholded T2w.
%          2) Region growing in T2w, start from the centroid.
%          3) Do morphological close-opening.
%          4) Visually compare with the ground-truth
%          (for Fig. 7 in [1]).
%          5) Compute segmentation metrics
%          (for Table 1 in [1]).
%          6) Segment T1w slice within the T2w kidney mask,
%             for cortex extraction (Fig. 8 in [1]).
%           
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 1 Feb 2021
%
%------------- BEGIN CODE --------------% % %

clear;
% %
% % Loading 52x56x26 VOIs;
load('./mat/rkT1.mat');
load('./mat/rkT2.mat');
load('./mat/rkGT.mat');
dxy = 1.89453; % Pixel side length in mm
% % 
% % Slice selection - one of [11 16 21 26 29] in the example of [1]
sliceNo  = 16;
d = 0.2; % 0.16 for sliceNo = 29; 
% % Adjustable parameter: RG = 1 if (im>(1-d)m and im<(1+d)m)
% %                       where m is the running mean of the growing region
kk = sliceNo - 9;
%
% % T2w: thresholding, finding the largest connected component,
% %      ======================================================
rkT2_ = squeeze(rkT2(:,:,kk));       % T2w slice
figure()
sgtitle(strcat('Slice #',num2str(sliceNo)), 'fontsize', 14)
subplot(1,6,1)
imshow(rkT2_,[])
title('T2w', 'fontsize', 12);
thT2 = uint8(zeros(size(rkT2_)));    % Matrix of zeros
thT2((rkT2_>530) & (rkT2_<790)) = 1; % Thresholded T2w slice
% % Find largest connected component
lCC = largest_CC(thT2);
%
% % T2w CC: finding centroid ==================================
[cent, rgb] = objCentroid(lCC);
subplot(1,6,2)
imshow(rgb)
title('T2w thresholded', 'fontsize', 12);
%
% % Region growing in T2w  ====================================
RG = regionGrowing(rkT2_, cent, d);
subplot(1,6,3)
imshow(RG,[])
title('Region Growing', 'fontsize', 12);
%
% Find contour gc of the ground-truth =========================
gt = squeeze(rkGT(:,:,kk));
gc = zeros(size(gt));
sz = size(gt);
for j=2:sz(1)-1
    for i=2:sz(2)-1
        if gt(j,i) && (~gt(j-1,i)||~gt(j+1,i)||~gt(j,i-1)||~gt(j,i+1))
            gc(j,i) = 1;
        end
    end
end
%
% % Morphological close-opening ===============================
SE = strel('octagon', 3);
CO = imerode(imdilate(RG, SE),SE);
subplot(1,6,4)
imshow(CO,[])
title('Close-Opening', 'fontsize', 12);
rgb = double(zeros(sz(1), sz(2), 3));
[x,y] = find(CO);
for k=1:size(x)
   rgb(x(k),y(k),:)=[0.4 0.4 0.4];
end
[x,y] = find(gc);
for i=1:length(x)
    rgb(x(i), y(i), :) = [0.7 0.7 0.9];
end
subplot(1,6,5)
imshow(rgb,[])
title('Compared to GT', 'fontsize', 12);
%
% % Segmenting T1w within the T2w mask ============
im = squeeze(rkT1(:,:,kk));       % T1w slice
T1_seg = zeros(size(im));
[x,y] = find(CO);
for k=1:size(x)
    if im(x(k),y(k))>260 && im(x(k),y(k))<450
        T1_seg(x(k),y(k)) = im(x(k),y(k))/500;
    end
end
subplot(1,6,6)
imshow(T1_seg,[])
title('T1w segmented', 'fontsize', 12);
%
% % Computing DSC, JSC and Hausdorff distances ====
segMetrics(sliceNo, CO, gt, dxy);

% % %
%------------- END OF CODE --------------