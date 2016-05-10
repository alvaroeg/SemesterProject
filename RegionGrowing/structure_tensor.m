% Calculate structure tensor of morphologically processed image and calculate surfaceness
% 
% DESCRIPTION: the structure tensor of the morphologically processed image
% is calculated by using eigenvalue decomposition of the gradient of
% intensities. Then, a measure of surfaceness is calculated by dividing the
% smallest eigenvalue by the sum of the two greatest eigenvalues

clear all, close all
load data_str_tensor
feat = double(final_sized_mask);
%TODO: smoothing and check A

% load data_str_tensor3
sizes = [1 1 1];

sizeX = sizes(1);
sizeY = sizes(2);
sizeZ = sizes(3);


[Gx,Gy,Gz] = gradient(feat);
Gx = Gx/sizes(1);
Gy = Gy/sizes(2);
Gz = Gz/sizes(3);

for m=1:size(feat,1)
    for n =1:size(feat,2)
        for k = 1:size(feat,3)
            A = [Gx(m,n,k).^2 Gx(m,n,k)*Gy(m,n,k) Gx(m,n,k)*Gz(m,n,k); Gx(m,n,k)*Gy(m,n,k) Gy(m,n,k).^2 Gy(m,n,k)*Gz(m,n,k); Gx(m,n,k)*Gz(m,n,k) Gy(m,n,k)*Gz(m,n,k) Gz(m,n,k).^2];
            A = A'*A;
            [eigT, lambdaT] = eig(A);
            lambda1 = lambdaT(1,1);
            lambda2 = lambdaT(2,2);
            lambda3 = lambdaT(3,3);
            str_tensor(m,n,k) = lambda3/(lambda1+lambda2);
            str_tensor3(m,n,k) = lambda3;
            str_tensor2(m,n,k) = lambda2;
            str_tensor1(m,n,k) = lambda1;
        end
    end
end
vol = str_tensor;
vol(vol==Inf) = max(vol(vol<Inf));
hs = viewer_3midslices(vol);
% saveas(hs,'str_tensor_surface.jpg')