%Use 2D snakes in the 4D-MRI dataset
%
%DESCRIPTION: this code uses the Matlab implementation of snakes found 
%in
%\url{http://es.mathworks.com/matlabcentral/fileexchange/28149-snake---active-contour}.
% The parameters are optimized for the 4D-MRI dataset. The code also includes a visualization
% method. 

clc, clear all, close all
load dataseg
load snake2Dslices

I= feat(:,:,17);

% imshow(I,[])
% hold on
% plot(P(:,2),P(:,1))
% pause();
% close all

Options=struct;
Options.Verbose=true;
Options.Iterations=400;
Options.Wedge=-3; % Attraction to edges, default 2.0
Options.Wline=-1; % Attraction to lines, if negative to black lines otherwise white lines , default 0.04
Options.Wterm=0; %Attraction to terminations of lines (end points) and corners, default 0.01
Options.Kappa=4; %Weight of external image force, default 2
Options.Sigma1=9; %Sigma used to calculate image derivatives, default 10
Options.Sigma2=8; % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20
Options.Alpha=0.1; % Membrame energy  (first order), default 0.2
Options.Beta=0.1; % Thin plate energy (second order), default 0.2
Options.Mu=0.2; % Trade of between real edge vectors, and noise vectors, default 0.2. (Warning setting this to high >0.5 gives an instable Vector Flow)
Options.Delta=0.09; % Baloon force, default 0.1
Options.GIterations=600; % Number of GVF iterations, default 0

for zSlice = 1:size(feat,3)
    I = feat(:,:,zSlice);
    P = slPoints{zSlice};
    if size(P,1)>10
        [O,J]=Snake2D(I,P,Options);
        pause();
    end
        
end