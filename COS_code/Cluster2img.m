function [ Saliency_Map_single ] = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num)
%CLUSTER2IMG Summary of this function goes here
%   Detailed explanation goes here

    Saliency_sig_temp=Cluster_Map;
    for j=1:Bin_num
        Saliency_sig_temp(Saliency_sig_temp==j)=SaliencyWeight_all(j);
    end
    Saliency_Map_single = imfilter(Saliency_sig_temp, fspecial('gaussian', [3, 3], 3));

end

