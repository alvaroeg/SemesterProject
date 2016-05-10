clc
clear all
close all
load /home/alvaroeg/SemesterProject/Data/feat_mm_norm.mat
% load sliding_landmarks/manual_sliding_boundary_1_1.mat
% load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
% feats_mm_norm = feats_mm;


dist = cell(1,11);
lcount = 0;
for level = 0:0.02:0.2
    level
    lcount = lcount + 1;
    dist{lcount} = cell(size(feats_mm_norm));
    for i = 1:4
        i
        for j = 1:2
            clear P;
            load(['../sliding_landmarks/P_mm_' num2str(i) '_1']);
            feat = feats_mm_norm{i,j};
            feat = imgaussian(feat,3); % Image smoothing
            sz=size(feat);
            cz = round(sz/2);
            
            %         level = prctile(feat(:),90);
            
            BW=feat>level;
            negBW=feat<level;
            
            T1 = graydist(feat,BW,'quasi-euclidean');
            T2 = graydist(feat,negBW,'quasi-euclidean');
            [T1BW,T1BWidx] = bwdist(BW,'quasi-euclidean');
            [T2BW,T2BWidx] = bwdist(negBW,'quasi-euclidean');
            combDist = T1-T2;
            
            n_landmarks = size(P,1);
            dist1{i,j} = NaN*ones(1,n_landmarks);
            dist2{i,j} = NaN*ones(1,n_landmarks);
            for pp = 1:n_landmarks
                
                % Starting point
                P_round = round(P(pp,:));
                Plm = [P_round(2),P_round(1),P_round(3)];
                Plm1 = Plm(1);
                Plm2 = Plm(2);
                Plm3 = Plm(3);
                closestIdx = T1BWidx(Plm1,Plm2,Plm3);
                [closestRow, closestCol,closestSlice] = ind2sub(size(T1BWidx), closestIdx);
                
                % extend line.
                % By extending the line in this way, we can be sure that if the closest
                % point is close to our point, we won't obtain a minimum which is far from
                % it.
                % The length of the line is 2*(Plm-closestPoint)
                %             xiNew=[Plm2 closestCol+(closestCol-Plm2)];
                %             yiNew=[Plm1 closestRow+(closestRow-Plm1)];
                %             ziNew=[Plm3 closestSlice+(closestSlice-Plm3)];
                
                %Calculate triangle
                ext_m = 5;
                Pinit = Plm;
                Pend = [closestRow closestCol closestSlice];
                Pclosest = Pend;
                Ptrian = Pclosest-Pinit;
                
                b_trian = isequal(Ptrian,[0 0 0]);
                if b_trian == 0
                    %                 keyboard;
                    y1 = Ptrian(1);
                    x1 = Ptrian(2);
                    z1 = Ptrian(3);
                    
                    a1 = sqrt(x1^2+y1^2);
                    b1 = z1;
                    h1 = sqrt(a1^2+b1^2);
                    b2 = sign(b1)*(h1+ext_m)/sqrt(1+(a1/b1)^2);
                    a2 = a1*(b2/b1-1);
                    
                    z2 = b2;
                    %                 if y1 == 0
                    %                     y2 = 0;
                    %                 else
                    %                     y2 = a2/sqrt(1+(x1/y1)^2);
                    %                 end
                    %                 if x1==0
                    %                     x2 =0;
                    %                 else
                    %                     x2 = a2/a1*x1;
                    %                 end
                    if a1 == 0
                        y2 = 0;
                        x2 = 0;
                    else
                        y2 = a2/a1*y1;
                        x2 = a2/a1*x1;
                    end
                    
                    Tend = [y2 x2 z2];
                    Pend = Pclosest + Tend;
                    
                    if Pend(2) > size(combDist,2)
                        Pend(2) = size(combDist,2);
                    elseif Pend(2) < 1
                        Pend(2) = 1;
                    end
                    if Pend(1) > size(combDist,1)
                        Pend(1) = size(combDist,1);
                    elseif Pend(1) < 1
                        Pend(1) = 1;
                    end
                    if Pend(3) > size(combDist,3)
                        Pend(3) = size(combDist,3);
                    elseif Pend(3) < 1
                        Pend(3) = 1;
                    end
                end
                %             Pinit = [yiNew(1) xiNew(1) ziNew(1)];
                %             Pend = [yiNew(2) xiNew(2) ziNew(2)];
                fullLen=norm(Pend-Pinit);
                
                %If the point is farther than a predifined margin, we search the minimum in the line
                %defined by both points
                bgrow_constr = 0;
                if fullLen>3
                    bgrow_constr = 1;
                    % C=improfile(combDist,xiNew,yiNew);
                    [Y, X, Z] = bresenham_line3d(Pinit,Pend);
                    C = combDist(Y,X,Z);
                    [val,idx_aux]=min(C(:));
                    [idx_y,idx_x,idx_z]=ind2sub(size(C),idx_aux);
                    Pinit_new = [Y(idx_y),X(idx_x),Z(idx_z)];
                    if val<0
                        % only accept minima which are inside segmentation
                        dist1{i,j}(pp) = norm(Pinit_new-Plm);
                    else
                        disp('Non valid minima')
                        keyboard
                    end
                else
                    Pinit_new = Pinit;
                end
                
                search_margin =0;
                bgrow = 1;
                b_lb1 = 1; b_ub1 = 1; b_lb2 = 1; b_ub2 = 1; b_lb3 = 1; b_ub3 = 1;
                lb1 = Pinit_new(1);
                ub1 = Pinit_new(1);
                lb2 = Pinit_new(2);
                lb3 = Pinit_new(3);
                ub3 = Pinit_new(3);
                planeConstr = (Pclosest-Pinit_new)*(Pclosest-Pinit)';
                bound_dir = 2*(planeConstr>0) -1;
                
                meanbox_th = 0.8;
                while bgrow
                    search_margin = search_margin+1;
                    if bgrow_constr
                        
                        if b_lb1
                            lb1 = Pinit_new(1)-search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                lb1 = lb1+search_margin;
                                b_lb1 = 0;
                            end
                        end
                        
                        if b_ub1
                            ub1 = Pinit_new(1)+search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                ub1 = ub1-search_margin;
                                b_ub1 = 0;
                            end
                        end
                        
                        if b_lb2
                            lb2 = Pinit_new(2)-search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                lb2 = lb2+search_margin;
                                b_lb2 = 0;
                            end
                        end
                        
                        if b_ub2
                            ub2 = Pinit_new(2)+search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                ub2 = ub2-search_margin;
                                b_ub2 = 0;
                            end
                        end
                        
                        if b_lb3
                            lb3 = Pinit_new(3)-search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                lb3 = lb3+search_margin;
                                b_lb3 = 0;
                            end
                        end
                        
                        if b_ub3
                            ub3 = Pinit_new(3)+search_margin;
                            b_plane = plane_constrain(lb1,ub1,lb2,ub2,lb3,ub3,Pclosest,Pinit,bound_dir);
                            if b_plane == 0
                                ub3 = ub3-search_margin;
                                b_ub3 = 0;
                            end
                        end
                        
                        if  (b_lb1 == 0 && b_ub1 == 0 && b_lb2 == 0 && b_ub2 == 0 && b_lb3 == 0 && b_ub3 == 0)
                            bgrow = 0;
                            fprintf('Careful!: All bounds in i = %d, j = %d, pp = %d, dist = %d\n',i,j,pp,dist{i,j}(pp));
                        end
                    else
                        lb1 = Pinit(1)-search_margin;
                        ub1 = Pinit(1)+search_margin;
                        lb2 = Pinit(2)-search_margin;
                        ub2 = Pinit(2)+search_margin;
                        lb3 = Pinit(3)-search_margin;
                        ub3 = Pinit(3)+search_margin;
                        
                    end
                    
                    if ub1 > size(combDist,1)
                        ub1 = size(combDist,1);
                    end
                    if lb1 < 1
                        lb1 = 1;
                    end
                    if ub2 > size(combDist,2)
                        ub2 = size(combDist,2);
                    end
                    if lb2 < 1
                        lb2 = 1;
                    end
                    if ub3 > size(combDist,3)
                        ub3 = size(combDist,3);
                    end
                    if lb3 < 1
                        lb3 = 1;
                    end
                    
                    subBW = BW(lb1:ub1,lb2:ub2,lb3:ub3);
                    if mean(subBW(:))<meanbox_th || isequal(size(subBW),size(BW))
                        bgrow = 0;
                    end
                end
                sub_combDist = combDist(lb1:ub1,lb2:ub2,lb3:ub3);
                [val_new,idx_new_aux] = min(sub_combDist(:));
                [idx_y_new,idx_x_new,idx_z_new]=ind2sub(size(sub_combDist),idx_new_aux);
                Pend_new = [idx_y_new+lb1-1,idx_x_new+lb2-1,idx_z_new+lb3-1];
                dist{lcount}{i,j}(pp) = norm(Pend_new-Plm);
                %             keyboard
                
                
                %             if dist{i,j}(pp) >10
                %                 fprintf('Careful!: Big distance in i = %d, j = %d, pp = %d, dist = %d\n',i,j,pp,dist{i,j}(pp));
                %                 keyboard;
                %             end
                
                %         keyboard
            end
        end
    end
end

disp('Distances calculated')
save('/scratch/alvaroeg/validation/dist_threshold.mat','dist');
disp('Save completed')