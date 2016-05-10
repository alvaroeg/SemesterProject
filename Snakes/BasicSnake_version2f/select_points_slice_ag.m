load dataseg

for zSlice = 1:size(feat,3)
    I = feat(:,:,zSlice);
    imshow(I,[]);
    [x,y] = ginput;
    P = round([y x]);
    slPoints{zSlice} = P;
end
