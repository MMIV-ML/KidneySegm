% regionGrowing.m
% Purpose: Find centroid of the object in binary image, given seed point.
%          
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 30 Jan 2021; Last revision: 31 Jan 2021
%
%------------- BEGIN CODE --------------% % %

function [RG] = regionGrowing(im,cent,d) % im - input gray-level image
%                                        % cent - seed point 
% %
sz = size(im);
RG = uint8(zeros(sz(1),sz(2)));
ys = cent(1);
xs = cent(2);
% 
Stack = zeros(sz(1)*sz(2),2);
ptr = 0;
sum = 0;
for j=ys-1:ys+1
    for i=xs-1:xs+1
        ptr = ptr + 1;
        Stack(ptr,:) = [j, i];
        RG(j,i) = 1;
        sum = sum + im(j,i);
    end
end
val = sum / 9;
while ptr 
    y = Stack(ptr,1);
    x = Stack(ptr,2);
    ptr = ptr - 1;
    if ~RG(y,x-1) && im(y,x-1)>(1-d)*val && im(y,x-1)<(1+d)*val
        RG(y,x-1) = 1;
        ptr = ptr + 1;
        Stack(ptr,:) = [y x-1];
    end
    if ~RG(y,x+1) && im(y,x+1)>(1-d)*val && im(y,x+1)<(1+d)*val
        RG(y,x+1) = 1;
        ptr = ptr + 1;
        Stack(ptr,:) = [y,x+1];
    end
    if ~RG(y-1,x) && im(y-1,x)>(1-d)*val && im(y-1,x)<(1+d)*val
        RG(y-1,x) = 1;
        ptr = ptr + 1;
        Stack(ptr,:) = [y-1 x];
    end
    if ~RG(y+1,x) && im(y+1,x)>(1-d)*val && im(y+1,x)<(1+d)*val
        RG(y+1,x) = 1;
        ptr = ptr + 1;
        Stack(ptr,:) = [y+1 x];
    end   
    idx = find(RG);
    val = mean(im(idx(:)));
end
% %

% % %
%------------- END OF CODE --------------