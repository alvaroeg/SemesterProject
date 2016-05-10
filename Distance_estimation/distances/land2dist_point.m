clear all
close all
load land2center_points
load('../sliding_landmarks/P_mm_1_1')
load feat_mask
load('land2center_points_1');
vol_fix = double(feat_mask);
rmin = 0;
rmax = 1;
P = round(P);
Pend = round(Pend);


% load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
% % load ../../all_images_features_var.mat
% data_sel = 1;
% P = round(P);
% vol_mov = vols_mm{data_sel,1};
% vol_fix = vols_mm{data_sel,3};
% % feat = features3d{1,1}{5};
% rmin = min([vol_mov(:);vol_fix(:)]);
% rmax = max([vol_mov(:);vol_fix(:)]);



zvalues = unique(P(:,3));
zvalues2 = unique(Pend(:,3));
count = 1;
count2 = 1;
for k = 1:size(vol_fix,3)
    zSlice = k;
    str_title = sprintf(' Slice %d',zSlice);
    fzP = find(P(:,3) == zSlice);
    fzP2 = find(Pend(:,3) == zSlice);
    auxP = P(fzP,:);
    auxP2 = Pend(fzP2,:);
    h = imshow(vol_fix(:,:,zSlice),[rmin,rmax]);
    %     title(['Fixed image.' str_title])
    hold on
    if  k == zvalues(count)
        h = plot(auxP(:,1),auxP(:,2),'b*','MarkerSize',18);
        if k < zvalues(end)
            count = count+1;
        end
    end
    
    if  k == zvalues2(count2)
        h = plot(auxP2(:,2),auxP2(:,1),'r*','MarkerSize',18);
        if k < zvalues2(end)
            count2 = count2+1;
        end
    end
    
            saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Landmarks_and_insidepoints/land2points_' num2str(k) '.jpg']);
%     pause
    close
end