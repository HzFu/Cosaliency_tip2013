function [ Dis_weight ] = GetPositionW( idx, All_DisVector, ScaleW, Bin_num )
%GETPOSITIONW Summary of this function goes here
%   Detailed explanation goes here

Dis_weight=zeros(Bin_num,1);

for i=1:Bin_num
%     Dis_weight(i)=1/(sum(All_DisVector(idx==i))/size(All_DisVector(idx==i),1)+1);
x=sum(All_DisVector(idx==i))/size(All_DisVector(idx==i),1);
    Dis_weight(i)=gaussmf(x,[ScaleW 0]);
end

end

