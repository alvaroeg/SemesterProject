%Use 3D snakes in the 4D-MRI dataset
%
%DESCRIPTION: this code uses the Matlab implementation of snakes found 
%in
%\url{http://es.mathworks.com/matlabcentral/fileexchange/28149-snake---active-contour}.
% Different initial contours are already included that can be changed by
% modifying the variable coor. The code also includes a visualization
% method. 


clear all
close all
clc
addpath('BasicSnake_version2f')
load SphereMesh.mat
% load dataseg
load initial_cont_FV
load /home/alvaroeg/SemesterProject/Data/feat_mm_norm.mat
feat = feats_mm_norm{1,1};
eval_im = feat;

% xframe = 10;
% xframe2 = 20;
% eval_frame = 0.7*ones(size(eval_im,1),xframe,size(eval_im,3));
% eval_frame2 = zeros(size(eval_im,1),xframe2,size(eval_im,3));
% eval_im = [eval_im eval_frame eval_frame2];
% imshow(eval_im(:,:,15),[])

%COORDINATES: Note that FV.vertices correspond to x coordinate, so it
%corresponds to the second dimension of the matrix (size(eval_im,2))
coor = 3;

if coor == 1
    sp_rad = [0.35 0.65 0.75].*floor(size(eval_im)/2);
    
    FV.vertices = FV.vertices/5; % Radius = 1
    FV.vertices(:,1) = FV.vertices(:,1)*sp_rad(2);
    FV.vertices(:,2) = FV.vertices(:,2)*sp_rad(1);
    FV.vertices(:,3) = FV.vertices(:,3)*sp_rad(3);
    
    FV.vertices(:,1) = FV.vertices(:,1) + 1.35*floor(size(eval_im,2)/2) - xframe - xframe2;
    FV.vertices(:,2) = FV.vertices(:,2) + 1.1*floor(size(eval_im,1)/2);
    FV.vertices(:,3) = FV.vertices(:,3) + 1.3*floor(size(eval_im,3)/2);
    
elseif coor == 2
    sp_rad = [0.8 1.2 1.05].*floor(size(feat)/2);
    
    FV.vertices = FV.vertices/5; % Radius = 1
    FV.vertices(:,1) = FV.vertices(:,1)*sp_rad(2);
    FV.vertices(:,2) = FV.vertices(:,2)*sp_rad(1);
    FV.vertices(:,3) = FV.vertices(:,3)*sp_rad(3);
    
    FV.vertices(:,1) = FV.vertices(:,1) + 1.2*floor(size(feat,2)/2);
    FV.vertices(:,2) = FV.vertices(:,2) + 1.05*floor(size(feat,1)/2);
    FV.vertices(:,3) = FV.vertices(:,3) + 1.4*floor(size(feat,3)/2);
    
    FV.vertices(FV.vertices(:,1)>size(feat,2),1) = size(eval_im,2);
    FV.vertices(FV.vertices(:,2)>size(feat,1),2) = size(feat,1);
    FV.vertices(FV.vertices(:,3)>size(feat,3),3) = size(feat,3);
    FV.vertices(FV.vertices(:,1)<1,1) = 1;
    FV.vertices(FV.vertices(:,2)<1,2) = 1;
    FV.vertices(FV.vertices(:,3)<1,3) = 1;
    
    elseif coor == 3
    sp_rad = [0.4 0.8 1].*floor(size(feat)/2);
    
    FV.vertices = FV.vertices/5; % Radius = 1
    FV.vertices(:,1) = FV.vertices(:,1)*sp_rad(2);
    FV.vertices(:,2) = FV.vertices(:,2)*sp_rad(1);
    FV.vertices(:,3) = FV.vertices(:,3)*sp_rad(3);
    
    FV.vertices(:,1) = FV.vertices(:,1) + 1.5*floor(size(feat,2)/2);
    FV.vertices(:,2) = FV.vertices(:,2) + 1.05*floor(size(feat,1)/2);
    FV.vertices(:,3) = FV.vertices(:,3) + 1.4*floor(size(feat,3)/2);
    
    FV.vertices(FV.vertices(:,1)>size(feat,2),1) = size(feat,2);
    FV.vertices(FV.vertices(:,2)>size(feat,1),2) = size(feat,1);
    FV.vertices(FV.vertices(:,3)>size(feat,3),3) = size(feat,3);
    FV.vertices(FV.vertices(:,1)<1,1) = 1;
    FV.vertices(FV.vertices(:,2)<1,2) = 1;
    FV.vertices(FV.vertices(:,3)<1,3) = 1;
end



% VISUALIZATION
init_vis=0;
if init_vis
    I = eval_im;
    midM = round(size(eval_im,1)/2);
    midN = round(size(eval_im,2)/2);
    midK = round(size(eval_im,3)/2);
    for k = 1:size(eval_im,3)
        vis_init_countour_ag(I,FV,k,'XY');
        pause(0.05)
    end
    pause
    close
    for m = 1:size(eval_im,1)
        vis_init_countour_ag(I,FV,m,'XZ');
        pause(0.02)
    end
    pause
    close
    for n = 1:size(eval_im,2)
        vis_init_countour_ag(I,FV,n,'ZY');
        pause(0.02)
    end
    pause
    close
end


% SEGMENTATION
I = eval_im;
Options=struct;
Options.Verbose=0; %If true show important images, default false
Options.Verbose2=1;
Options.Wedge=2; %Attraction to edges, default 2.0
Options.Wline= -0.1; %Attraction to lines, if negative to black lines otherwise white lines , default 0.04
Options.Alpha=0.05; %Membrame energy  (first order), default 0.2
Options.Beta=0.05; %Thin plate energy (second order), default 0.2
Options.Kappa=300; %Weight of external image force, default 2
Options.Delta=0.09; %Baloon force, default 0.1
Options.Gamma=0.1000; % Time step, default 1
Options.Iterations=100; %Number of iterations, default 100
Options.Sigma1=2; % used to calculate image sSderivatives, default 2
Options.Sigma2=2; %Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 2
Options.Lambda=0.8; %Weight which changes the direction of the image potential force to the direction of the surface normal, value default 0.8 (range [0..1]) (Keeps the surface from self intersecting)
OV=Snake3D_ag(I,FV,Options);
figure(11)
% pause

% VISUALIZATION
% visualize_snake3d_liver_ag(eval_im,OV)
