% kid_seg_g.m
% Purpose: Compute segmentation metrics for right-kidney segmented
%          volumes in Fig. 9 (3 rightmost columns in Tab. 1). 
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 4 Feb 2021
%
%------------- BEGIN CODE --------------% % %

clear;
% %
% % Loading 52x56x26 VOIs;
fn = 'GT';
GT = uint8(niftiread(strcat('./img/', fn, '.nii')));
fn = 'T2w_LS';
im1 = uint8(niftiread(strcat('./img/', fn, '.nii')));
fn = 'T2w_LS-x';
im2 = uint8(niftiread(strcat('./img/', fn, '.nii')));
fn = 'T2w_LS-x-C';
im3 = uint8(niftiread(strcat('./img/', fn, '.nii')));
dxy = 1.89453; % square in-plane pixel side length in mm
dz = 5.5; % slice thickness in mm
% % 
Step = 3;
B = GT;
switch(Step)
    case 1 
        A = im1;
    case 2
        A = im2;
    case 3
        A = im3;
end
TP = A & B;
den = A | B;
JSC = size(find(TP),1) / size(find(den),1);
DSC = 2 * JSC / (JSC+1);
PPV = size(find(TP),1) / size(find(A),1);
TPR = size(find(TP),1) / size(find(B),1);
TN = size(A,1)*size(A,2)*size(A,3) - size(find(den),1);
FP = A & (~B);
TNR = TN /(TN + size(find(FP),1));
VE = abs(size(find(A),1) - size(find(B),1))/size(find(B),1);
% %
% % Hausdorff distances =====================
Bp = getContour3D(B,dxy,dz);
Ap = getContour3D(A,dxy,dz);
sA = size(Ap); sB = size(Bp);
denom = sA(1) + sB(1);
dAB = double(zeros(sA(1),1));
dBA = double(zeros(sB(1),1));
for a=1:sA(1)
    dAB(a) = sqrt(min(sum(bsxfun(@minus,Ap(a,:),Bp).^2, 2)));
end
for b=1:sB(1)
    dBA(b) = sqrt(min(sum(bsxfun(@minus,Bp(b,:),Ap).^2, 2)));
end
ASSD = (sum(dAB) + sum(dBA)) / denom;
dHD_AB = max(dAB(:));
dHD_BA = max(dBA(:));
%
fprintf('===============\n');
fprintf('   Step = %2d\n    DSC = %6.3f\n    JSC = %6.3f\n', ...
         Step, DSC, JSC);
fprintf('    PPV = %6.3f\n    TPR = %6.3f\n    TNR = %6.3f\n', ...
         PPV, TPR, TNR);
fprintf(' dHD_BA = %5.2f \n dHD_AB = %5.2f \n   ASSD = %5.2f \n', ...
        dHD_BA, dHD_AB, ASSD);
fprintf('     VE = %6.3f\n\n', VE)

% % %
%------------- END OF CODE --------------