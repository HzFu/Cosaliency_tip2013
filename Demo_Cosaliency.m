%% The demo for Cluster-based Co-saliency Detection in multiple images

clc;close all;clear;

addpath('./COS_code');

%% image set 
para.img_set_name= 'football_player';
para.img_path=['./img_data/co_saliency_data/', para.img_set_name, '/'];
para.result_path = ['./img_output/', para.img_set_name, '/'];

if (~exist(para.result_path, 'dir')) 
    mkdir(para.result_path);
end

%% co-saliency parameters
para.files_list=dir([para.img_path '*.jpg']);
para.img_num=length(para.files_list);
% image resize scale
para.Scale=200; 
%clustering number on multi-image
para.Bin_num=min(max(2 * para.img_num,10),30);
%clustering number on single-image
para.Bin_num_single=6;

%% read images
data.image = cell(para.img_num,1);

for img_idx = 1:para.img_num
   data.image{img_idx} = imread([para.img_path, para.files_list(img_idx).name]);
end

%% cosaliency detection
[ result.cos_map, result.All_img] = Cosaliency_main( data, para);

%% single sliency detection
result.single_map = Single_saliency_main( data,para);

%% combine saliency map
result.final_map = result.single_map .* result.cos_map;

%% save the results
figure(1),subplot(3,1,1), imshow(result.All_img),title('Input images');
subplot(3,1,2), imshow(result.single_map),colormap(gray),title('Single Saliency');
subplot(3,1,3), imshow(result.final_map),colormap(gray),title('Co-Saliency');
Save_result( data, para, result);







