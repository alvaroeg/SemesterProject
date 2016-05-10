clear all
load distances3d_binary_landmarks
% load distances3d_landmarks
load distances3d_growbox_landmarks

%TODO: include more registrations (time points) for every dataset, and
%study how the mean_dist_bin changes inside the same patient. In theory it
%should be constant, but we can extract conclusions regarding the
%registration method, or more importantly, the threshold choosed according
%to the displacement field. 
for i = 1:size(dist,1)
        aux_maxpoints(i) =  length(dist_bin{i,1});
end
max_points = min(aux_maxpoints);
bin_dist_patient = zeros(size(dist,2)*max_points,size(dist,1));
for i = 1:size(dist,1)
%     bin_dist_patient(:,i) = [];
    for j = 1:size(dist,2)
        mean_dist(i,j) = mean(dist{i,j});
        min_dist(i,j) = min(dist{i,j});
        max_dist(i,j) = max(dist{i,j});
        sum_dist_bin(i,j) = sum(dist_bin{i,j});
        mean_dist_bin(i,j) = mean(dist_bin{i,j});
        
        bin_dist_patient(max_points*(j-1)+1:max_points*j,i) = dist_bin{i,j}(1:max_points)';
        dist_patient(max_points*(j-1)+1:max_points*j,i) = dist{i,j}(1:max_points)';
    end
end
figure
boxplot(dist_patient)
xlabel('Dataset')
ylabel('Distance to sliding boundary (mm)')
