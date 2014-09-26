% The demo for Cluster-based Co-saliency Detection in multiple images

clc;close all;clear;

img_set_name= 'football_player';
img_path=['./img_data/co_saliency_data/', img_set_name, '/'];
result_path = ['./img_output/', img_set_name, '/'];

if (~exist(result_path, 'dir')) 
    mkdir(result_path);
end

files_list=dir([img_path '*.jpg']);
img_num=length(files_list);

% image resize scale
Scale=200; 

%clustering number on multi-image
Bin_num=min(max(2*img_num,10),30);

%clustering number on single-image
Bin_num_single=6;

%% read images
img_data = cell(img_num, 1);

for i = 1:img_num
   img_data{i} = imread([img_path, files_list(i).name]);
end

%% ------ Obtain the co-saliency for multiple images-------------
%----- obtaining the features -----
All_vector = [];
All_DisVector = [];
All_img = [];
for i=1:img_num
    img = img_data{i};
    [imvector img DisVector]=GetImVector(img, Scale, Scale,0);
    All_vector=[All_vector; imvector];
    All_DisVector=[All_DisVector; DisVector];
    All_img=[All_img img];
end

% ---- clustering via Kmeans++ -------
[idx,ctrs] = kmeansPP(All_vector',Bin_num);
idx=idx';
ctrs=ctrs';

%----- clustering idx map ---------
Cluster_Map = reshape(idx, Scale, Scale*img_num);

%----- computing the Contrast cue -------
Sal_weight_co= Gauss_normal(GetSalWeight( ctrs,idx ));
%----- computing the Spatial cue -------
Dis_weight_co= Gauss_normal(GetPositionW( idx, All_DisVector, Scale, Bin_num ));
%----- computing the Corresponding cue -------
co_weight_co= Gauss_normal(GetCoWeight( idx, Scale, Scale ));
 
%----- combining the Co-Saliency cues -----
SaliencyWeight=(Sal_weight_co.*Dis_weight_co.*co_weight_co);

%----- generating the co-saliency map -----
Saliency_Map_co = Cluster2img( Cluster_Map, SaliencyWeight, Bin_num);


%% ------ Obtain the Single-saliency for each image -------------
%----- the detals see the Demo_single.m ----

Saliency_Map_single = zeros(size(Saliency_Map_co));
for i=1:img_num
    img = img_data{i};
    [imvector img DisVector]=GetImVector(img, Scale, Scale,0);
    [idx,ctrs] = kmeansPP(imvector',Bin_num_single);
    idx=idx'; ctrs=ctrs';
    Cluster_Map = reshape(idx, Scale, Scale);
    Sal_weight=GetSalWeight( ctrs,idx  );
    Dis_weight  = GetPositionW( idx, DisVector, Scale, Bin_num_single );
    Sal_weight= Gauss_normal(Sal_weight);
    Dis_weight= Gauss_normal(Dis_weight); 
    SaliencyWeight_all=(Sal_weight.*Dis_weight);
    Saliency_sig_final = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num_single);
    
    Saliency_Map_single(:,1+(i-1)*Scale:Scale+(i-1)*Scale)=Saliency_sig_final;
end

%% ---- output co-saliency map ----- 
Saliency_Map_final=Saliency_Map_single .* Saliency_Map_co;

% Sum is better for the complex image !
% Saliency_Map_final=Saliency_Map_single + Saliency_Map_co;

figure(1),subplot(3,1,1), imshow(All_img),title('Input images');
subplot(3,1,2), imshow((Saliency_Map_single)),colormap(gray),title('Single Saliency');
subplot(3,1,3), imshow(Saliency_Map_final),colormap(gray),title('Co-Saliency');

for i=1:img_num
   im = img_data{i};
   [imH imW imC] = size(im);
   imwrite(im, [result_path files_list(i,1).name '_org.png'],'png');
   cosal = Saliency_Map_final(:, (1 + (i-1)*Scale):(i*Scale));
   imwrite(imresize(cosal, [imH imW]), [result_path files_list(i,1).name '_cosaliency.png'],'png');
   sigsal = Saliency_Map_single(:, (1 + (i-1)*Scale):(i*Scale));
   imwrite(imresize(sigsal, [imH imW]), [result_path files_list(i,1).name '_single.png'],'png');
end







