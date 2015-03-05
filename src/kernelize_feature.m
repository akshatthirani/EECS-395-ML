function [ h ] = kernelize_feature( D, x, kmap )
%generate_kernel_mapping Transform vector into kernel feature space

h = size(1, size(D,2));
for i=1:size(D,2)
    h(1, i) = kmap(D(:,i), x);
end

end

