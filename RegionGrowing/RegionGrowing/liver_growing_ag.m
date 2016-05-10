clear all, close all
load dataseg

save_fig = 1;
eval_im = feat;
xframe = 5;
xframe2 = 10;
zframe = 3;

if save_fig
    h1 = viewer_3midslices(eval_im);
    saveas(h1,'01_eval_im.jpg')
    close all
end

sizeY = size(eval_im,1);
sizeX = size(eval_im,2);
sizeZ = size(eval_im,3);

eval_frame = 0.7*ones(size(eval_im,1),xframe,size(eval_im,3));
% eval_frame2 = zeros(size(eval_im,1),xframe2,size(eval_im,3));
eval_im = [eval_im eval_frame];
eval_im(:,:,sizeZ+1:sizeZ+zframe) = 0.7;
% eval_im = feat;

if save_fig
%     h2 = SliceBrowser(eval_im);
%     saveas(h2,'02_eval_im_sized.jpg')
%     close all
    
    h2 = viewer_3midslices(eval_im);
    saveas(h2,'02_eval_im_sized.jpg')
    close all
    
end

% eval_im = feat;

lMask = regiongrowing(eval_im, 0.08);
iMask = double(~lMask);
% SliceBrowser(iMask)
% keyboard
if save_fig
    h3 = viewer_3midslices(iMask(1:sizeY,1:sizeX,1:sizeZ));
    saveas(h3,'03_inv_mask.jpg')
    close all
end

% load test_mask


%% Create sphere
addpath('strel3d/')
s10 = strel3d(10);
s5 = strel3d(5);

%% Morphological processing
open_mask = imopen(iMask,strel3d(3));
closed_mask = imclose(open_mask,strel3d(8));
% open_mask = imopen(closed_mask,strel3d(20));
% open_mask = imopen(closed_mask,sopen);
final_mask = closed_mask;
final_sized_mask = final_mask(1:sizeY,1:sizeX,1:sizeZ);

if save_fig
    h4a = viewer_3midslices(open_mask(1:sizeY,1:sizeX,1:sizeZ));
    saveas(h4a,'04a_open_mask.jpg')
    close all
end

if save_fig
    h4 = viewer_3midslices(final_mask(1:sizeY,1:sizeX,1:sizeZ));
    saveas(h4,'04_final_mask.jpg')
    close all
else 
    viewer_3midslices(final_sized_mask);
end

addpath('imMinkowski_2015.04.20/imMinkowski')
maskEuler = imEuler3d(final_mask);
% The Euler number is the total number of objects in the image minus the
% total number of holes in those objects. n specifies the connectivity.
% Objects are connected sets of on pixels, that is, pixels having a value of 1.
fprintf('The Euler number is %d\n',maskEuler) % It should be 0


%% Distance map
dist_map = bwdist(~final_sized_mask);
if save_fig
    h5 = viewer_3midslices(dist_map(1:sizeY,1:sizeX,1:sizeZ));
    saveas(h5,'05_dist_map.jpg')
    close all
end
%% Surface

% ult_er2 = bwulterode(final_sized_mask,'euclidean',6);
% SliceBrowser(ult_er2)

%% Structure tensor