% kid_seg_c.m
% Purpose: Plot the right-kidney T1w and T2w image histograms, 
%          inside the ground-truth voxels 
%          and their background in VOI,
%          to make images for Fig. 4 of [1]
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 5 Jan 2021; Last revision: 6 Jan 2021
%
%------------- BEGIN CODE --------------% % %

clear;
% %
% % Loading 52x56x26 VOIs;
load('./mat/rkGT.mat');
load('./mat/rkT1.mat');
load('./mat/rkT2.mat');
% % 
% % % T1w ======================;
mask = rkGT>0;
subplot(3,2,1) % Histogram plots
histogram(rkT1, 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 10000])
title('T1w VOI')
ylabel('Bin Count')
subplot(3,2,3)
histogram(rkT1(mask), 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 2500])
title('T1w kidney GT region')
ylabel('Bin Count')
subplot(3,2,5)
histogram(rkT1(~mask), 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 10000])
title('T1w background in VOI')
xlabel('Intensity')
ylabel('Bin Count')
% %
% % % T2w ======================;
subplot(3,2,2) % Histogram plots
histogram(rkT2, 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 6000])
title 'T2w VOI'
subplot(3,2,4)
histogram(rkT2(mask), 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 2500])
title('T2w kidney GT region')
subplot(3,2,6)
histogram(rkT2(~mask), 50, 'BinLimits', [0 1000]);
set(gca,'xLim',[0 1000])
set(gca,'yLim',[0 6000])
title('T2w background in VOI')
xlabel('Intensity')
% %
%------------- END OF CODE --------------