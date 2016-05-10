function maxshear = max_shear_stretch(T,info_mov)
%calculate the maximum shear stretch of a displacement field
%
% SYNOPSIS: maxshear = max_shear_stretch(T,info_mov)
%
% DESCRIPTION: the displacement field resulting from a registration is used
% to calculate the maximum shear stretch image. For this, the gradient for
% every component and every direction is first calculated. Then, eigenvalue
% decomposition is used in order to calculate the maximum shear stretch at
% each voxel by diving by two the difference between the maximum and the
% minimum eigenvalues
%
% INPUT T: 4D displacement field
%       info_mov: information about the registered image
%
% OUTPUT maxshear: maximum shear stretch of the registered image
%
% REMARKS The input displacement field T should not be scaled

[Gx1,Gy1,Gz1] = gradient(T(:,:,:,1));
Gx1 = Gx1/info_mov.PixelDimensions(1);
Gy1 = Gy1/info_mov.PixelDimensions(2);
Gz1 = Gz1/info_mov.PixelDimensions(3);

[Gx2,Gy2,Gz2] = gradient(T(:,:,:,2));
Gx2 = Gx2/info_mov.PixelDimensions(1);
Gy2 = Gy2/info_mov.PixelDimensions(2);
Gz2 = Gz2/info_mov.PixelDimensions(3);

[Gx3,Gy3,Gz3] = gradient(T(:,:,:,3));
Gx3 = Gx3/info_mov.PixelDimensions(1);
Gy3 = Gy3/info_mov.PixelDimensions(2);
Gz3 = Gz3/info_mov.PixelDimensions(3);

GT(:,:,:,1,1) = Gx1;
GT(:,:,:,1,2) = Gy1;
GT(:,:,:,1,3) = Gz1;
GT(:,:,:,2,1) = Gx2;
GT(:,:,:,2,2) = Gy2;
GT(:,:,:,2,3) = Gz2;
GT(:,:,:,3,1) = Gx3;
GT(:,:,:,3,2) = Gy3;
GT(:,:,:,3,3) = Gz3;

for i = 1:size(T,1)
    for j = 1:size(T,2)
        for k = 1:size(T,3)
            aux_GT = squeeze(GT(i,j,k,:,:));
            [aux_eigGT, aux_sigmaGT] = eig(aux_GT'*aux_GT);
            sigmaGT(i,j,k,:,:) = sqrt(aux_sigmaGT);
            eigGT(i,j,k,:,:) = aux_eigGT;     
        end
    end
end
lambda1 = sigmaGT(:,:,:,1,1);
lambda2 = sigmaGT(:,:,:,2,2);
lambda3 = sigmaGT(:,:,:,3,3);

alambda1 = abs(lambda1);
alambda2 = abs(lambda2);
alambda3 = abs(lambda3);

maxshear = (alambda3-alambda1)/2;

end

