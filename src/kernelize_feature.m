function [ h ] = kernelize_feature( D, x, kmap )
%generate_kernel_mapping Transform vector into kernel feature space

h = size(size(D,2),1);
for i=1:size(D,2)
    h(i) = kmap(D(:,i), x);
end

end

