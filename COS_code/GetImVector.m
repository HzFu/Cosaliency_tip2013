function [ All_vector All_img Dis_Vector] = GetImVector( img_data, ScaleH, ScaleW ,need_texture)
% Get the vector of image
% Input:
%   img_data: the RGB image.
%   ScaleH, ScaleW: image resize scale.
%   need_texture: 0-without Gabor, 1-with Gabor.
%
% Output:
%   All_vector: The image feature vector (color, texture);
%   All_img: The resized image;
%   Dis_Vector: The image cetner distance;

if need_texture % Gabor parameters
    N=8;
    lambda  = 8;
    theta   = 0;
    psi     = [0 pi/2];
    gamma   = 0.5;
    bw      = 1;
end
    
All_img = imresize(img_data, [ScaleH, ScaleW]);

if need_texture
    img_in = im2double(rgb2gray(All_img));
    Gabor_img = zeros(ScaleH, ScaleW, N);
    for n=1:N
        gb = gabor_fn(bw,gamma,psi(1),lambda,theta)...
            + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta);
        % gb is the n-th gabor filter
        Gabor_img(:,:,n) = imfilter(img_in, gb, 'symmetric');
        % filter output to the n-th channel
        theta = theta + 2*pi/N;
        % next orientation
    end
    Gabor_img = sum(abs(Gabor_img).^2, 3).^0.5;
end

img2 = colorspace('Lab<-RGB',All_img);
All_vector=zeros( ScaleH*ScaleW,3);

if need_texture
    All_vector=zeros( ScaleH*ScaleW,4);
end

Dis_Vector=zeros( ScaleH*ScaleW,1);
for j=1:ScaleH
    for i=1:ScaleW
        All_vector(j +(i-1)*ScaleH,1)=round(img2(j, i, 1));
        All_vector(j +(i-1)*ScaleH,2)=round(img2(j, i, 2));
        All_vector(j +(i-1)*ScaleH,3)=round(img2(j, i, 3));
        if need_texture
            All_vector(j +(i-1)*ScaleH,4)=Gabor_img(j, i);
        end
        Dis_Vector(j +(i-1)*ScaleH)=round(sqrt((i-ScaleW/2)^2+(j-ScaleH/2)^2));
    end
end


end

