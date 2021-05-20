% objCentroid.m
% Purpose: Find centroid of the object in binary image.
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 31 Jan 2021
%
%------------- BEGIN CODE --------------% % %

function [cent, rgb] = objCentroid(imb) % imb - input binary image
% %
[x,y] = find(imb);
cent = uint8([mean(x(:)) mean(y(:))]); % the centroid
sz = size(imb);
rgb = double(zeros(sz(1), sz(2), 3));
rgb(:,:,1) = imb(:,:);
rgb(:,:,2) = imb(:,:);
rgb(:,:,3) = imb(:,:);
rgb(cent(1)-1,cent(2),:)= [1 0 0];
rgb(cent(1),cent(2),:)= [1 0 0];
rgb(cent(1)+1,cent(2),:)= [1 0 0];
rgb(cent(1),cent(2)-1,:)= [1 0 0];
rgb(cent(1),cent(2)+1,:)= [1 0 0];
% %

% % %
%------------- END OF CODE --------------