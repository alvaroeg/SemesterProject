% explore how to extract a surface from max shearing feature image
close all, clear all
% load feat and vol_fix
% load /home/alvaroeg/SemesterProject/Data/feat_mm_norm.mat
%
% feat = feats_mm{1,1};
% vol_fix = vols_mm{1,1};

load /home/alvaroeg/SemesterProject/dir_dataset/data_DIR_8_all
sz=size(feat);
cz = round(sz/2);
cz(2) = round(2/3*sz(2));


%%
if 1==0
    % Otsu's thresholding method
    [level, EM] = graythresh(feat);
else
    level = prctile(feat(:),90);
end
level = 0.2;
BW=feat>level;
negBW=feat<level;

%%

prc99Feat = prctile(feat(:),99);
prc99Fixed = prctile(vol_fix(:),99);
fontsize = 20;
figure(2)
subplot(2,3,1)
imagesc(feat(:,:,cz(3)),[0 prc99Feat])
colorbar
hold on
contour(BW(:,:,cz(3)),1,'Color','y')
colorbar
hold off
title('Maximum shear. XY slice','FontSize',fontsize)
subplot(2,3,4)
imagesc(vol_fix(:,:,cz(3)),[0 prc99Fixed])
colorbar
hold on
contour(BW(:,:,cz(3)),1,'Color','y')
colorbar
hold off
title('Fixed image. XY slice','FontSize',fontsize)
subplot(2,3,2)
imagesc(squeeze(feat(:,cz(2),:)),[0 prc99Feat])
colorbar
hold on
contour(squeeze(BW(:,cz(2),:)),1,'Color','y')
hold off
title('Maximum shear. YZ slice','FontSize',fontsize)
subplot(2,3,5)
imagesc(squeeze(vol_fix(:,cz(2),:)),[0 prc99Fixed])
colorbar
hold on
contour(squeeze(BW(:,cz(2),:)),1,'Color','y')
hold off
colormap('gray')
title('Fixed image. XY slice','FontSize',fontsize)
subplot(2,3,3)
imagesc(imrotate(squeeze(feat(cz(1),:,:)),-90),[0 prc99Feat])
colorbar
hold on
contour(imrotate(squeeze(BW(cz(1),:,:)),-90),1,'Color','y')
hold off
title('Maximum shear. XZ slice','FontSize',fontsize)
subplot(2,3,6)
imagesc(imrotate(squeeze(vol_fix(cz(1),:,:)),-90),[0 prc99Fixed])
colorbar
hold on
contour(imrotate(squeeze(BW(cz(1),:,:)),-90),1,'Color','y')
hold off
colormap('gray')
title('Fixed image. XZ slice','FontSize',fontsize)
