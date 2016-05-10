function [] = vis_init_countour_ag(I,FV,selSlice,section_sl)

    zSlice = round(size(I,3)/2);
    xSlice = round(size(I,2)/2);
    ySlice = round(size(I,1)/2);

if isequal(section_sl,'XY')
    zSlice = selSlice;
elseif isequal(section_sl,'XZ')
    ySlice = selSlice;
elseif isequal(section_sl,'ZY')
    xSlice = selSlice;
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


[imXY,imZY,imXZ] = orthogonal_3dimages(I);
imXYslice = imXY(:,:,zSlice);
imXZslice = imXZ(:,:,ySlice);
imZYslice = imZY(:,:,xSlice);

if isequal(section_sl,'XY')
    visual_slice_snake(imXYslice,PXY,selSlice);
elseif isequal(section_sl,'XZ')
    visual_slice_snake(imXZslice,PXZ,selSlice);
elseif isequal(section_sl,'ZY')
    visual_slice_snake(imZYslice,PZY,selSlice);
end
end

function P = pos_slice(xpos,ypos,zpos,mid_slice)

fzpos = find(zpos==mid_slice);
x = xpos(fzpos);
y = ypos(fzpos);
P = [y x];

end

function [] = visual_slice_snake(I,P,selSlice)

h=figure(21); set(h,'render','opengl')
imshow(I,[]);
hold on; plot(P(:,2),P(:,1),'b.'); hold on;
str_title = sprintf('Slice %d',selSlice);
title(str_title)
end