% Visualize local image statistics of the sliding boundary landmarks
% 
% DESCRIPTION: All the manually selected sliding boundary points are used
% to study different local image statistics for a group of voxels (local region). 
% For this, a ground truth landmark is used as the seed point for a growing sphere

clear all, close all, clc
load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
data_sel = 1;
cyc_sel = 1;
load(['sliding_landmarks/P_mm_' num2str(data_sel) '_' '1'])

P = round(P);
vol_mov = vols_mm{data_sel,cyc_sel};
vol_fix = vols_mm{data_sel,3};
feat = feats_mm{data_sel,cyc_sel};
rmin = min([vol_mov(:);vol_fix(:)]);
rmax = max([vol_mov(:);vol_fix(:)]);

Pr = round(P);

show_points = 1;


% Paux = [160 155 50];
% Pr(5,:) = Paux;
% P(5,:) =Paux;


rad_count = 0;
for rad_inc = 0:20
    rad_count = rad_count+1;
    for pp = 1:size(Pr,1)
        p1 = Pr(pp,1);
        p2 = Pr(pp,2);
        p3 = Pr(pp,3);
        rad = round(rad_inc.*[1 1 1]);
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
xlabel('Radius (mm)')
title('Mean')
subplot(222)
plot(rad_median)
xlabel('Radius (mm)')
title('Median')
subplot(223)
plot(rad_max)
xlabel('Radius (mm)')
title('Maximum')
subplot(224)
plot(rad_maxprc)
xlabel('Radius (mm)')
title('90 percentile')
pause

if show_points
    for pp = 1:size(Pr,1)
        pp
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
        t = 0:(length(point_mean)-1);
        
        subplot(221)
        plot(t,point_mean)
        xlabel('Radius (mm)')
        title('Mean')
        xlim([t(1) t(end)]);
        subplot(222)
        plot(t,point_median)
        xlabel('Radius (mm)')
        title('Median')
        xlim([t(1) t(end)]);
        subplot(223)
        plot(t,point_max)
        xlabel('Radius (mm)')
        title('Maximum')
        xlim([t(1) t(end)]);
        subplot(224)
        plot(t,point_maxprc)
        xlabel('Radius (mm)')
        title('90 percentile')
        xlim([t(1) t(end)]);
%         pause()
        
        y = point_mean(point_mean>0);
        t1 = 1:length(y);
        p = polyfit(t1,y,1);
        y1 = polyval(p,t1);
        slope_mean(pp) = p(1);
        [val,idx] = max(y);
        dist_mean(pp) = idx-1;
        
%         if pp==5
%             keyboard
%         end
    end
    
    figure
    aux_slope_mean = slope_mean-mean(slope_mean);
    norm_slope_mean = aux_slope_mean/max(abs(aux_slope_mean));
    aux_dist_mean = dist_mean-mean(dist_mean);
    norm_dist_mean = aux_dist_mean/max(abs(aux_dist_mean));
    stem(norm_slope_mean);
    hold on
    stem(norm_dist_mean,'r*');
    legend('Slope','Radius');
    title('Both parameters normalized')
    xlabel('Landmark number')
    
    figure
    stem(slope_mean)
    title('Slope of the evolution of the mean')
    xlabel('Landmark number')
    
    figure
    stem(dist_mean)
    title('Radius of max mean [mm]')
    xlabel('Landmark number')
    
end

