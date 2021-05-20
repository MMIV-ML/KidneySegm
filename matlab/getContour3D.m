% getContour3D.m
% Purpose: Find the objects boundary points in binary 3D image.
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 1 Feb 2021; Last revision: 4 Feb 2021
%
%------------- BEGIN CODE --------------% % %

function V = getContour3D(im, dxy, dz) 
% im: 3D binary image
% dxy: in-plane pixel side length
% dz: slice thickness
imx = im;
sx = size(im);
for k=2:sx(3)
for i=2:sx(1)
    for j=2:sx(2)
        if im(i,j,k) && im(i-1,j,k) && im(i+1,j,k) ...
                && im(i,j-1,k) && im(i,j+1,k) ...
                && im(i,j,k-1) && im(i,j,k+1)
            imx(i,j,k) = 0;
        end
    end
end
end
% im = imx;
id0 = find(imx);
V = double(zeros(size(id0,1),3));
ii = 0;
for k=1:sx(3)
    [j,i] = find(imx(:,:,k));
    for jj=1:size(i,1)
        ii = ii + 1;
        V(ii,:) = [dxy*j(jj) dxy*i(jj) dz*k];
    end
end
%

% % %
%------------- END OF CODE --------------