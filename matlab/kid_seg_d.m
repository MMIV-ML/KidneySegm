% kid_seg_d.m
% Purpose: Right-kidney T1w and T2w slice segmentation 
%          via double thresholding
%          to make images for a column in Fig. 5 of [1]
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 15 Jan 2021; Last revision: 18 Jan 2021
%
%------------- BEGIN CODE --------------% % %

clear;
% %
% % Loading 52x56x26 VOIs;
load('./mat/rkT1.mat');
load('./mat/rkT2.mat');
load('./mat/rkGT.mat');
% % 
% % Slice selection - one of [11 16 21 26 29] in the example of [1]
sliceNo  = 21;
kk = sliceNo - 9;
% % T1w ================
figure()
sgtitle(strcat('Slice #', num2str(sliceNo)), 'fontsize', 13)
subplot(1,5,1)
imshow(rkT1(:,:,kk),[])
title('T1w'); % ^^^^^^^^
subplot(1,5,2)
imshow(rkT2(:,:,kk),[])
title('T2w'); % ^^^^^^^^
subplot(1,5,3)
rkGT_ = double(squeeze(rkGT(:,:,kk)));
sz = size(rkGT_);
rgb = double(zeros(sz(1),sz(2),3));
rgb(:,:,1) = 0.3*rkGT_(:,:); % Coloring the ground truth
rgb(:,:,2) = 0.3*rkGT_(:,:); % with the dark-blue color 
rgb(:,:,3) = rkGT_(:,:);     % used in [2].
imshow(rgb,[])
title('GT'); % ^^^^^^^^
% % % T1w ===============================;
% % Thresholding T1w (th1=245 and th2=370)
rkT1_ = squeeze(rkT1(:,:,kk));       % T1w slice
thT1 = uint8(zeros(size(rkT1_)));    % Matrix of zeros
thT1((rkT1_>245) & (rkT1_<370)) = 1; % Thresholded T1 slice
subplot(1,5,4)
imshow(thT1, [])
title('T1w thresh');
% % % T2w ===============================;
% % Thresholding T2w (th1=530 and th2=790)
rkT2_ = squeeze(rkT2(:,:,kk));       % T2w slice
thT2 = uint8(zeros(size(rkT2_)));    % Matrix of zeros
thT2((rkT2_>530) & (rkT2_<790)) = 1; % Thresholded T2 slice
subplot(1,5,5)
imshow(thT2, [])
title('T2w thresh');

% % %
%------------- END OF CODE --------------