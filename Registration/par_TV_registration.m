% register the different datasets included by using parametric TV registration and calculates the TRE
% 
% DESCRIPTION: The datasets included at the beginning of the code are
% registered by using the parametric TV registration proposed in Valeriy 
% Vishnevskiy, Tobias Gass, Gabor Székely, Orcun Goksel MICCAI Workshop on 
% Abdominal Imaging (ABDI): Computational and Clinical Applications
% Boston, MA, USA, September 2014. After the registration process, the
% Target Registration Error (TRE) is calculated. It is calculated for
% landmarks inside the liver, outside, and considering all of them. It is
% also divided in mean of mean, and maximum mean. 


clear all, close all, clc
addpath(genpath('reg_code'));
addpath(genpath('tools'));
%%
d_idxs = [18, 1, 10, 3, 10;...
    19, 1, 6,  1,  9;...
    23, 1, 4,  5,  4;...
    26, 1, 6,  4,  7];
path = 'ETHLiver/';

infos = cell(size(d_idxs, 1), 3);
vols = cell(size(d_idxs, 1), 3);
pts_inside = cell(size(d_idxs, 1), 3);
pts_outside = cell(size(d_idxs, 1), 3);

for i = 1 : size(d_idxs, 1)
    pfname = [path, 'dataset', num2str(d_idxs(i, 1)), '/'];
    infos{i, 1} = mha_read_header([pfname, 'cyc_', num2str(d_idxs(i, 2)), ...
        '_', num2str(d_idxs(i, 3)), '.force_direction.mha']);
    infos{i, 2} = mha_read_header([pfname, 'cyc_', num2str(d_idxs(i, 4)), ...
        '_', num2str(d_idxs(i, 5)), '.force_direction.mha']);
    %     infos{i, 1} = mha_read_header([pfname, 'cyc_', num2str(d_idxs(i, 2)), ...
    %                     '_', num2str(d_idxs(i, 3)), '.mha']);
    %     infos{i, 2} = mha_read_header([pfname, 'cyc_', num2str(d_idxs(i, 4)), ...
    %                     '_', num2str(d_idxs(i, 5)), '.mha']);
    infos{i, 3} = mha_read_header([pfname, 'exhMaster_unmasked.force_direction.mha']);
    vols{i, 1} = double(mha_read_volume(infos{i, 1}));
    vols{i, 2} = double(mha_read_volume(infos{i, 2}));
    vols{i, 3} = double(mha_read_volume(infos{i, 3}));
    
    vols{i, 1} = img_thr(vols{i, 1}, 0, 255, 1);
    vols{i, 2} = img_thr(vols{i, 2}, 0, 255, 1);
    vols{i, 3} = img_thr(vols{i, 3}, 0, 255, 1);
    
    
    [pts_inside{i,1}, ~] = read_vtk([pfname, 'cyc_', num2str(d_idxs(i, 2)), ...
        '_', num2str(d_idxs(i, 3)), 'LMliver.vtk']);
    [pts_inside{i,2}, ~] = read_vtk([pfname, 'cyc_', num2str(d_idxs(i, 4)), ...
        '_', num2str(d_idxs(i, 5)), 'LMliver.vtk']);
    [pts_inside{i,3}, ~] = read_vtk([pfname, 'exhMasterLMliver.vtk']);
    
    [pts_outside{i,1}, ~] = read_vtk([pfname, 'cyc_', num2str(d_idxs(i, 2)), ...
        '_', num2str(d_idxs(i, 3)), 'LMoutside.vtk']);
    [pts_outside{i,2}, ~] = read_vtk([pfname, 'cyc_', num2str(d_idxs(i, 4)), ...
        '_', num2str(d_idxs(i, 5)), 'LMoutside.vtk']);
    [pts_outside{i,3}, ~] = read_vtk([pfname, 'exhMasterLMoutside.vtk']);
    
end

%% new register
pmoved_i = cell(4, 2);
pmoved_o = cell(4, 2);
TREs_i = cell(4, 2);
TREs_o = cell(4, 2);
[nidx, nidxx] = ndgrid(1:size(d_idxs, 1), 1:2);
Knots_res = cell(4, 2);
T_res = cell(4, 2);
features2d = cell(4,2);
features3d = cell(4,2);
%parfor
for pi = 1:numel(nidx)
    pi
    idx = nidx(pi);
    idxx = nidxx(pi);
    spc = infos{idx,3}.PixelDimensions;
    spacing = [6, 6, 2]; % Reduce this parameter. Divide by 2 : [3 3 1]
    
    
    fx = vols{idx, 3};
    
    [voldef_p, Tmin_p, Kmin_p] = register_3d_volume_pyr_linear(vols{idx, idxx}, fx, ...
        0.0, ... %l2 сoef
        180, ... %bending energy coef
        0.0, ... % ignore
        spacing, ...%grid spacing
        3, ... %number of pyramid levels
        1, ... % pixel interpolation 0-linear 1-cubic
        'loc_cc_fast', ... %metric loc_cc_fast or ssd
        [22, 13, 5], ... %window size for loc_cc
        spc, ... %pixel spacing
        [], ... %init
        0, ... %ignore
        60 ... %max iters
        );
    
    opts = [];
    opts.metric='loc_cc_fast'; % loc_cc_fast or ssd as image metric
    opts.metric_param = [14, 1, 1]; % for loc_cc_fast. window size
    % opts.metric='ssd';
    opts.interpolation = 1;
    opts.d1_koef = 0; %% l2-reg
    opts.d2_koef = 0; %% bending-energy
    opts.L1_koef = 0.45; %% TV
    opts.max_iter = 60;
    opts.display = 'off';
    opts.pixel_resolution = spc;
    opts.method = 'lbfgs';
    [imdef, Knots, T, itinfo] = register_volume_lbfgs(vols{idx, idxx}, fx, ...
        Kmin_p,  ... %initialization
        spacing, ... %grid_spacing
        [], 0, ...%ignore it
        opts);
    
    vols{idx, idxx+3} = imdef;
    
    [pmoved_i{pi}, TREs_i{pi}] = ETHliver_cmp_pts(T, pts_inside{idx, 3}, ...
        pts_inside{idx, idxx}, spc);
    [pmoved_o{pi}, TREs_o{pi}] = ETHliver_cmp_pts(T, pts_outside{idx, 3}, ...
        pts_outside{idx, idxx}, spc);
    %TREs and pmoved are in physical space
    
    Knots_res{pi} = Knots;
    T_res{pi} = T;
    
%     [feat3d,feat2d] = gradient_features(T,infos{idx,3});
%     features3d{pi} = feat3d;
%     features2d{pi} = feat2d;
end

%%
% TREs_i{2,1} = TREs_i{2,1}(1:32);
% TREs_i{2,2} = TREs_i{2,2}(1:32);

mean([TREs_i{:}])
% std([TREs_i{:}])
mean([TREs_o{:}])
% std([TREs_o{:}])
mean([TREs_i{:} TREs_o{:}])
% std([TREs_i{:} TREs_o{:}])

fl = @(x)x(:);
mean(fl(cellfun(@max, TREs_i)))
mean(fl(cellfun(@max, TREs_o)))
mean(fl(cellfun(@max, [TREs_i; TREs_o])))

% std(fl(cellfun(@max, TREs_i)))
% std(fl(cellfun(@max, TREs_o)))
% std(fl(cellfun(@max, [TREs_i; TREs_o])))