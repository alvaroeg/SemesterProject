clear all
load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
% load sliding_landmarks/manual_sliding_boundary_1_1.mat

dist = cell(size(feats_mm));
for i = 1:4
    for j = 1:2
        clear P;
        load(['sliding_landmarks/P_mm_' num2str(i) '_1']);
        feat = feats_mm{i,j};
        
        level = prctile(feat(:),90); 
        BW=feat>level; 
        T1 = graydist(feat,BW,'quasi-euclidean'); 
        
        n_landmarks = size(P,1);
        
        for pp = 1:n_landmarks
            
            % Starting point
            P_round = round(P(pp,:));
            Plm = [P_round(2),P_round(1),P_round(3)];
            Plm1 = Plm(1);
            Plm2 = Plm(2);
            Plm3 = Plm(3);
            dist{i,j}(pp) = BW(Plm1,Plm2,Plm3);

        end
    end
end
            
            
