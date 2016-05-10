% Manually select sliding boundary points
%
% DESCRIPTION: different visualization techniques are used to show both
% the fixed and moving images so that the selection of sliding boundary
% points (ground truth) is an easier task. In order to manually select the 
% landmarks the program iterates between different slices, and for each of 
% them two images (fixed and moving images) where flipped. This is repeated 
% for each slice in the coronal, sagittal and transversal views


close all, clear all
% load /home/alvaroeg/SemesterProject/Data/all_images_features_var.mat
load /home/alvaroeg/SemesterProject/Data/images_feat_mm.mat
data_sel = 1;
cyc_sel = 1;
% vol_mov = vols{data_sel,1};
% vol_fix = vols{data_sel,3};

vol_mov = vols_mm{data_sel,cyc_sel};
vol_fix = vols_mm{data_sel,3};

rmin = min([vol_mov(:);vol_fix(:)]);
rmax = max([vol_mov(:);vol_fix(:)]);
P = [];
% load P_test
% Trick for fullscreen (didn't work otherwise)
figure(2)
imshow(vol_fix(:,:,15),[])
set(gcf,'units','normalized','outerposition',[0 0 1 1])
hold on

zSlice = 1;
loop_z = 1;
sbutton = '1';
while loop_z
    % for zSlice=1:size(vol_fix,3)
    str_title = sprintf(' Slice %d/%d',zSlice,size(vol_fix,3));
    
    sl_vol_fix = vol_fix(:,:,zSlice);
    sl_vol_mov = vol_mov(:,:,zSlice);
    
    %     figure(1)
    %     subplot(131)
    %     imshow(sl_vol_fix,[rmin,rmax])
    %
    %     title(['Fixed image.' str_title])
    %     subplot(132)
    %     imshow(sl_vol_mov,[rmin,rmax])
    %     title('Moving image')
    %     subplot(133)
    %     imshow(abs(sl_vol_fix - sl_vol_mov),[])
    %     title('Fixed - Moving')
    
    figure(2)
    p_stay =1;
    while p_stay
        q1 = [];
        if ~isempty(P)
            [q1] = find(P(:,3)==zSlice);
        end
        imshow(sl_vol_fix,[rmin,rmax])
        title(['Fixed image.' str_title])
        if ~isempty(q1)
            hold on
            plot(P(q1,1),P(q1,2),'r*')
        end
        [x1,y1,sbutton] = ginput(1);
        if sbutton == 3
            imshow(sl_vol_mov,[rmin,rmax])
            title(['Moving image.' str_title])
            pause;
        elseif sbutton == 113
            loop_z = 0;
            p_stay=0;
        elseif sbutton == 1
            p_stay2 = 1;
            smargin = 30;
            
            bound_l = round(x1-smargin);
            bound_r = round(x1+smargin);
            bound_u = round(y1-smargin);
            bound_d = round(y1+smargin);
            
            if bound_l < 1
                bound_l = 1;
            end
            if bound_r > size(sl_vol_fix,2)
                bound_r = size(sl_vol_fix,2);
            end
            if bound_u < 1
                bound_u = 1;
            end
            if bound_d > size(sl_vol_fix,1)
                bound_d = size(sl_vol_fix,1);
            end
            
            
            sub_fix = sl_vol_fix(bound_u:bound_d,bound_l:bound_r);
            sub_mov = sl_vol_mov(bound_u:bound_d,bound_l:bound_r);
            rmin2 = min([sub_mov(:);sub_fix(:)]);
            rmax2 = max([sub_mov(:);sub_fix(:)]);
            
            while p_stay2
                imshow(sub_fix,[rmin2,rmax2])
                title(['Fixed image patch.' str_title])
                set(gcf,'units','normalized','outerposition',[0 0 1 1])
                [x,y,sbutton] = ginput(1);
                
                
                if sbutton == 3
                    imshow(sub_mov,[rmin2,rmax2])
                    set(gcf,'units','normalized','outerposition',[0 0 1 1])
                    title(['Moving image patch.' str_title])
                    pause;
                elseif sbutton == 1
                    x = round(x + bound_l - 1);
                    y = round(y + bound_u - 1);
                    P = [P; x y zSlice]
                    p_stay2 =0;
                else
                    p_stay2 =0;
                end
            end
            
        else
            p_stay = 0;
        end
    end
    if sbutton >= 49 && sbutton <= 57
        zSlice = zSlice + sbutton - 48;
    else
        zSlice = zSlice+1;
    end
    if zSlice > size(vol_fix,3)
        loop_z = 0;
    end
end

close all
figure(2)
sl_vol_fix = squeeze(vol_fix(100,:,:))';
imshow(sl_vol_fix,[])
set(gcf,'units','normalized','outerposition',[0 0 1 1])
hold on

ySlice = 1;
loop_y = 1;
sbutton = '1';
while loop_y
    % for ySlice=1:size(vol_fix,3)
    
    str_title = sprintf(' Slice %d/%d',ySlice,size(vol_fix,1));
    
    sl_vol_fix = squeeze(vol_fix(ySlice,:,:))';
    sl_vol_mov = squeeze(vol_mov(ySlice,:,:))';
    
    figure(2)
    p_stay =1;
    while p_stay
        q1 = [];
        if ~isempty(P)
            [q1] = find(P(:,2)==ySlice);
        end
        imshow(sl_vol_fix,[rmin,rmax])
        title(['Fixed image.' str_title])
        if ~isempty(q1)
            hold on
            plot(P(q1,1),P(q1,3),'r*')
        end
        [y1,x1,sbutton] = ginput(1);
        if sbutton == 3
            imshow(sl_vol_mov,[rmin,rmax])
            title(['Moving image.' str_title])
            pause;
        elseif sbutton == 113
            loop_y = 0;
            p_stay=0;
        elseif sbutton == 1
            p_stay2 = 1;
            smargin = 30;
            smarginz = 6;
            
            bound_l = round(x1-smarginz);
            bound_r = round(x1+smarginz);
            bound_u = round(y1-smargin);
            bound_d = round(y1+smargin);
            
            if bound_l < 1
                bound_l = 1;
            end
            if bound_r > size(sl_vol_fix,1)
                bound_r = size(sl_vol_fix,1);
            end
            if bound_u < 1
                bound_u = 1;
            end
            if bound_d > size(sl_vol_fix,2)
                bound_d = size(sl_vol_fix,2);
            end
            
            
            sub_fix = sl_vol_fix(bound_l:bound_r,bound_u:bound_d);
            sub_mov = sl_vol_mov(bound_l:bound_r,bound_u:bound_d);
            rmin2 = min([sub_mov(:);sub_fix(:)]);
            rmax2 = max([sub_mov(:);sub_fix(:)]);
            
            while p_stay2
                imshow(sub_fix,[rmin2,rmax2])
                title(['Fixed image patch.' str_title])
                set(gcf,'units','normalized','outerposition',[0 0 1 1])
                [y,x,sbutton] = ginput(1);
                
                
                if sbutton == 3
                    imshow(sub_mov,[rmin2,rmax2])
                    set(gcf,'units','normalized','outerposition',[0 0 1 1])
                    title(['Moving image patch.' str_title])
                    pause;
                elseif sbutton == 1
                    x = round(x + bound_l - 1);
                    y = round(y + bound_u - 1);
                    P = [P; y ySlice x]
                    p_stay2 =0;
                else
                    p_stay2 =0;
                end
            end
            
        else
            p_stay = 0;
        end
    end
    
    if sbutton >= 49 && sbutton <= 57
        ySlice = ySlice + sbutton - 48;
    else
        ySlice = ySlice+1;
    end
    if ySlice>size(vol_fix,1)
        loop_y = 0;
    end
end

conf_save = input('Do you want to save the results? (y/n): ','s');
if isequal(conf_save,'y')
    save(['P_mm_' num2str(data_sel) '_' num2str(cyc_sel)],'P')
end