% max(FV.vertices) = [5 5 5];
% size(I) = [64 64 64];
clear all
close all
clc
load SphereMesh.mat
load dataseg
eval_im = feat;

%COORDINATES: Note that FV.vertices correspond to x coordinate, so it
%corresponds to the second dimension of the matrix (size(eval_im,2))

sp_rad = [0.35 0.65 0.75].*floor(size(eval_im)/2);

FV.vertices = FV.vertices/5; % Radius = 1
FV.vertices(:,1) = FV.vertices(:,1)*sp_rad(2);
FV.vertices(:,2) = FV.vertices(:,2)*sp_rad(1);
FV.vertices(:,3) = FV.vertices(:,3)*sp_rad(3);

FV.vertices(:,1) = FV.vertices(:,1) + 1.35*floor(size(eval_im,2)/2);
FV.vertices(:,2) = FV.vertices(:,2) + 1.1*floor(size(eval_im,1)/2);
FV.vertices(:,3) = FV.vertices(:,3) + 1.3*floor(size(eval_im,3)/2);

xpos = round(FV.vertices(:,1));
ypos = round(FV.vertices(:,2));
zpos = round(FV.vertices(:,3));

slPoints = [];
for zSlice = 1:size(eval_im,3)
    fzpos = find(zpos==zSlice);
    x = xpos(fzpos);
    y = ypos(fzpos);
    slPoints{zSlice} = [y x];
end