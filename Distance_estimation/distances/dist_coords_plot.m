clear all
load /home/alvaroeg/SemesterProject/Data/feat_mm_norm.mat
load distances3d_growbox_levels.mat
dist5 = dist{5};
for i = 1:4
    for j = 1:2
        clear P;
        load(['../sliding_landmarks/P_mm_' num2str(i) '_1']);
        feat = feats_mm_norm{i,j};
        distij{i,j}=dist5{i,j};
        for pp = 1:length(distij{i,j})
            x = P(pp,1);
            y = P(pp,2);
            z = P(pp,3);
            featij{i,j}(pp) = feat(y,x,z);
        end
    end
end


%%
vdistij = [];
vfeatij = [];
for i = 1:4
    for j = 1:2
        for pp = 1:length(distij{i,j})
            vdistij = [vdistij distij{i,j}(pp)];
            vfeatij = [vfeatij featij{i,j}(pp)];
        end
    end
end