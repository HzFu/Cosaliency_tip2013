function [ Saliency_Map_single ] = Single_saliency_main( data, img_num, Scale, Bin_num_single)
%SINGLE_SALIENCY_MAIN Summary of this function goes here
%   Detailed explanation goes here

Saliency_Map_single = zeros([Scale,Scale*img_num]);

for i=1:img_num
    img = data.image{i};
    [imvector, ~, DisVector]=GetImVector(img, Scale, Scale,0);
    [idx,ctrs] = kmeansPP(imvector',Bin_num_single);
    idx=idx'; ctrs=ctrs';
    Cluster_Map = reshape(idx, Scale, Scale);
    Sal_weight=GetSalWeight( ctrs,idx  );
    Dis_weight  = GetPositionW( idx, DisVector, Scale, Bin_num_single );
    Sal_weight= Gauss_normal(Sal_weight);
    Dis_weight= Gauss_normal(Dis_weight);
    SaliencyWeight_all=(Sal_weight .* Dis_weight);
    Saliency_sig_final = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num_single);
    
    Saliency_Map_single(:,1+(i-1)*Scale:Scale+(i-1)*Scale)=Saliency_sig_final;
end

end

