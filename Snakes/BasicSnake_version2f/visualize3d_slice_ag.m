function [] = visualize3d_slice_ag(I,Eext,Fext,FV,count,selSlice,nIterations)

if isempty(selSlice)
    zSlice = round(size(I,3)/2);
    xSlice = round(size(I,2)/2);
    ySlice = round(size(I,1)/2);
else
    zSlice = selSlice(3);
    xSlice = selSlice(2);
    ySlice = selSlice(1);
end

sizeX = size(I,2);
sizeY = size(I,1);
sizeZ = size(I,3);

xpos = round(FV.vertices(:,1));
ypos = round(FV.vertices(:,2));
zpos = round(FV.vertices(:,3));

PXY = pos_slice(xpos,ypos,zpos,zSlice);
PXZ = pos_slice(xpos,zpos,ypos,ySlice);
PZY = pos_slice(zpos,ypos,xpos,xSlice);

if count == 0 || isempty(count)
    
    [imXY,imZY,imXZ] = orthogonal_3dimages(I);
    imXYslice = imXY(:,:,zSlice);
    imXZslice = imXZ(:,:,ySlice);
    imZYslice = imZY(:,:,xSlice);
    
    [EextXY,EextZY,EextXZ] = orthogonal_3dimages(Eext);
    EextXYslice = EextXY(:,:,zSlice);
    EextXZslice = EextXZ(:,:,ySlice);
    EextZYslice = EextZY(:,:,xSlice);
    
    for iFext = 1:size(Fext,4)
        [FextXY(:,:,:,iFext),FextZY(:,:,:,iFext),FextXZ(:,:,:,iFext)] = orthogonal_3dimages(Fext(:,:,:,iFext));
        FextXYslice(:,:,iFext) = FextXY(:,:,zSlice,iFext);
        FextXZslice(:,:,iFext) = FextXZ(:,:,ySlice,iFext);
        FextZYslice(:,:,iFext) = FextZY(:,:,xSlice,iFext);
    end
    
    visual_slice_snake(imXYslice,EextXYslice,FextXYslice,PXY,11);
    visual_slice_snake(imXZslice,EextXZslice,FextXZslice,PXZ,12);
    visual_slice_snake(imZYslice,EextZYslice,FextZYslice,PZY,13);
    
elseif count>0
    mov_visual_slice_snake(PXY,count,nIterations,11);
    mov_visual_slice_snake(PXZ,count,nIterations,12);
    mov_visual_slice_snake(PZY,count,nIterations,13);
end

end

function P = pos_slice(xpos,ypos,zpos,mid_slice)

fzpos = find(zpos==mid_slice);
x = xpos(fzpos);
y = ypos(fzpos);
P = [y x];

end

function [] = visual_slice_snake(I,Eext,Fext,P,nFig)

h=figure(nFig); set(h,'render','opengl')
% subplot(2,2,1),
% imshow(I,[]);
% hold on; plot(P(:,2),P(:,1),'b.'); hold on;
% title('The image with initial contour')
% subplot(2,2,2),
% imshow(Eext,[]);
% title('The external energy');
% 
% subplot(2,2,3),
% [x,y]=ndgrid(1:10:size(Fext,1),1:10:size(Fext,2));
% imshow(I), hold on; quiver(y,x,Fext(1:10:end,1:10:end,2),Fext(1:10:end,1:10:end,1));
% title('The external force field ')
% 
% % subplot(2,2,3),
% % [x,y]=ndgrid(1:10:size(Fext,1),1:10:size(Fext,2));
% % imshow(I), hold on; quiver(y,x,Fext(1:10:end,1:10:end,2),Fext(1:10:end,1:10:end,1));
% % title('The external force field ')
% 
% subplot(2,2,4),
imshow(I), hold on; plot(P(:,2),P(:,1),'b.');
% title('Snake movement ')
drawnow

end

function [] = mov_visual_slice_snake(P,i,nIterations,nFig)

% if(ishandle(h)), delete(h), end
figure(nFig), 
% subplot(224)
c=i/nIterations;
h=plot(P(:,2),P(:,1),'.','Color',[c 1-c 0]);
% plot([P(:,2);P(1,2)],[P(:,1);P(1,1)],'.','Color',[c 1-c 0]);
drawnow

end
