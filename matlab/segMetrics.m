% segMetrics.m
% Purpose: Compute Jackard and Dice Similarity coefficients (JSC and DSC)
%          and Hausdorff distances
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 1 Feb 2021
%
%------------- BEGIN CODE --------------% % %

function segMetrics(sliceNo, A, B, dxy) % A: segmentation, B: ground truth
% %                                       dxy: pixel side
% %
TP = A & B;
den = A | B;
JSC = size(find(TP),1)/size(find(den),1);
DSC = 2*JSC/(JSC+1);
PPV = size(find(TP),1)/size(find(A),1);
TPR = size(find(TP),1)/size(find(B),1);
TN = (size(A,1)*size(A,2)-size(find(den),1));
FP = A & (~B);
TNR = TN /(TN + size(find(FP),1));
% %
% % Hausdorff distances =====================
% % % Extracting contours
sz = size(A);
cA = zeros(size(A));
for j=2:sz(1)-1
    for i=2:sz(2)-1
        if A(j,i) && (~A(j-1,i)||~A(j+1,i)||~A(j,i-1)||~A(j,i+1))
            cA(j,i) = 1;
        end
    end
end
cB = zeros(size(B));
for j=2:sz(1)-1
    for i=2:sz(2)-1
        if B(j,i) && (~B(j-1,i)||~B(j+1,i)||~B(j,i-1)||~B(j,i+1))
            cB(j,i) = 1;
        end
    end
end

% % The distances ============
Ap = getContour2D(cA, dxy); % Contour points of segmentation
Bp = getContour2D(cB, dxy); % Contour points of the ground truth
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
VE = abs(size(find(A),1) - size(find(B),1))/size(find(B),1);
%
fprintf('===============\n');
fprintf('SliceNo = %d\n    DSC = %5.3f\n    JSC = %5.3f\n', ...
         sliceNo, DSC, JSC);
fprintf('    PPV = %5.3f\n    TPR = %5.3f\n    TNR = %5.3f\n', ...
         PPV, TPR, TNR);
fprintf(' dHD_BA = %4.2f \n dHD_AB = %4.2f \n   ASSD = %4.2f \n', ...
        dHD_BA, dHD_AB, ASSD);
fprintf('     VE = %5.3f\n\n', VE)

% 
% % %
%------------- END OF CODE --------------