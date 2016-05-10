% Visualize the distances from ground truth to the sliding boundary location
% 
% DESCRIPTION: the distances from the manually annotated sliding boundary
% points to the sliding boundary location are manipulated here in order to
% visualize them

clear all
addpath('distances')
load /home/alvaroeg/SemesterProject/Data/feat_mm_norm.mat
load distances3d_growbox_levels.mat
% load distances3d_growbox_nonorm_levels.mat
% load distances3d_growbox_norm_gaussian_levels.mat

level_length = 0;

for i = 1:size(dist{1},1)
    for j = 1:size(dist{1},2)
        level_length = level_length+length(dist{1}{i,j});
    end
end

vlevel = 0:0.02:0.2;
mean_vdist = [];
BW_sum = [];
dist_level = zeros(level_length,length(dist));
for nlevel = 1:length(dist)
    aux_dist_level = [];
    level = vlevel(nlevel);
    for i = 1:size(dist{nlevel},1)
        for j = 1:size(dist{nlevel},2)
            feat = feats_mm_norm{i,j};
            BW=feat>level;
            mean_vdist = [mean_vdist; mean(dist{nlevel}{i,j})];
            BW_sum = [BW_sum; sum(BW(:))];
            aux_dist_level = [aux_dist_level; dist{nlevel}{i,j}'];
        end
    end
    dist_level(:,nlevel) = aux_dist_level;
end

t_level = 0:0.02:0.2;

figure
boxplot(dist_level(:,2:end),t_level(2:end))
xlabel('Threshold')
ylabel('Distance to sliding boundary (mm)')
title('Box plot with normalized max shears')

figure
plot(t_level(2:end),mean(dist_level(:,2:end)),'b*')
xlabel('Threshold')
ylabel('Mean distance to sliding boundary (mm)')
title('Mean of distance with normalized max shears')

% figure
% plot(BW_sum,mean_vdist,'*')
% xlabel('Sum of mask')
% ylabel('Mean distance (mm)')