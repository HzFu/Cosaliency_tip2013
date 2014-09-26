% The demo for Cluster-based Saliency Detection in single image

img_path='./img_data/single_data/';
result_path = './img_output/';
name = '1_45_45397.jpg';

%--- cluster number -------
Bin_num_single=6;

%---- scaling the image ---
ScaleH=300;
ScaleW=300;

im=imread([img_path name]);
[orgH orgW channel]=size(im);

%----- obtaining the features -----
[All_vector All_img All_DisVector]=GetImVector(im, ScaleH, ScaleW,0);

%----- image clustering (using Kmean++) ---
[idx,ctrs] = kmeansPP(All_vector',Bin_num_single);
idx=idx'; ctrs=ctrs';

%----- clustering idx map ---------
Cluster_Map = reshape(idx, ScaleH, ScaleW);

%----- computing the Contrast cue -------
Sal_weight_single= Gauss_normal(GetSalWeight( ctrs,idx));

%----- computing the Spatial cue -------
Dis_weight_single= Gauss_normal(GetPositionW( idx, All_DisVector, ScaleW, Bin_num_single ));

%----- combining the cues -------
SaliencyWeight_all=(Sal_weight_single.*Dis_weight_single);

%----- generating the saliency map -----
Saliency_Map_single = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num_single);

Saliency_Map_single=imresize(Gauss_normal(Saliency_Map_single),[orgH orgW]);

imwrite(im,[result_path  name(1:end-4) '_org.png'],'png');
imwrite(imresize(Saliency_Map_single, [orgH orgW]), [result_path  name(1:end-4) '_single.png'],'png');

figure,subplot(1,2,1), imshow(im),title('Input images');
subplot(1,2,2),imshow(Saliency_Map_single),title('Single Saliency');


