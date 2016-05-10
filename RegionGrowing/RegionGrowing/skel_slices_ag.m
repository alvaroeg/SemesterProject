%2d-3d skeleton
clear all,close all
load bin_mask.mat

for i = 1:size(final_sized_mask,3)
    skel3d(:,:,i) = bwmorph(final_sized_mask(:,:,i),'skel',Inf);
end
SliceBrowser(skel3d)