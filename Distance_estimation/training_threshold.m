% Train threshold value and extract statistics
% 
% DESCRIPTION: the distance measure previously extracted is used here to
% train a threshold value by using training data, and then using it in a
% test data so that different statistics are extracted. The process is
% repeated for different combinations of training and test data

clear all
clc
addpath('distances')
load distances3d_growbox_levels.mat

train_set = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
test_set = [4;3;2;1];
t_level = 0:0.02:0.2;
% for t = 1:length(dist)
%     for i = 1:size(dist{1})
%         dist_dataset(i,t) = mean([dist{t}{i,1} dist{t}{i,2}]);
%     end
% end

for ntrain = 1:size(train_set,1)
    ntrain
    for t = 1:length(dist)
        for nset = 1:size(train_set,2)
            i = train_set(ntrain,nset);
            dist_dataset{ntrain}(nset,t) = mean([dist{t}{i,1} dist{t}{i,2}]);
        end
    end
    
    [val,pos] = min(dist_dataset{ntrain},[],2);
    for k = 1:length(pos)
        best_th(k) = t_level(pos(k));
    end
    mean_th(ntrain) = mean(best_th);
    std_th(ntrain) = std(best_th);
    
    %Closest threhsold
%     best_th_val = mean(best_th);
%     v_mins = abs(t_level-best_th_val);
%     [~,pos_closest_th]] = min(v_mins);
%     closest_th = t_level(pos_closest_th);
    
    dist_aux = distance_growbox_func(mean_th(ntrain),test_set(ntrain));
    vdist_aux = [dist_aux{1} dist_aux{2}];
    mean_dist(ntrain) = mean(vdist_aux);
    std_dist(ntrain) = std(vdist_aux);
end

mean_mean_th = mean(mean_th)
mean_std_th = mean(std_th)

mean_mean_dist = mean(mean_dist)
mean_std_dist = mean(std_dist)



