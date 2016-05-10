% explore how to extract a surface from max shearing feature image

% load feat and vol_fix
load data

sz=size(feat);
cz = round(sz/2);


%%
if 1==0
    % Otsu's thresholding method
    [level, EM] = graythresh(feat);
else
    level = prctile(feat(:),90);
end
level = 0.1;
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
imagesc(squeeze(feat(cz(1),:,:)),[0 prc99Feat])
colorbar
hold on
contour(squeeze(BW(cz(1),:,:)),1,'Color','y')
hold off
title('Maximum shear. XZ slice','FontSize',fontsize)
subplot(2,3,6)
imagesc(squeeze(vol_fix(cz(1),:,:)),[0 prc99Fixed])
colorbar
hold on
contour(squeeze(BW(cz(1),:,:)),1,'Color','y')
hold off
colormap('gray')
title('Fixed image. XZ slice','FontSize',fontsize)

%% gray-weighted distance transform
%i=5;
i=cz(3);
T1 = graydist(feat(:,:,i),BW(:,:,i),'quasi-euclidean');
figure(3)
subplot(2,2,1)
imagesc(T1)
colorbar
title('graydist')

T2 = graydist(feat(:,:,i),negBW(:,:,i),'quasi-euclidean');
figure(3)
subplot(2,2,2)
imagesc(T2)
colorbar
title('inside')

[T1BW,T1BWidx] = bwdist(BW(:,:,i),'quasi-euclidean');
figure(3)
subplot(2,2,3)
imagesc(T1BW)
colorbar
title('bwdist')

[T2BW,T2BWidx] = bwdist(negBW(:,:,i),'quasi-euclidean');
figure(3)
subplot(2,2,4)
imagesc(T2BW)
colorbar
title('inside')

%% combine and show surface plot

combDist = T1-T2;
figure(4)
surf(combDist)
colorbar
title('combined distance')

%%

figure(5)
subplot(2,2,1)
imagesc(combDist)
title('CombinedDist')
colorbar
for j=1:10:170
    xi=[cz(2) 0];
    yi=[cz(1) j];
    fullLen=norm([xi(1)-xi(2) yi(1)-yi(2)]);
    subplot(2,2,1)
    hold on
    line(xi,yi)
    hold off
    axis equal
    axis tight
    drawnow
    subplot(2,2,2)
    C=improfile(combDist,xi,yi);
    [val,idx]=min(C);
    plot(C)
    hold on
    if val<0
        % only accept minima which are inside segmentation as discussed
        plot(idx,val,'gx')
        dist=idx*fullLen/length(C);
        title(['improfile, 2D dist ' num2str(dist,'%.1f') ' pixels'])
    else
        plot(idx,val,'rx')
        title('improfile')
    end
    hold off
    axis tight
    pause(0.3)
end

%% try idea discussed to use first bwdist and then refine
% just in 2D here
%
subplot(2,2,3)
imagesc(T1BW)
colorbar
title('bwdist')
% get direction from this
closestIdx = T1BWidx(cz(2),cz(1));
[closestRow, closestCol] = ind2sub(size(T1BWidx), closestIdx);
% just to border
%xi=[cz(2) closestCol];
%yi=[cz(1) closestRow];
% extend line
xiNew=[cz(2) closestCol+(closestCol-cz(2))];
yiNew=[cz(1) closestRow+(closestRow-cz(1))];
hold on
line(xiNew,yiNew)
hold off
fullLen=norm([xiNew(1)-xiNew(2) yiNew(1)-yiNew(2)]);
    

subplot(2,2,4)
C=improfile(combDist,xiNew,yiNew);
[val,idx]=min(C);
plot(C)
hold on
if val<0
    % only accept minima which are inside segmentation as discussed
    plot(idx,val,'gx')
    dist=idx*fullLen/length(C);
    title(['improfile, 2D dist ' num2str(dist,'%.1f') ' pixels'])  
else
    plot(idx,val,'rx')
    title('improfile')
end
hold off
axis tight


%% extract all indices below a certain threshold

selectedIdx = find(feat(:)>level);
[selectedRow, selectedCol, selectedSlice] = ind2sub(size(feat), selectedIdx);

figure(6)
plot3(selectedCol,selectedRow,selectedSlice,'r.')
axis equal
axis tight
view(3)
xlabel('x')
ylabel('y')
zlabel('z')


% fit a 3D surface to the points

sf = fit( [selectedCol,selectedRow], selectedSlice, 'poly22'); % 'linearinterp'); %'lowess'); %'poly22','Robust','LAR' );
zhat = sf( selectedCol, selectedRow );

hold on
plot3(selectedCol,selectedRow,zhat,'g.')
hold off
title('fit surface z=f(x,y)')

%% show surface overlayed on images

figure(7)
subplot(2,3,1)
imagesc(feat(:,:,cz(3)),[0 prc99Feat])
colorbar
hold on
contour(BW(:,:,cz(3)),1,'Color','y')
colorbar
idx=find(round(zhat)==cz(3));
plot(selectedCol(idx),selectedRow(idx),'r.')
hold off
subplot(2,3,4)
imagesc(vol_fix(:,:,cz(3)),[0 prc99Fixed])
colorbar
hold on
contour(BW(:,:,cz(3)),1,'Color','y')
colorbar
plot(selectedCol(idx),selectedRow(idx),'r.')
hold off


subplot(2,3,2)
imagesc(squeeze(feat(:,cz(2),:)),[0 prc99Feat])
colorbar
hold on
contour(squeeze(BW(:,cz(2),:)),1,'Color','y')
idx=find(selectedCol==cz(2));
plot(zhat(idx),selectedRow(idx),'r.')
hold off
subplot(2,3,5)
imagesc(squeeze(vol_fix(:,cz(2),:)),[0 prc99Fixed])
colorbar
hold on
contour(squeeze(BW(:,cz(2),:)),1,'Color','y')
idx=find(selectedCol==cz(2));
plot(zhat(idx),selectedRow(idx),'r.')
hold off
colormap('gray')

subplot(2,3,3)
imagesc(squeeze(feat(cz(1),:,:)),[0 prc99Feat])
colorbar
hold on
contour(squeeze(BW(cz(1),:,:)),1,'Color','y')
idx=find(selectedRow==cz(2));
plot(zhat(idx),selectedCol(idx),'r.')
hold off
subplot(2,3,6)
imagesc(squeeze(vol_fix(cz(1),:,:)),[0 prc99Fixed])
colorbar
hold on
contour(squeeze(BW(cz(1),:,:)),1,'Color','y')
idx=find(selectedRow==cz(2));
plot(zhat(idx),selectedCol(idx),'r.')
hold off
colormap('gray')




