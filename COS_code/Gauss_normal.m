function [ output_args ] = Gauss_normal( input_args )
%GAUSS_NORMAL Summary of this function goes here
%   Detailed explanation goes here

output_args=input_args;

[H W]=size(input_args);
if W==1
%     output_args = 1 ./ (1 + exp(-input_args+max(input_args)/2));
    output_args=gaussmf(input_args,[(max(input_args)-min(input_args))/2 max(input_args)]);
else
    if H==W
        output_args=gaussmf(input_args,[(max(max(input_args))-min(min(input_args)))/2 max(max(input_args))]);
% output_args = 1 ./ (1 + exp(-input_args+max(max(input_args))/2));
    else
        for i = 1: W/H
            output_args(:,H*(i-1)+1:H*(i))=gaussmf(input_args(:,H*(i-1)+1:H*(i)),...
                [(max(max(input_args(:,H*(i-1)+1:H*(i))))-min(min(input_args(:,H*(i-1)+1:H*(i)))))...
                /2 max(max(input_args(:,H*(i-1)+1:H*(i))))]);
% output_args(:,H*(i-1)+1:H*(i))= 1 ./ (1 + exp(-input_args(:,H*(i-1)+1:H*(i))...
%     +max(max(input_args(:,H*(i-1)+1:H*(i))))/2));
        end
    end
end
end

