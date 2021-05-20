% largest_CC.m
% Purpose: Find the largest connected component in binary image.
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 31 Jan 2021
%
%------------- BEGIN CODE --------------% % %

function [lCC] = largest_CC(imb) % imb - input binary image
% %
[L,n] = bwlabeln(imb,4);  % Find 4-connected binary components
% Find the largest connected component
tab = zeros(n,2);
for i=1:n
    idx = find(L==i);
    tab(i,:) = [i size(idx,1)];
end
[~, idCC] = max(tab(:,2)); % Label (id) of the largest CC
lCC = uint8(zeros(size(imb)));
lCC(L==idCC) = 1; % Largest CC in imb input image
%

% % %
%------------- END OF CODE --------------