% getContour2D.m
% Purpose: Find the objects boundary points in binary 2D image.
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 1 Feb 2021; Last revision: 4 Feb 2021
%
%------------- BEGIN CODE --------------% % %

function V = getContour2D(im, dxy) % im: the image; dxy: pixel side length
imx = im;
sx = size(im);
for i=2:sx(1)
    for j=2:sx(2)
        if im(i,j) && im(i-1,j) && im(i+1,j) && im(i,j-1) && im(i,j+1)
           imx(i,j) = 0;
        end
    end
end
id0 = find(imx);
V = double(zeros(size(id0,1),2));
ii = 0;
[j,i] = find(imx(:,:));
for jj=1:size(i,1)
    ii = ii + 1;
    V(ii,:) = [dxy*j(jj) dxy*i(jj)];
end
%

% % %
%------------- END OF CODE --------------
