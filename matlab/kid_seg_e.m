% kid_seg_e.m
% Purpose: Extract the largest connected components 
%          from right-kidney thresholded T1w and T2w images  
%          (for Fig. 6 in [1]). 
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 17 Jan 2021; Last revision: 18 Jan 2021
%
%------------- BEGIN CODE --------------% % %

clear;
% %
% % Loading 52x56x26 VOIs;
load('./mat/rkT1.mat');
load('./mat/rkT2.mat');
% % 
% % Slice selection - one of [11 16 21 26 29] in the example of [1]
sliceNo  = 21;
kk = sliceNo - 9;
%
% % T1w =======================================================
rkT1_ = squeeze(rkT1(:,:,kk));       % T1w slice
thT1 = uint8(zeros(size(rkT1_)));    % Matrix of zeros
thT1((rkT1_>245) & (rkT1_<370)) = 1; % Thresholded T1 slice
[L,n] = bwlabeln(thT1,4);  % Find 4-connected binary components
% % Find largest connected component
tab = zeros(n,2);
for i=1:n
    idx = find(L==i);
    tab(i,:) = [i size(idx,1)];
end
[~, idcc] = max(tab(:,2)); % Size and label (id) of the largest CC
thT1_maxCC = uint8(zeros(size(rkT1_)));
thT1_maxCC(L==idcc) = 1; % Largest CC in thresholded T1w image
% imshow(thT1_maxCC,[])
%
% % T2w =======================================================
rkT2_ = squeeze(rkT2(:,:,kk));       % T2w slice
thT2 = uint8(zeros(size(rkT2_)));    % Matrix of zeros
thT2((rkT2_>530) & (rkT2_<790)) = 1; % Thresholded T2w slice
[L,n] = bwlabeln(thT2,4);  % Find 4-connected binary components
% % Find largest connected component
tab = zeros(n,2);
for i=1:n
    idx = find(L==i);
    tab(i,:) = [i size(idx,1)];
end
[size_cc, idcc] = max(tab(:,2)); % Size and label (id) of the largest CC
thT2_maxCC = uint8(zeros(size(rkT2_)));
thT2_maxCC(L==idcc) = 1; % Largest CC in thresholded T2w image
% imshow(thT2_maxCC,[])

figure()
sgtitle(strcat('Slice #', num2str(sliceNo), ' largest CCs'),'fontsize', 13)
subplot(1,2,1)
imshow(thT1_maxCC,[])
title('T1w thresh'); % ^^^^^^^^
subplot(1,2,2)
imshow(thT2_maxCC,[])
title('T2w thresh'); % ^^^^^^^^

% % %
%------------- END OF CODE --------------