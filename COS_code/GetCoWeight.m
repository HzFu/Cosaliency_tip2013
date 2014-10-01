function [ co_weight] = GetCoWeight( idx, ScaleH, ScaleW )
% Get the co-weight between images

    Image_num = size(idx,1)/( ScaleH* ScaleW);
    Bin_num = max(idx);
    Img_Idx = reshape(idx, ScaleH,  ScaleW*Image_num);

    Bin_Idx=zeros(Bin_num, Image_num);
    for i=1:Bin_num
        for j=1:Image_num
            Bin_Idx(i,j)=size(Img_Idx(Img_Idx(:, ScaleW*(j-1)+1:ScaleW*j)==i),1)/size(Img_Idx(Img_Idx==i),1);
        end
    end

    co_weight=zeros(Bin_num,1);
    for j=1:Bin_num
        Bin_Idx(j,:)=Bin_Idx(j,:)/sum(Bin_Idx(j,:));
         co_weight(j)=mean((Bin_Idx(j,:)))/(std(Bin_Idx(j,:))+1);
    end

end

