function [ h ] = Save_result( data, para, result)
%SAVE_RESULT Summary of this function goes here
%   Detailed explanation goes here

for i=1:para.img_num
   im = data.image{i};
   [imH imW imC] = size(im);
   imwrite(im, [para.result_path para.files_list(i,1).name '_org.png'],'png');
   
   cosal = result.final_map(:, (1 + (i-1)*para.Scale):(i*para.Scale));
   imwrite(imresize(cosal, [imH imW]), [para.result_path para.files_list(i,1).name '_cosaliency.png'],'png');
   
   sigsal = result.single_map(:, (1 + (i-1)*para.Scale):(i*para.Scale));
   imwrite(imresize(sigsal, [imH imW]), [para.result_path para.files_list(i,1).name '_single.png'],'png');
end

h=1;
end

