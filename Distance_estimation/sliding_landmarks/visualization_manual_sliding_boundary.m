%% Initialice

clear all, close all
% load manual_sliding_boundary_1_1.mat
% load landmarks_graphs.mat
% load images.mat

load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat


% load ../../all_images_features_var.mat
data_sel = 4;
load(['P_mm_' num2str(data_sel) '_' '1'])
P = round(P);
vol_mov = vols_mm{data_sel,1};
vol_fix = vols_mm{data_sel,3};
% feat = features3d{1,1}{5};
rmin = min([vol_mov(:);vol_fix(:)]);
rmax = max([vol_mov(:);vol_fix(:)]);

show_only_wgraph = 0;
show_wgraph = 0;
show_feat_wgraph = 0;
show_feature = 0;
only_marks = 1;
show_orig = 1;
%%
if show_orig
    if only_marks
        %% Visualize only marks
        zvalues = unique(P(:,3));
        for k = 1:length(zvalues)
            zSlice = zvalues(k);
            str_title = sprintf(' Slice %d',zSlice);
            fzP = find(P(:,3) == zSlice);
            auxP = P(fzP,:);
            h = imshow(vol_fix(:,:,zSlice),[rmin,rmax]);
            %     title(['Fixed image.' str_title])
            hold on
            plot(auxP(:,1),auxP(:,2),'r*','MarkerSize',10)
            %             saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Ground_truth/ground_truth_' k '.jpg']);
            %     close
%             pause()
            disp('asdf')
        end
    else
        %% Visualize all of them
        zvalues = unique(P(:,3));
        count = 1;
        for k = 1:size(vol_fix,3)
            zSlice = k;
            str_title = sprintf(' Slice %d',zSlice);
            fzP = find(P(:,3) == zSlice);
            auxP = P(fzP,:);
            h = imshow(vol_fix(:,:,zSlice),[rmin,rmax]);
            %     title(['Fixed image.' str_title])
            hold on
            if  k == zvalues(count)
                plot(auxP(:,1),auxP(:,2),'r*','MarkerSize',18)
                if k < zvalues(end)
                    count = count+1;
                end
            end
            %         saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Ground_truth/ground_truth_' num2str(k) '.jpg']);
            close
        end
    end
end

%% Show in feature
if show_feature
    rminf = min([feat(:);feat(:)]);
    rmaxf = max([feat(:);feat(:)]);
    zvalues = unique(P(:,3));
    count = 1;
    for k = 1:size(feat,3)
        zSlice = k;
        str_title = sprintf(' Slice %d',zSlice);
        fzP = find(P(:,3) == zSlice);
        auxP = P(fzP,:);
        h = imshow(feat(:,:,zSlice),[rminf,rmaxf]);
        title(['Fixed image.' str_title])
        hold on
        if  k == zvalues(count)
            plot(auxP(:,1),auxP(:,2),'r*','MarkerSize',12)
            if k < zvalues(end)
                count = count+1;
            end
        end
        %         saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Ground_truth/ground_truth_' num2str(k) '.jpg']);
        pause(1)
        %         close
    end
end

%% Visualize all of them with graphs

if show_wgraph
    zvalues = unique(P(:,3));
    count = 1;
    pp = 0;
    for k = 1:size(vol_fix,3)
        figure(21)
        zSlice = k;
        str_title = sprintf(' Slice %d',zSlice);
        fzP = find(P(:,3) == zSlice);
        auxP = P(fzP,:);
        h = imshow(vol_fix(:,:,zSlice),[rmin,rmax]);
        title(['Fixed image.' str_title])
        hold on
        
        if  k == zvalues(count)
            for n_aux = 1:size(auxP,1)
                figure(21)
                pp = pp+1;
                h = imshow(vol_fix(:,:,zSlice),[rmin,rmax]);
                hold on
                plot(auxP(n_aux,1),auxP(n_aux,2),'r*','MarkerSize',10)
                
                figure(22)
                point_mean = all_mean(pp,:);
                point_median = all_median(pp,:);
                point_max = all_max(pp,:);
                point_maxprc = all_maxprc(pp,:);
                
                subplot(221)
                plot(point_mean)
                xlabel('Radius (pixels)')
                title('Mean')
                subplot(222)
                plot(point_median)
                xlabel('Radius (pixels)')
                title('Median')
                subplot(223)
                plot(point_max)
                xlabel('Radius (pixels)')
                title('Maximum')
                subplot(224)
                plot(point_maxprc)
                xlabel('Radius (pixels)')
                title('90 percentile')
                pause()
                close
                
            end
            if k < zvalues(end)
                count = count+1;
            end
        end
        
        %         saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Ground_truth/ground_truth_' num2str(k) '.jpg']);
        %     close
        pause(0.5)
    end
end

%% Visualize feat with graphs

if show_feat_wgraph
    zvalues = unique(P(:,3));
    count = 1;
    pp = 0;
    for k = 1:size(feat,3)
        figure(21)
        zSlice = k;
        str_title = sprintf(' Slice %d',zSlice);
        fzP = find(P(:,3) == zSlice);
        auxP = P(fzP,:);
        h = imshow(feat(:,:,zSlice),[rmin,rmax]);
        title(['Fixed image.' str_title])
        hold on
        
        if  k == zvalues(count)
            for n_aux = 1:size(auxP,1)
                figure(21)
                pp = pp+1;
                h = imshow(feat(:,:,zSlice),[rmin,rmax]);
                hold on
                plot(auxP(n_aux,1),auxP(n_aux,2),'r*','MarkerSize',10)
                
                figure(22)
                point_mean = all_mean(pp,:);
                point_median = all_median(pp,:);
                point_max = all_max(pp,:);
                point_maxprc = all_maxprc(pp,:);
                
                subplot(221)
                plot(point_mean)
                xlabel('Radius (pixels)')
                title('Mean')
                subplot(222)
                plot(point_median)
                xlabel('Radius (pixels)')
                title('Median')
                subplot(223)
                plot(point_max)
                xlabel('Radius (pixels)')
                title('Maximum')
                subplot(224)
                plot(point_maxprc)
                xlabel('Radius (pixels)')
                title('90 percentile')
                pause()
                close
                
            end
            if k < zvalues(end)
                count = count+1;
            end
        end
        
        %         saveas(h,['/home/alvaroeg/SemesterProject/Figures/dataset18/Ground_truth/ground_truth_' num2str(k) '.jpg']);
        %     close
        pause(0.5)
    end
end

%% Only points with graph
if show_only_wgraph
    for kz = 1:size(P,1)
        figure(31)
        zSlice = P(kz,3);
        str_title = sprintf(' Slice %d',zSlice);
        imshow(feat(:,:,zSlice),[rmin,rmax]);
        title(['Fixed image.' str_title])
        hold on
        plot(P(kz,1),P(kz,2),'r*','MarkerSize',10)
        
        figure(32)
        pp = kz;
        point_mean = all_mean(pp,:);
        point_median = all_median(pp,:);
        point_max = all_max(pp,:);
        point_maxprc = all_maxprc(pp,:);
        
        subplot(221)
        plot(point_mean)
        xlabel('Radius (pixels)')
        title('Mean')
        subplot(222)
        plot(point_median)
        xlabel('Radius (pixels)')
        title('Median')
        subplot(223)
        plot(point_max)
        xlabel('Radius (pixels)')
        title('Maximum')
        subplot(224)
        plot(point_maxprc)
        xlabel('Radius (pixels)')
        title('90 percentile')
        pause()
%         close
    end
end