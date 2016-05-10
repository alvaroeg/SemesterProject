%Apply normalization factor to all max shear images
%
% DESCRIPTION: After checking the relationship between the mean maximum
% shear stretch and the mean displacement field, a normalization factor is
% applied to all maximum shear images. They are divided by the mean
% displacement field

load fit_poly
load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat

for i = 1:size(feats_mm,1)
    for j = 1:size(feats_mm,2)
        max_shear = feats_mm{i,j};
        T = T_res_mm{i,j};
        norm_coef = abs(mean(T(:)));
        if norm_coef > 0.15
            max_shear_norm = max_shear/norm_coef;
            feats_mm_norm{i,j} = max_shear_norm;
        else
            feats_mm_norm{i,j} = [];
        end
        
    end
end
