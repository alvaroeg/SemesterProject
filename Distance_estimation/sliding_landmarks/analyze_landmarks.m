clear all, close all, clc
load manual_sliding_boundary_1_1.mat
load images.mat
% load ../../all_images_features_var.mat
% data_sel = 1;
% vol_mov = vols{data_sel,1};
% vol_fix = vols{data_sel,3};
% feat = features3d{1,1}{5};

Pr = round(P);

show_points = 1;

rad_count = 0;
for rad_inc = 1:20
    rad_count = rad_count+1;
    for pp = 1:size(Pr,1)
        p1 = Pr(pp,1);
        p2 = Pr(pp,2);
        p3 = Pr(pp,3);
        rad = round(rad_inc.*[1 1 0.5]);
        rad1 = rad(1);
        rad2 = rad(2);
        rad3 = rad(3);
%         if pp == 6
%             keyboard
%         end
        if ~(p1-rad1<1 || p2-rad2<1 || p3-rad3<1 || p1+rad1>size(vol_fix,2) || p2+rad2>size(vol_fix,1) || p3+rad3>size(vol_fix,3))
            land_neigh = feat(p2-rad2:p2+rad2,p1-rad1:p1+rad1,p3-rad3:p3+rad3);
            
            mean_P(pp) = mean(land_neigh(:));
            median_P(pp) = median(land_neigh(:));
            max_P(pp) = max(land_neigh(:));
            maxprc_P(pp) = prctile(land_neigh(:),90);
        else
            mean_P(pp) = NaN;
            median_P(pp) = NaN;
            max_P(pp) = NaN;
            maxprc_P(pp) = NaN;
        end
        
    end
    all_mean(:,rad_count) = mean_P;
    all_median(:,rad_count) = median_P;
    all_max(:,rad_count) = max_P;
    all_maxprc(:,rad_count) = maxprc_P;
    
    rad_mean(rad_count) = mean(mean_P(mean_P>0));
    rad_median(rad_count) = mean(median_P(median_P>0));
    rad_max(rad_count) = mean(max_P(max_P>0));
    rad_maxprc(rad_count) = mean(maxprc_P(maxprc_P>0));
end


figure
subplot(221)
plot(rad_mean)
xlabel('Radius (pixels)')
title('Mean')
subplot(222)
plot(rad_median)
xlabel('Radius (pixels)')
title('Median')
subplot(223)
plot(rad_max)
xlabel('Radius (pixels)')
title('Maximum')
subplot(224)
plot(rad_maxprc)
xlabel('Radius (pixels)')
title('90 percentile')
pause

if show_points
    for pp = 1:size(Pr,1)
        zSlice = Pr(pp,3);
        figure(21)
        imshow(feat(:,:,zSlice),[])
        str_title = sprintf(' Slice %d',zSlice);
        title(['Max shear.' str_title])
        hold on
        plot(P(pp,1),P(pp,2),'r*')
        

        figure(22)
        point_mean = all_mean(pp,:);
        point_median = all_median(pp,:);
        point_max = all_max(pp,:);
        point_maxprc = all_maxprc(pp,:);
        
        subplot(221)
        plot(point_mean)
        xlabel('Radius (pixels)')
        title('Mean')
        subplot(222)
        plot(point_median)
        xlabel('Radius (pixels)')
        title('Median')
        subplot(223)
        plot(point_max)
        xlabel('Radius (pixels)')
        title('Maximum')
        subplot(224)
        plot(point_maxprc)
        xlabel('Radius (pixels)')
        title('90 percentile')
        pause()
    end
end