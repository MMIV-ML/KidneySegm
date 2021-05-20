% crop_volume.m
% Purpose: Crop a VOI from a NIfTI image            
%
%  Author: Andrzej Materka, Lodz University of Technology
%   email: andrzej.materka@p.lodz.pl
% website: www.materka.p.lodz.pl
%
% 31 Dec 2020; Last revision: 2 Jan 2021
%
%------------- BEGIN CODE --------------% % %

function [img] = crop_volume(fname, i1, i2, j1, j2, k1, k2)
nx = load_untouch_nii(fullfile(pwd, 'img', strcat(fname, '.nii')));
% % Extract the VOI
im1 = nx.img(i1:i2, j1:j2, k1:k2);
% % Make a VOI matrix with xy slices rotated by 90 degrees
img = double(zeros(j2-j1+1, i2-i1+1, k2-k1+1));
for kk=1:k2-k1+1
    % Reorient to align x-y MR slice axes with those of PNG files
    img(:,:,kk) = flip(rot90(im1(:,:,kk)),1);
end

% % %
%------------- END OF CODE --------------