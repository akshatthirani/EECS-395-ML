function [ H ] = generate_kernel( D, kmap_str )
%generate_kernel Generates a kernel matrix based on specified kmap_str

N = size(D,2);
H = size(N);
kmap = generate_kmap(kmap_str);
for i=1:N
   for j=i:N
      H(i,j) = kmap(D(:,i),D(:,j));
      H(j,i) = H(i,j);
   end
end

end

