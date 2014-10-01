function [ Sal_weight ] = GetSalWeight( ctrs ,idx)
%GETSALWEIGHT Summary of this function goes here

bin_num=size(ctrs,1);
bin_weight=zeros(bin_num,1);
for i=1:bin_num
    bin_weight(i)=size(find(idx==i),1);
end
bin_weight=bin_weight/size(idx,1);
Y = squareform(pdist(ctrs)).*repmat(bin_weight, [1, bin_num]);
Sal_weight=sum(Y)';
end

