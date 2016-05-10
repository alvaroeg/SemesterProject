load /home/alvaroeg/SemesterProject/Data/all_images_features_var.mat
for i = 1:4
    load(['old_points/P_mm_' num2str(i) '_1']);
    P(:,3) = round(infos{i,3}.PixelDimensions(3)/infos{i,3}.PixelDimensions(1)*P(:,3));
    save(['P_mm_' num2str(i) '_1'],'P');
end