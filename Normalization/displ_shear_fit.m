%Study relationship between max shear and displacement field
%
% DESCRIPTION: The displacement fields resulting from different
% registrations are used to study the relationship between the mean maximum
% shear stretch and the mean displacement field for each of them

% Collect statistics

clear all, close all, clc
load /home/alvaroeg/SemesterProject/Data/complete_datasets/complete_feats.mat
% load /home/alvaroeg/SemesterProject/Data/complete_datasets/complete_T.mat
load /home/alvaroeg/SemesterProject/Data/complete_datasets/complete_datasets_nofeat.mat

%% max shear vs motion mag
count = 0;
for i = 1:length(feats)
    for j = 1:length(feats{i})
        i
        j
        count = count+1;
        clear T feat
        T = T_res{i}{j};
        feat = feats{i}{j}{5};
        mean_feat(count) = mean(feat(:));
        mean_T(count) = mean(T(:));
        if abs(mean_T(count)) < 0.4 || abs(mean_T(count)) > 2.2
%             keyboard;
        end
        mean_feat_prc(count) = mean(feat(feat>(prctile(feat(:),70))));
        mean_T_prc(count) = mean(T(T>(prctile(T(:),70))));

    end
end

%% Plot results

% figure
% plot(mean_feat(:),abs(mean_T(:)),'*')
% xlabel('Max shear')
% ylabel('Displacement field')

% figure
% plot(mean_feat_prc(:),abs(mean_T_prc(:)),'*')
% xlabel('Max shear')
% ylabel('Displacement field')

x = mean_feat(:);
y = abs(mean_T(:));
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
rsq = 1-SSresid/SStotal;

figure
plot(x,y,'*')
hold on
plot(x,yfit,'r')
xlabel('Mean maximum shear stretch')
ylabel('Mean displacement field [mm]')