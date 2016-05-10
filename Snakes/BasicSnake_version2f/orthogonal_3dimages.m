function [imXY,imXZ,imZY] = orthogonal_3dimages(im)

imXY = im;
imXZ = permute(im,[1 3 2]);
imZY = permute(im,[3 2 1]);