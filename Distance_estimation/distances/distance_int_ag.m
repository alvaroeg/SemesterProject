clear all
load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
% load sliding_landmarks/manual_sliding_boundary_1_1.mat


dist1 = cell(size(feats_mm));
dist2 = cell(size(feats_mm));
dist = cell(size(feats_mm));
for i = 1:4
    for j = 1:2
        i
        j
        clear P;
        load(['sliding_landmarks/P_mm_' num2str(i) '_1']);
        feat = feats_mm{i,j};
        sz=size(feat);
        cz = round(sz/2);
        
        level = prctile(feat(:),90);
        
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
            Pend_aux = Pend;
            Ptrian = Pend_aux-Pinit;
            
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
                Pend = Pend_aux + Tend;
                
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
            search_margin = 5;
            
            %If the point is farther than a predifined margin, we search the minimum in the line
            %defined by both points
            if fullLen>search_margin
                % C=improfile(combDist,xiNew,yiNew);
                [Y, X, Z] = bresenham_line3d(Pinit,Pend);
                C = combDist(Y,X,Z);
                [val,idx_aux]=min(C(:));
                [idx_y,idx_x,idx_z]=ind2sub(size(C),idx_aux);
                Pinit_new = [Y(idx_y),X(idx_x),Z(idx_z)];
                if val<0
                    % only accept minima which are inside segmentation
                    dist{i,j}(pp) = norm(Pinit_new-Plm);
                else
                    disp('Non valid minima')
                    keyboard
                end
            else
                Pinit_new = Pinit;
                
                
                % Search minima in small region defined by search_margin
                
                lb1 = Pinit(1)-search_margin;
                ub1 = Pinit(1)+search_margin;
                lb2 = Pinit(2)-search_margin;
                ub2 = Pinit(2)+search_margin;
                lb3 = Pinit(3)-search_margin;
                ub3 = Pinit(3)+search_margin;
                if ub1 > size(combDist,1)
                    ub1 = size(combDist,1);
                elseif lb1 < 1
                    lb1 = 1;
                end
                if ub2 > size(combDist,2)
                    ub2 = size(combDist,2);
                elseif lb2 < 1
                    lb2 = 1;
                end
                if ub3 > size(combDist,3)
                    ub3 = size(combDist,3);
                elseif lb3 < 1
                    lb3 = 1;
                end
                
                sub_combDist = combDist(lb1:ub1,lb2:ub2,lb3:ub3);
                [val_new,idx_new_aux] = min(sub_combDist(:));
                [idx_y_new,idx_x_new,idx_z_new]=ind2sub(size(sub_combDist),idx_new_aux);
                Pend_new = [idx_y_new+lb1-1,idx_x_new+lb2-1,idx_z_new+lb3-1];
                dist{i,j}(pp) = norm(Pend_new-Plm);
                %             keyboard
            end
            if dist{i,j}(pp) >10
                fprintf('Careful!: Big distance in i = %d, j = %d, pp = %d, dist = %d\n',i,j,pp,dist{i,j}(pp));
                %                 keyboard;
            end
        end
        %         keyboard
    end
end
