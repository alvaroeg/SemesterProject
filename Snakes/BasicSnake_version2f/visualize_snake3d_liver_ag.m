function [] = visualize_snake3d_liver_ag(eval_im,FV)


xpos = round(FV.vertices(:,1));
ypos = round(FV.vertices(:,2));
zpos = round(FV.vertices(:,3));
for k = 1:size(eval_im,3)
    fzpos = find(zpos==k);
    zslice_xpos{k} = xpos(fzpos);
    zslice_ypos{k} = ypos(fzpos);
end

for zslice = 1:size(eval_im,3)
% for zslice = 1
    x = zslice_xpos{zslice};
    y = zslice_ypos{zslice};
    figure(2)
    %     close
    imshow(eval_im(:,:,zslice),[])
    str_title = sprintf('Slice %d',zslice);
    title(str_title)
    hold on
    plot(x,y,'*');
    hold off
    pause(0.1)
end